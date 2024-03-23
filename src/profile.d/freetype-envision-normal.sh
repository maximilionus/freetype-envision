# Embolden fonts to make them easier to read (mimic the macOS rendering style).
# Official docs:
# - https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening
#
# Normal version includes only the safe tweaks to the font drivers, with
# stem-darkening disabled for 'cff' driver and no stem darkening for
# the small font sizes.
export FREETYPE_PROPERTIES=\
"autofitter:no-stem-darkening=0\
 autofitter:darkening-parameters=500,0,1000,400,1250,250,1500,225\
 type1:no-stem-darkening=0\
 t1cid:no-stem-darkening=0"
