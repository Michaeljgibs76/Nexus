import SwiftUI

/// Compact bias meter shown on story cards and in the detail screen.
struct BiasRatingView: View {

    let story: NewsStory
    /// When `true`, show the keyword chips row beneath the bar.
    var showKeywords: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            headerRow
            meterBar
            if showKeywords && !story.biasKeywords.isEmpty {
                keywordChips
            }
        }
    }

    // MARK: - Sub-views

    private var headerRow: some View {
        HStack(spacing: 6) {
            Image(systemName: biasIcon)
                .font(.caption)
                .foregroundColor(story.biasColor)

            Text(story.viewpoint.slantLabel)
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Text(story.biasLabel)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(story.biasColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(story.biasColor.opacity(0.15))
                .cornerRadius(6)

            Text("\(story.biasPercentage)%")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(story.biasColor)
                .frame(width: 36, alignment: .trailing)
        }
    }

    private var meterBar: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Track
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemFill))
                    .frame(height: 7)
                // Fill
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [story.biasColor.opacity(0.65), story.biasColor],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * story.biasScore, height: 7)
                    .animation(.easeOut(duration: 0.9), value: story.biasScore)
            }
        }
        .frame(height: 7)
    }

    private var keywordChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(story.biasKeywords.prefix(5), id: \.self) { kw in
                    Text(kw)
                        .font(.caption2)
                        .foregroundColor(story.biasColor)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(story.biasColor.opacity(0.10))
                        .cornerRadius(4)
                }
            }
        }
    }

    // MARK: - Helpers

    private var biasIcon: String {
        switch story.biasScore {
        case 0..<0.20: return "checkmark.circle"
        case 0.20..<0.50: return "exclamationmark.circle"
        case 0.50..<0.75: return "exclamationmark.triangle"
        default:           return "exclamationmark.octagon.fill"
        }
    }
}
