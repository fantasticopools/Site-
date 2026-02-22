#!/usr/bin/env node
/**
 * Fantastico Pools — Static Site Build Script
 * 
 * Reads data.json and injects content into index.html,
 * then copies everything needed into dist/ for deployment.
 *
 * Usage:
 *   node build.js          — build to dist/
 */

const fs   = require('fs');
const path = require('path');

const ROOT = __dirname;
const DIST = path.join(ROOT, 'dist');
const DATA = JSON.parse(fs.readFileSync(path.join(ROOT, 'data.json'), 'utf8'));

// ─── Helpers ────────────────────────────────────────────────

function ensureDir(dir) {
    fs.mkdirSync(dir, { recursive: true });
}

function copyFile(src, dest) {
    ensureDir(path.dirname(dest));
    fs.copyFileSync(src, dest);
}

function copyDir(src, dest) {
    if (!fs.existsSync(src)) return;
    ensureDir(dest);
    for (const entry of fs.readdirSync(src)) {
        const s = path.join(src, entry);
        const d = path.join(dest, entry);
        if (fs.statSync(s).isDirectory()) {
            copyDir(s, d);
        } else {
            fs.copyFileSync(s, d);
        }
    }
}

function rmDir(dir) {
    if (fs.existsSync(dir)) {
        fs.rmSync(dir, { recursive: true, force: true });
    }
}

function esc(s) {
    // Escape for safe insertion into HTML attributes / JS strings
    return String(s).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
}

function escJS(s) {
    // Escape for JS string (single-quoted)
    return String(s).replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/\n/g, '\\n');
}

// ─── Generate HTML Sections ─────────────────────────────────

function buildTrustStrip() {
    return DATA.trustStrip.map((item, i) => {
        const divider = i > 0 ? '                <div class="trust-divider"></div>\n' : '';
        return divider +
`                <div class="trust-item">
                    <i class="bi ${item.icon}"></i>
                    <span>${item.text}</span>
                </div>`;
    }).join('\n');
}

function buildShowcaseDataJS() {
    const lines = DATA.showcase.items.map(item => {
        if (item.type === 'video') {
            return `            { type: 'video', src: '${escJS(item.src)}', thumb: '${escJS(item.thumb)}', title: '${escJS(item.title)}', description: '${escJS(item.description)}' }`;
        }
        return `            { type: 'photo', src: '${escJS(item.src)}', title: '${escJS(item.title)}', description: '${escJS(item.description)}' }`;
    });
    return lines.join(',\n');
}

function buildServices() {
    return DATA.about.services.map((svc, i) => {
        const delay = (i + 1) * 100;
        return `                <div class="col-md-4" data-aos="fade-up" data-aos-delay="${delay}">
                    <div class="card h-100 shadow-sm border-0">
                        <div class="card-body text-center">
                            <i class="bi ${svc.icon} fs-1 text-primary mb-3 d-block"></i>
                            <h5 class="fw-semibold">${svc.title}</h5>
                            <p class="text-muted small">${svc.text}</p>
                        </div>
                    </div>
                </div>`;
    }).join('\n\n');
}

function buildProcessSteps() {
    return DATA.process.steps.map((step, i) => {
        const delay = (i + 1) * 100;
        return `                <div class="col-md-6 col-lg-3 text-center" data-aos="fade-up" data-aos-delay="${delay}">
                    <div class="mb-3">
                        <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center"
                            style="width: 60px; height: 60px;">
                            <span class="fs-4 fw-bold">${step.number}</span>
                        </div>
                    </div>
                    <h5 class="fw-semibold">${step.title}</h5>
                    <p class="text-muted small">${step.text}</p>
                    <small class="text-primary fw-semibold">${step.duration}</small>
                </div>`;
    }).join('\n\n');
}

function buildFAQItems() {
    return DATA.faq.items.map((item, i) => {
        const idx   = i + 1;
        const delay = idx * 100;
        return `                        <div class="accordion-item border-0 shadow-sm mb-3" data-aos="fade-up" data-aos-delay="${delay}">
                            <h3 class="accordion-header">
                                <button class="accordion-button collapsed fw-semibold" type="button"
                                    data-bs-toggle="collapse" data-bs-target="#faq${idx}" aria-expanded="false"
                                    aria-controls="faq${idx}">
                                    <i class="bi bi-question-circle me-2 text-primary"></i>
                                    ${item.question}
                                </button>
                            </h3>
                            <div id="faq${idx}" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                                <div class="accordion-body">
                                    ${item.answer}
                                </div>
                            </div>
                        </div>`;
    }).join('\n\n');
}

// ─── Build the full HTML ────────────────────────────────────

function buildHTML() {
    // Read source HTML
    let html = fs.readFileSync(path.join(ROOT, 'index.html'), 'utf8');

    const d = DATA;

    // --- Site title ---
    html = html.replace(/<title>[^<]*<\/title>/, `<title>${d.site.title}</title>`);

    // --- Font ---
    html = html.replace(
        /font-family:\s*'[^']+',\s*sans-serif\s*!important/,
        `font-family: '${d.site.font}', sans-serif !important`
    );

    // --- Logo ---
    html = html.replace(
        /src="fplogo\.webp"/,
        `src="${d.site.logo}"`
    );
    html = html.replace(
        /<span class="navbar-brand-text">[^<]*<\/span>/,
        `<span class="navbar-brand-text">${d.site.title}</span>`
    );

    // --- Social links (navbar + contact area) ---
    if (d.site && d.site.social) {
        if (d.site.social.facebook) {
            html = html.replace(/href="https:\/\/facebook\.com\/[^"]*"/g, `href="${d.site.social.facebook}"`);
        }
        if (d.site.social.instagram) {
            html = html.replace(/href="https:\/\/instagram\.com\/[^"]*"/g, `href="${d.site.social.instagram}"`);
        }
    }

    // --- Hero ---
    html = html.replace(
        /(<img src=")[^"]*(" alt="Hero image")/,
        `$1${d.hero.image}$2`
    );
    // Hero badge
    html = html.replace(
        /(class="section-badge" style="margin-bottom: 1\.5rem;">)[^<]*/,
        `$1${d.hero.badge}`
    );
    // Hero heading
    html = html.replace(
        /(<h1 class="display-4 fw-bold mb-3">)[\s\S]*?(<\/h1>)/,
        `$1${d.hero.heading}$2`
    );
    // Hero subheading
    html = html.replace(
        /(<p class="lead mb-4">)[^<]*(<\/p>)/,
        `$1${d.hero.subheading}$2`
    );
    // Hero CTA
    html = html.replace(
        /(<a href=")[^"]*(" class="btn btn-outline-light btn-lg">)[^<]*/,
        `$1${d.hero.ctaLink}$2${d.hero.ctaText}`
    );

    // --- Trust Strip ---
    html = html.replace(
        /(<div class="trust-strip-inner">)[\s\S]*?(<\/div>\s*<\/div>\s*<\/div>\s*<\/section>)/,
        `$1\n${buildTrustStrip()}\n            $2`
    );

    // --- Showcase section texts ---
    html = html.replace(
        /(<span class="showcase-badge">)[^<]*/,
        `$1${d.showcase.badge}`
    );
    html = html.replace(
        /(<h2 class="showcase-title">)[^<]*/,
        `$1${d.showcase.title}`
    );
    html = html.replace(
        /(<p class="showcase-subtitle">)[^<]*/,
        `$1${d.showcase.subtitle}`
    );

    // --- Showcase JS data array ---
    html = html.replace(
        /(const showcaseData = \[)[\s\S]*?(\];)/,
        `$1\n${buildShowcaseDataJS()},\n        $2`
    );

    // --- About / Why Fantastico ---
    // Badge (first section-badge after "Who We Are" comment isn't reliable, target by section)
    html = html.replace(
        /(id="aboutus"[\s\S]*?<span class="section-badge">)[^<]*/,
        `$1${d.about.badge}`
    );
    html = html.replace(
        /(id="aboutus"[\s\S]*?<h2 class="section-title">)[^<]*/,
        `$1${d.about.title}`
    );
    html = html.replace(
        /(id="aboutus"[\s\S]*?<p class="section-subtitle">)[^<]*/,
        `$1${d.about.subtitle}`
    );
    // About description paragraph
    html = html.replace(
        /(id="aboutus"[\s\S]*?<p class="lead">)[\s\S]*?(<\/p>)/,
        `$1\n                        ${d.about.description}\n                    $2`
    );

    // --- Services cards ---
    html = html.replace(
        /(id="aboutus"[\s\S]*?<div class="row g-4" data-aos="fade-up">\n)[\s\S]*?(<!-- Financing CTA Banner -->)/,
        `$1${buildServices()}\n\n            </div>\n\n            $2`
    );

    // --- Financing CTA ---
    html = html.replace(
        /(<h5 class="fw-semibold mb-1">)[^<]*/,
        `$1${d.about.financing.title}`
    );
    html = html.replace(
        /(<p class="mb-0 small opacity-75">)[^<]*/,
        `$1${d.about.financing.text}`
    );

    // --- Process ---
    html = html.replace(
        /(id="process"[\s\S]*?<span class="section-badge">)[^<]*/,
        `$1${d.process.badge}`
    );
    html = html.replace(
        /(id="process"[\s\S]*?<h2 class="section-title[^"]*">)[^<]*/,
        `$1${d.process.title}`
    );
    html = html.replace(
        /(id="process"[\s\S]*?<p class="section-subtitle">)[^<]*/,
        `$1${d.process.subtitle}`
    );
    // Process steps
    html = html.replace(
        /(id="process"[\s\S]*?<div class="row g-4">\n)[\s\S]*?(<\/div>\s*<\/div>\s*<\/section>)/,
        `$1${buildProcessSteps()}\n            $2`
    );

    // --- FAQ ---
    html = html.replace(
        /(id="faq"[\s\S]*?<span class="section-badge">)[^<]*/,
        `$1${d.faq.badge}`
    );
    html = html.replace(
        /(id="faq"[\s\S]*?<h2 class="section-title">)[^<]*/,
        `$1${d.faq.title}`
    );
    html = html.replace(
        /(id="faq"[\s\S]*?<p class="section-subtitle">)[^<]*/,
        `$1${d.faq.subtitle}`
    );
    // FAQ items
    html = html.replace(
        /(id="faqAccordion">\n)[\s\S]*?(<\/div>\s*<\/div>\s*<\/div>\s*<\/div>\s*<\/section>)/,
        `$1${buildFAQItems()}\n                    $2`
    );

    // --- Contact ---
    html = html.replace(
        /(id="contact"[\s\S]*?<span class="section-badge">)[^<]*/,
        `$1${d.contact.badge}`
    );
    html = html.replace(
        /(id="contact"[\s\S]*?<h2 class="section-title">)[^<]*/,
        `$1${d.contact.title}`
    );
    html = html.replace(
        /(id="contact"[\s\S]*?<p class="section-subtitle">)[^<]*/,
        `$1${d.contact.subtitle}`
    );
    // Phone
    html = html.replace(
        /(<a href=")tel:[^"]*(" class="contact-card">[\s\S]*?<h5>Call or Text<\/h5>\s*<p class="contact-card-value">)[^<]*([\s\S]*?<span class="contact-card-hint">)[^<]*/,
        `$1${d.contact.phoneHref}$2${d.contact.phone}$3${d.contact.phoneHours}`
    );
    // Email
    html = html.replace(
        /(<a href=")mailto:[^"]*(" class="contact-card">[\s\S]*?<h5>Email Us<\/h5>\s*<p class="contact-card-value">)[^<]*([\s\S]*?<span class="contact-card-hint">)[^<]*/,
        `$1mailto:${d.contact.email}$2${d.contact.email}$3${d.contact.emailNote}`
    );
    // Service area
    html = html.replace(
        /(<h5>Service Area<\/h5>\s*<p class="contact-card-value">)[^<]*([\s\S]*?<span class="contact-card-hint">)[^<]*/,
        `$1${d.contact.serviceArea}$2${d.contact.serviceAreaDetail}`
    );
    // Urgency
    html = html.replace(
        /(class="contact-urgency"[\s\S]*?<span>)[\s\S]*?(<\/span>)/,
        `$1${d.contact.urgency}$2`
    );

    return html;
}

// ─── Collect Asset Files ────────────────────────────────────

function collectAssets() {
    const assets = new Set();

    // Logo
    assets.add(DATA.site.logo);

    // Hero image
    assets.add(DATA.hero.image);

    // Showcase items: src + thumb
    for (const item of DATA.showcase.items) {
        assets.add(item.src);
        if (item.thumb) assets.add(item.thumb);
    }

    // CSS
    assets.add('style.css');

    // Scan for any other referenced files in the built HTML
    // (thumbnails, etc.)
    return assets;
}

// ─── Main ───────────────────────────────────────────────────

function main() {
    console.log('  === build.js: START ===');

    ensureDir(DIST);

    // 1. Build HTML
    console.log('  Building index.html from data.json...');
    const html = buildHTML();
    fs.writeFileSync(path.join(DIST, 'index.html'), html, 'utf8');

    // 2. Copy assets referenced in data.json
    const assets = collectAssets();
    let copied = 0;
    for (const file of assets) {
        const src = path.join(ROOT, file);
        if (fs.existsSync(src)) {
            copyFile(src, path.join(DIST, file));
            copied++;
        } else {
            console.warn(`  ⚠ Asset not found: ${file}`);
        }
    }

    // 3. Copy entire webp/ directory (images)
    copyDir(path.join(ROOT, 'webp'), path.join(DIST, 'webp'));

    console.log(`  Copied ${copied} asset files + webp/ directory`);
    console.log(`  ✓ Build complete → dist/`);
    console.log(`\n  To deploy, upload the contents of dist/ to your web host.`);
    console.log('  === build.js: DONE ===');
}

main();
