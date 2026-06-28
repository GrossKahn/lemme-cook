# Assets

## Liste

- Fridge
- Countertop
- Cupboard
- Stove

- Cutting Board

- Spices

- Food
  - Burgers
  - Noodledish
  - Salad

## Credits

- fridge - Photo by <a href="https://unsplash.com/@raymondpetrik?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Raymond Petrik</a> on <a href="https://unsplash.com/photos/a-white-refrigerator-freezer-sitting-on-top-of-a-wooden-floor-5CJlOhMCOMY?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

- stove and cupboards - Photo by <a href="https://unsplash.com/@introspectivedsgn?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Erik Mclean</a> on <a href="https://unsplash.com/photos/white-and-black-gas-range-oven-aPoF91L-n6k?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

- floor - Photo by <a href="https://unsplash.com/@catrionaobrian?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Ekaterina Novitskaya</a> on <a href="https://unsplash.com/photos/brown-wooden-wall-during-daytime-KugwNl9jX1Q?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

- brickwall - Photo by <a href="https://unsplash.com/@waldemarbrandt67w?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Waldemar Brandt</a> on <a href="https://unsplash.com/photos/brown-brick-wall-rhaS97NhnHg?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

- tiled wall - <https://www.manytextures.com/texture/148/old-tiles/>

- lamp - Photo by <a href="https://unsplash.com/@kr8v?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Sarmad Hashmi</a> on <a href="https://unsplash.com/photos/black-pendant-lamp-turned-on-in-room-3tbEf5O8XXA?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

- window - Photo by <a href="https://unsplash.com/@anniespratt?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Annie Spratt</a> on <a href="https://unsplash.com/photos/window-overlooking-green-trees-x-cEGE4dw8Q?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>
- paper - Photo by <a href="https://unsplash.com/@sjobjio?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">SJ Objio</a> on <a href="https://unsplash.com/photos/crumpled-beige-parchment-paper-texture-XFWiZTa2Ub0?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>

## magick befehle

### Spritesheet

- anzahl der tiles anpassen
  magick montage -tile 2x1 -geometry +0+0 -background transparent \*.png spritesheet.png

### Psx|Pixelieren

magick input.png -resize 120x120 -interpolate 'Nearest' -colors 256 -dither FloydSteinberg -channel A -threshold 50 output.png
