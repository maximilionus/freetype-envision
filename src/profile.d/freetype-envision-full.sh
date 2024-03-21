# Embolden fonts to make them easier to read (mimic the macOS rendering style).
# Official docs:
# - https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening
#
# Full version includes all the possible tweaks to all the font drivers.
export FREETYPE_PROPERTIES=\
"autofitter:no-stem-darkening=0\
 autofitter:darkening-parameters=500,450,1000,400,1500,250,2000,0\
 cff:no-stem-darkening=0\
 type1:no-stem-darkening=0\
 t1cid:no-stem-darkening=0"
