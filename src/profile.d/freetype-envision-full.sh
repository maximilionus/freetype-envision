# Embolden fonts to make them easier to read (mimic the macOS rendering style).
# Official docs:
# - https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening
#
# Full version includes all the possible tweaks to the font engine,
# including the disabled font hinting and stem-darkening enabled for
# all the font types.
export FREETYPE_PROPERTIES=\
"autofitter:no-stem-darkening=0\
 cff:no-stem-darkening=0\
 type1:no-stem-darkening=0\
 t1cid:no-stem-darkening=0"
