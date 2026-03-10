import SwiftUI

struct NewsStoryCard: View {

    let story: NewsStory

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // ── Meta row ─────────────────────────────────────────────────
            HStack(spacing: 6) {
                // Source
                Label(story.source, systemImage: "globe")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                Spacer()

                // Category
                Label(story.category, systemImage: story.categoryIcon)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("·")
                    .foregroundColor(.secondary)

                // Date
                Text(story.formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.top, 14)
            .padding(.bottom, 9)

            // ── Headline ─────────────────────────────────────────────────
            Text(story.title)
                .font(.headline)
                .fontWeight(.semibold)
                .lineLimit(3)
                .foregroundColor(.primary)
                .padding(.horizontal, 14)
                .padding(.bottom, 7)

            // ── Summary ──────────────────────────────────────────────────
            Text(story.summary)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .padding(.horizontal, 14)
                .padding(.bottom, 14)

            Divider()
                .padding(.horizontal, 14)

            // ── Bias meter ───────────────────────────────────────────────
            BiasRatingView(story: story, showKeywords: true)
                .padding(14)
        }
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
