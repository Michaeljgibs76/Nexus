import GoogleMobileAds
import SwiftUI
import UIKit

/// A SwiftUI wrapper around `GADNativeAdView` that renders a native ad
/// in a card style matching the NexusNews design language.
struct NativeAdView: UIViewRepresentable {

    @ObservedObject var viewModel: NativeAdViewModel

    func makeUIView(context: Context) -> NativeAdViewContainer {
        let container = NativeAdViewContainer()
        return container
    }

    func updateUIView(_ container: NativeAdViewContainer, context: Context) {
        guard let nativeAd = viewModel.nativeAd else { return }
        container.populate(with: nativeAd)
    }
}

// MARK: - NativeAdViewContainer (UIKit)

/// A programmatically-built `GADNativeAdView` subclass styled to match
/// the NexusNews card aesthetic. No XIB required.
final class NativeAdViewContainer: UIView {

    // MARK: - UI Elements

    private let nativeAdView = NativeAdView_GAD()

    private let adLabel: UILabel = {
        let label = UILabel()
        label.text = "Ad"
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .white
        label.backgroundColor = UIColor.systemOrange
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 6
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.numberOfLines = 2
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let advertiserLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ctaButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false // SDK handles taps
        return button
    }()

    private let mediaView: GADMediaView = {
        let mv = GADMediaView()
        mv.contentMode = .scaleAspectFill
        mv.layer.cornerRadius = 10
        mv.layer.masksToBounds = true
        mv.translatesAutoresizingMaskIntoConstraints = false
        return mv
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    // MARK: - Layout

    private func setupLayout() {
        backgroundColor = .clear
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nativeAdView)

        // Card background
        nativeAdView.backgroundColor = .secondarySystemGroupedBackground
        nativeAdView.layer.cornerRadius = 16
        nativeAdView.layer.shadowColor = UIColor.black.cgColor
        nativeAdView.layer.shadowOpacity = 0.06
        nativeAdView.layer.shadowRadius = 8
        nativeAdView.layer.shadowOffset = CGSize(width: 0, height: 2)

        // Add subviews to nativeAdView
        nativeAdView.addSubview(adLabel)
        nativeAdView.addSubview(iconImageView)
        nativeAdView.addSubview(headlineLabel)
        nativeAdView.addSubview(bodyLabel)
        nativeAdView.addSubview(advertiserLabel)
        nativeAdView.addSubview(ctaButton)
        nativeAdView.addSubview(mediaView)

        // Register asset views
        nativeAdView.headlineView = headlineLabel
        nativeAdView.bodyView = bodyLabel
        nativeAdView.iconView = iconImageView
        nativeAdView.advertiserView = advertiserLabel
        nativeAdView.callToActionView = ctaButton
        nativeAdView.mediaView = mediaView

        NSLayoutConstraint.activate([
            // nativeAdView fills container
            nativeAdView.topAnchor.constraint(equalTo: topAnchor),
            nativeAdView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nativeAdView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nativeAdView.bottomAnchor.constraint(equalTo: bottomAnchor),

            // Ad label (top-left)
            adLabel.topAnchor.constraint(equalTo: nativeAdView.topAnchor, constant: 12),
            adLabel.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 14),
            adLabel.widthAnchor.constraint(equalToConstant: 22),
            adLabel.heightAnchor.constraint(equalToConstant: 16),

            // Icon (top-left, after ad label)
            iconImageView.topAnchor.constraint(equalTo: adLabel.bottomAnchor, constant: 10),
            iconImageView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 14),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),

            // Headline (right of icon)
            headlineLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor),
            headlineLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            headlineLabel.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -14),

            // Advertiser (below headline)
            advertiserLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 2),
            advertiserLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            advertiserLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),

            // Media view (below icon/headline row)
            mediaView.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 12),
            mediaView.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 14),
            mediaView.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -14),
            mediaView.heightAnchor.constraint(equalToConstant: 160),

            // Body (below media)
            bodyLabel.topAnchor.constraint(equalTo: mediaView.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 14),
            bodyLabel.trailingAnchor.constraint(equalTo: nativeAdView.trailingAnchor, constant: -14),

            // CTA button (below body)
            ctaButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            ctaButton.leadingAnchor.constraint(equalTo: nativeAdView.leadingAnchor, constant: 14),
            ctaButton.bottomAnchor.constraint(equalTo: nativeAdView.bottomAnchor, constant: -14),
        ])
    }

    // MARK: - Populate

    func populate(with nativeAd: GADNativeAd) {
        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body
        bodyLabel.isHidden = nativeAd.body == nil

        iconImageView.image = nativeAd.icon?.image
        iconImageView.isHidden = nativeAd.icon == nil

        advertiserLabel.text = nativeAd.advertiser
        advertiserLabel.isHidden = nativeAd.advertiser == nil

        ctaButton.setTitle(nativeAd.callToAction, for: .normal)
        ctaButton.isHidden = nativeAd.callToAction == nil

        mediaView.mediaContent = nativeAd.mediaContent

        nativeAdView.nativeAd = nativeAd
    }
}

// MARK: - GADNativeAdView Subclass (type alias to avoid naming conflict)

/// Thin subclass to use as the registered GADNativeAdView in the hierarchy.
private final class NativeAdView_GAD: GADNativeAdView {}
