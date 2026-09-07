// James's temporary GA4 destination; Josh's Google Ads configuration is separate.
(() => {
    'use strict';
    if (location.protocol !== 'https:' ||
        !['arizonamedicalmarketing.com', 'www.arizonamedicalmarketing.com'].includes(location.hostname)) return;

    // This static site has no dynamic routes. Never collect query strings,
    // fragments, unknown paths, form values, or contact-link destinations.
    const paths = ['/', '/index.html', '/card.html', '/privacy.html'];
    if (!paths.includes(location.pathname)) return;
    let referrer = '';
    try {
        const url = new URL(document.referrer);
        if (['https:', 'http:'].includes(url.protocol)) referrer = url.origin + '/';
    } catch (_) { /* A direct visit has no referrer. */ }

    gtag('config', 'G-4321EF27Y6', {
        page_location: location.origin + location.pathname,
        page_referrer: referrer,
        allow_google_signals: false,
        allow_ad_personalization_signals: false,
        // Keep this destination out of the existing default event group.
        groups: 'amm_analytics'
    });
})();
