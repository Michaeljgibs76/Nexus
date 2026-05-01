/**
 * NexusNews Web - React Native Ad Component
 * 
 * A React component that renders a Google AdSense in-feed native ad
 * styled to match the NexusNews card design.
 * 
 * Usage:
 *   <NativeAdCard adClient="ca-pub-XXXXXXXXXXXXXXXX" adSlot="XXXXXXXXXX" />
 */

import React, { useEffect, useRef } from 'react';

interface NativeAdCardProps {
    /** Your AdSense publisher ID (e.g., "ca-pub-XXXXXXXXXXXXXXXX") */
    adClient?: string;
    /** Your ad slot ID */
    adSlot?: string;
    /** Ad layout key for in-feed format */
    adLayoutKey?: string;
    /** Additional CSS class names */
    className?: string;
}

declare global {
    interface Window {
        adsbygoogle: Array<Record<string, unknown>>;
    }
}

export const NativeAdCard: React.FC<NativeAdCardProps> = ({
    adClient = 'ca-pub-XXXXXXXXXXXXXXXX',
    adSlot = 'XXXXXXXXXX',
    adLayoutKey = '-fb+5w+4e-db+86',
    className = '',
}) => {
    const adRef = useRef<HTMLModElement>(null);
    const isAdLoaded = useRef(false);

    useEffect(() => {
        if (isAdLoaded.current) return;

        try {
            (window.adsbygoogle = window.adsbygoogle || []).push({});
            isAdLoaded.current = true;
        } catch (error) {
            console.warn('[NexusNews Ads] Failed to load ad:', error);
        }
    }, []);

    return (
        <div className={`native-ad-card ${className}`}>
            <span className="ad-badge">Ad</span>
            <div className="ad-container ad-in-feed">
                <ins
                    ref={adRef}
                    className="adsbygoogle"
                    style={{ display: 'block' }}
                    data-ad-format="fluid"
                    data-ad-layout-key={adLayoutKey}
                    data-ad-client={adClient}
                    data-ad-slot={adSlot}
                />
            </div>
        </div>
    );
};

/**
 * Hook to insert native ads at regular intervals in a list.
 * Returns a new array with ad placeholders inserted.
 */
export function useNativeAdsInFeed<T>(
    items: T[],
    options: { storiesPerAd?: number; maxAds?: number } = {}
): (T | { type: 'ad'; key: string })[] {
    const { storiesPerAd = 5, maxAds = 4 } = options;

    if (items.length < 3) return items;

    const result: (T | { type: 'ad'; key: string })[] = [];
    let adCount = 0;
    let storyCount = 0;

    for (const item of items) {
        result.push(item);
        storyCount++;

        if (storyCount === storiesPerAd && adCount < maxAds) {
            result.push({ type: 'ad', key: `native-ad-${adCount}` });
            storyCount = 0;
            adCount++;
        }
    }

    return result;
}

export default NativeAdCard;
