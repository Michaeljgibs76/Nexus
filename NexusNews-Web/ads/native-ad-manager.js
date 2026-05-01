/**
 * NexusNews Web - Native Ad Manager
 * 
 * Dynamically inserts Google AdSense in-feed native ads between news story cards.
 * Designed to match the NexusNews card aesthetic and respect user experience.
 * 
 * Usage:
 *   import { NativeAdManager } from './native-ad-manager.js';
 *   const adManager = new NativeAdManager({
 *     adClient: 'ca-pub-XXXXXXXXXXXXXXXX',
 *     adSlot: 'XXXXXXXXXX',
 *     storiesPerAd: 5,
 *     maxAds: 4,
 *     containerSelector: '.news-feed'
 *   });
 *   adManager.insertAds();
 */

export class NativeAdManager {
    constructor(options = {}) {
        this.adClient = options.adClient || 'ca-pub-XXXXXXXXXXXXXXXX';
        this.adSlot = options.adSlot || 'XXXXXXXXXX';
        this.storiesPerAd = options.storiesPerAd || 5;
        this.maxAds = options.maxAds || 4;
        this.containerSelector = options.containerSelector || '.news-feed';
        this.adLayoutKey = options.adLayoutKey || '-fb+5w+4e-db+86';
        this.adsEnabled = options.adsEnabled !== false;
    }

    /**
     * Inserts native ad cards between news story cards in the feed.
     * Call this after the news feed has been rendered.
     */
    insertAds() {
        if (!this.adsEnabled) return;

        const container = document.querySelector(this.containerSelector);
        if (!container) {
            console.warn('[NexusNews Ads] Container not found:', this.containerSelector);
            return;
        }

        const storyCards = container.querySelectorAll('.news-card');
        if (storyCards.length < 3) return; // Don't show ads in very short feeds

        let adsInserted = 0;
        let storyCount = 0;

        storyCards.forEach((card, index) => {
            storyCount++;

            if (storyCount === this.storiesPerAd && adsInserted < this.maxAds) {
                const adElement = this._createAdElement();
                card.parentNode.insertBefore(adElement, card.nextSibling);
                storyCount = 0;
                adsInserted++;
            }
        });

        // Push all ad units to AdSense
        this._activateAds();
    }

    /**
     * Creates a native ad card DOM element matching the NexusNews design.
     */
    _createAdElement() {
        const wrapper = document.createElement('div');
        wrapper.className = 'native-ad-card';
        wrapper.innerHTML = `
            <span class="ad-badge">Ad</span>
            <div class="ad-container ad-in-feed">
                <ins class="adsbygoogle"
                    style="display:block"
                    data-ad-format="fluid"
                    data-ad-layout-key="${this.adLayoutKey}"
                    data-ad-client="${this.adClient}"
                    data-ad-slot="${this.adSlot}"></ins>
            </div>
        `;
        return wrapper;
    }

    /**
     * Activates all pending AdSense ad units on the page.
     */
    _activateAds() {
        const pendingAds = document.querySelectorAll('.adsbygoogle:not([data-adsbygoogle-status])');
        pendingAds.forEach(() => {
            try {
                (window.adsbygoogle = window.adsbygoogle || []).push({});
            } catch (e) {
                console.warn('[NexusNews Ads] AdSense push error:', e);
            }
        });
    }

    /**
     * Removes all ad cards from the feed (useful for premium users).
     */
    removeAllAds() {
        const container = document.querySelector(this.containerSelector);
        if (!container) return;

        const adCards = container.querySelectorAll('.native-ad-card');
        adCards.forEach(card => card.remove());
    }

    /**
     * Refreshes ads (e.g., after loading more stories via infinite scroll).
     */
    refreshAds() {
        this.removeAllAds();
        this.insertAds();
    }
}

// Auto-initialize if used as a standalone script
if (typeof window !== 'undefined' && window.NEXUS_AD_CONFIG) {
    const manager = new NativeAdManager(window.NEXUS_AD_CONFIG);
    document.addEventListener('DOMContentLoaded', () => manager.insertAds());
}
