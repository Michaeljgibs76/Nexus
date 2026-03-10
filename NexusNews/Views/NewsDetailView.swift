import SwiftUI

struct NewsDetailView: View {

    let story: NewsStory
    @State private var showShareSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {

                // ── Hero banner ──────────────────────────────────────────
                heroHeader

                // ── Bias analysis card (overlaps banner) ────────────────
                biasAnalysisCard
                    .padding(.horizontal)
                    .padding(.top, -20)

                // ── Article body ─────────────────────────────────────────
                articleBody
                    .padding(.horizontal)
                    .padding(.top, 20)

                // ── Bias-indicator keywords ──────────────────────────────
                if !story.biasKeywords.isEmpty {
                    keywordsSection
                        .padding(.horizontal)
                        .padding(.top, 20)
                }

                Spacer(minLength: 48)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button { showShareSheet = true } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [story.title, story.sourceURL])
        }
        .tint(story.viewpoint.color)
    }

    // MARK: - Hero

    private var heroHeader: some View {
        ZStack(alignment: .bottomLeading) {
            story.viewpoint.gradient
                .frame(height: 220)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    categoryBadge
                    viewpointBadge
                }

                Text(story.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .lineLimit(5)
                    .padding(.bottom, 2)

                HStack(spacing: 6) {
                    Text(story.source)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.88))
                    Text("·")
                        .foregroundColor(.white.opacity(0.5))
                    Text(story.formattedDate)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.70))
                }
            }
            .padding()
        }
    }

    private var categoryBadge: some View {
        Label(story.category, systemImage: story.categoryIcon)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white.opacity(0.90))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.22))
            .cornerRadius(8)
    }

    private var viewpointBadge: some View {
        Label(story.viewpoint.rawValue, systemImage: story.viewpoint.tabIcon)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white.opacity(0.90))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.22))
            .cornerRadius(8)
    }

    // MARK: - Bias Analysis Card

    private var biasAnalysisCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Bias Analysis", systemImage: "chart.bar.xaxis")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text("\(story.biasPercentage)% · \(story.biasLabel)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(story.biasColor)
            }

            // Full-spectrum gradient meter
            VStack(spacing: 5) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(.systemFill))
                            .frame(height: 12)

                        // Color ramp from green → yellow → orange → red
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [.green, .yellow, .orange, .red],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 12)
                            .mask(
                                HStack(spacing: 0) {
                                    Rectangle()
                                        .frame(width: geo.size.width * story.biasScore)
                                    Spacer(minLength: 0)
                                }
                            )

                        // Thumb indicator
                        Circle()
                            .fill(Color.white)
                            .frame(width: 16, height: 16)
                            .shadow(radius: 2)
                            .offset(x: max(0, geo.size.width * story.biasScore - 8))
                    }
                }
                .frame(height: 16)

                HStack {
                    Text("Low Bias")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("High Bias")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Text(story.biasExplanation)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 4)
    }

    // MARK: - Article Body

    private var articleBody: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Summary")
                .font(.headline)

            Text(story.summary)
                .font(.body)
                .lineSpacing(5)

            Divider()

            Text(story.content)
                .font(.body)
                .foregroundColor(.secondary)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            // Source link
            if let url = URL(string: story.sourceURL) {
                Link(destination: url) {
                    HStack {
                        Image(systemName: "link")
                        Text("Read full story at \(story.source)")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                    }
                    .font(.subheadline)
                    .foregroundColor(story.viewpoint.color)
                    .padding()
                    .background(story.viewpoint.color.opacity(0.08))
                    .cornerRadius(12)
                }
            }
        }
    }

    // MARK: - Keywords

    private var keywordsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Bias Indicators", systemImage: "tag.fill")
                .font(.headline)
                .foregroundColor(.primary)

            Text("Words and phrases that contributed to the bias rating:")
                .font(.caption)
                .foregroundColor(.secondary)

            FlowLayout(spacing: 8) {
                ForEach(story.biasKeywords, id: \.self) { kw in
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.caption2)
                        Text(kw)
                            .font(.caption)
                    }
                    .foregroundColor(story.biasColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(story.biasColor.opacity(0.12))
                    .cornerRadius(8)
                }
            }
        }
    }
}

// MARK: - FlowLayout (iOS 16+ Layout protocol)

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = makeRows(proposal: proposal, subviews: subviews)
        let totalHeight = rows.reduce(0.0) { acc, row in
            let h = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            return acc + h + spacing
        } - spacing
        return CGSize(width: proposal.width ?? 0, height: max(totalHeight, 0))
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = makeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            let rowH = row.map { $0.sizeThatFits(.unspecified).height }.max() ?? 0
            var x = bounds.minX
            for sv in row {
                let size = sv.sizeThatFits(.unspecified)
                sv.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += rowH + spacing
        }
    }

    private func makeRows(proposal: ProposedViewSize, subviews: Subviews) -> [[LayoutSubview]] {
        var rows: [[LayoutSubview]] = [[]]
        var rowWidth: CGFloat = 0
        let maxW = proposal.width ?? .infinity

        for sv in subviews {
            let w = sv.sizeThatFits(.unspecified).width
            if rowWidth + w > maxW, !rows.last!.isEmpty {
                rows.append([])
                rowWidth = 0
            }
            rows[rows.count - 1].append(sv)
            rowWidth += w + spacing
        }
        return rows
    }
}
