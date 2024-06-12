# Embolden small and medium sized fonts to make them easier to read.
# Official docs:
# - https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening
#
# Full version includes all the possible tweaks to all the font drivers.
export FREETYPE_PROPERTIES=\
"autofitter:no-stem-darkening=0\
 autofitter:darkening-parameters=500,475,1000,400,1500,400,2333,0\
 cff:no-stem-darkening=0\
 cff:darkening-parameters=500,475,1000,400,1500,400,2333,0\
 type1:no-stem-darkening=0\
 type1:darkening-parameters=500,475,1000,400,1500,400,2333,0\
 t1cid:no-stem-darkening=0\
 t1cid:darkening-parameters=500,475,1000,400,1500,400,2333,0"
