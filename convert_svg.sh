#!/bin/bash

# Convert SVG to PNG at dimensions for 600dpi (3.86" x 8.39")
rsvg-convert -w 2316 -h 5034 rack_page1.svg > rack_page1.png

# Set the DPI metadata
convert rack_page1.png -units PixelsPerInch -density 600 rack_page1_final.png && mv rack_page1_final.png rack_page1.png
