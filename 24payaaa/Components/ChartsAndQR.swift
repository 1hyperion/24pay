import CoreImage.CIFilterBuiltins
import SwiftUI
import UIKit

struct StatisticsChart: View {
    let values: [Double]
    private let days = ["Mie.", "Joi", "Vin.", "S\u{00E2}m.", "Dum.", "Lun.", "Mar."]

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height
            let plotHeight = height - 40
            ZStack(alignment: .topLeading) {
                ForEach(0...10, id: \.self) { index in
                    let y = CGFloat(index) * plotHeight / 10
                    Rectangle()
                        .fill(.white.opacity(index == 10 ? 0.5 : 0.28))
                        .frame(height: 1)
                        .offset(x: 27, y: y)

                    Text(String(format: "%.1f", 1 - Double(index) / 10).replacingOccurrences(of: ".", with: ","))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(AppTheme.Color.muted)
                        .offset(x: 0, y: y - 8)
                }

                Rectangle()
                    .fill(.white.opacity(0.35))
                    .frame(width: 1, height: plotHeight)
                    .offset(x: 27)

                HStack(alignment: .bottom) {
                    ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                        VStack(spacing: 7) {
                            Text(values.indices.contains(index) ? "\(Int(values[index]))" : "0")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.white)
                            Text(day)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(AppTheme.Color.muted)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.leading, 36)
                .offset(y: plotHeight - 1)
                .frame(width: width)
            }
        }
        .frame(height: 575)
    }
}

struct SegmentedStatsPicker: View {
    @Binding var selected: Int
    private let icons = ["chart.bar", "chart.pie", "chart.line.uptrend.xyaxis"]

    var body: some View {
        HStack(spacing: 24) {
            ForEach(icons.indices, id: \.self) { index in
                Button {
                    selected = index
                } label: {
                    Image(systemName: icons[index])
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(selected == index ? AppTheme.Color.surface : AppTheme.Color.yellow)
                        .frame(width: 53, height: 53)
                        .background(selected == index ? AppTheme.Color.yellow : AppTheme.Color.surface)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

struct QRCodeView: View {
    let text: String
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        Image(uiImage: makeImage())
            .interpolation(.none)
            .resizable()
            .scaledToFit()
            .padding(18)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func makeImage() -> UIImage {
        filter.message = Data(text.utf8)
        filter.correctionLevel = "M"
        guard let output = filter.outputImage,
              let cgImage = context.createCGImage(output.transformed(by: CGAffineTransform(scaleX: 12, y: 12)), from: output.extent) else {
            return UIImage(systemName: "qrcode") ?? UIImage()
        }
        return UIImage(cgImage: cgImage)
    }
}

