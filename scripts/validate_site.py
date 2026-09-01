#!/usr/bin/env python3
"""Validate the deployable static site's required SEO and contact contracts."""

from html.parser import HTMLParser
import json
from pathlib import Path
import sys
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]
CANONICAL_URL = "https://arizonamedicalmarketing.com/"
FORM_ENDPOINT = "https://formspree.io/f/xpwzeprj"
GOOGLE_TAG_ID = "AW-18264316897"
GOOGLE_CONVERSION_DESTINATION = "AW-18264316897/IMgFCOzJrt0cEOG3jYVE"
REQUIRED_FILES = (
    "index.html",
    "logo.png",
    "medical-office-lobby.webp",
    "provider-networking-lunch.webp",
    "robots.txt",
    "sitemap.xml",
)


class SiteParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.canonical: str | None = None
        self.form_action: str | None = None
        self.form_fields: list[str] = []
        self.h1_parts: list[str] = []
        self.json_ld_parts: list[str] = []
        self.script_sources: list[str] = []
        self._in_h1 = False
        self._in_json_ld = False

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        values = dict(attrs)
        if tag == "link" and values.get("rel") == "canonical":
            self.canonical = values.get("href")
        elif tag == "form":
            self.form_action = values.get("action")
        elif tag in {"input", "textarea"} and values.get("name"):
            self.form_fields.append(values["name"] or "")
        elif tag == "h1":
            self._in_h1 = True
        elif tag == "script":
            source = values.get("src")
            if source:
                self.script_sources.append(source)
            self._in_json_ld = values.get("type") == "application/ld+json"

    def handle_endtag(self, tag: str) -> None:
        if tag == "h1":
            self._in_h1 = False
        elif tag == "script":
            self._in_json_ld = False

    def handle_data(self, data: str) -> None:
        if self._in_h1:
            self.h1_parts.append(data)
        if self._in_json_ld:
            self.json_ld_parts.append(data)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise ValueError(message)


def validate() -> None:
    missing = [name for name in REQUIRED_FILES if not (ROOT / name).is_file()]
    require(not missing, f"Missing required deploy files: {', '.join(missing)}")

    index_html = (ROOT / "index.html").read_text(encoding="utf-8")
    parser = SiteParser()
    parser.feed(index_html)

    require(parser.canonical == CANONICAL_URL, "Canonical URL is missing or incorrect")
    require(parser.form_action == FORM_ENDPOINT, "Formspree endpoint changed")
    require(parser.form_fields == ["name", "email", "message"], "Contact form fields changed")
    require(
        "Physician Referral Marketing" in " ".join(parser.h1_parts),
        "Search-focused H1 is missing",
    )
    google_tag_source = f"https://www.googletagmanager.com/gtag/js?id={GOOGLE_TAG_ID}"
    require(google_tag_source in parser.script_sources, "Google tag loader is missing")
    require(f"gtag('config', '{GOOGLE_TAG_ID}')" in index_html, "Google tag config is missing")
    require(
        f"'send_to': '{GOOGLE_CONVERSION_DESTINATION}'" in index_html,
        "Google Ads lead conversion event is missing",
    )
    require("onSuccess: ({ form })" in index_html, "Conversion event is not gated on form success")

    card_html = (ROOT / "card.html").read_text(encoding="utf-8")
    require(google_tag_source in card_html, "Business-card page is missing the Google tag")
    require(f"gtag('config', '{GOOGLE_TAG_ID}')" in card_html, "Business-card Google tag config is missing")

    structured_data = json.loads("".join(parser.json_ld_parts))
    require(structured_data.get("@type") == "ProfessionalService", "Unexpected JSON-LD type")
    require(structured_data.get("url") == CANONICAL_URL, "JSON-LD URL is incorrect")

    sitemap_root = ET.parse(ROOT / "sitemap.xml").getroot()
    namespace = {"s": "http://www.sitemaps.org/schemas/sitemap/0.9"}
    locations = [element.text for element in sitemap_root.findall("s:url/s:loc", namespace)]
    require(locations == [CANONICAL_URL], "Sitemap must contain only the canonical homepage")

    robots = (ROOT / "robots.txt").read_text(encoding="utf-8")
    require(
        "Sitemap: https://arizonamedicalmarketing.com/sitemap.xml" in robots,
        "robots.txt does not reference the canonical sitemap",
    )


if __name__ == "__main__":
    try:
        validate()
    except (OSError, ET.ParseError, json.JSONDecodeError, ValueError) as error:
        print(f"Site validation failed: {error}", file=sys.stderr)
        raise SystemExit(1)
    print("Static site validation passed")
