import SwiftUI

/// A SwiftUI card view that displays a native ad inline with the news feed.
/// Automatically loads an ad when it appears and matches the visual style
/// of `NewsStoryCard`.
struct NativeAdCard: View {

    @StateObject private var adViewModel = NativeAdViewModel()

    var body: some View {
        Group {
            if adViewModel.isAdLoaded {
                NativeAdView(viewModel: adViewModel)
                    .frame(minHeight: 320)
            } else {
                // Placeholder while ad loads — keeps layout stable
                adPlaceholder
            }
        }
        .onAppear {
            adViewModel.loadAd()
        }
    }

    // MARK: - Placeholder

    private var adPlaceholder: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Ad")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange)
                    .cornerRadius(4)
                Spacer()
            }

            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
                .frame(height: 160)
                .overlay(
                    ProgressView()
                        .tint(.gray)
                )

            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 120, height: 14)
                Spacer()
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
