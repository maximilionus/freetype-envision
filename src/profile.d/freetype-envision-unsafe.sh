# Embolden fonts to make them easier to read (mimic the macOS rendering style).
# Official docs:
# - https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening
#
# Unsafe version does embolden very small font sizes and may cause the
# icons emboldening issue.
export FREETYPE_PROPERTIES="autofitter:no-stem-darkening=0\
 autofitter:darkening-parameters=500,450,1000,400,1250,250,1500,0\
 cff:no-stem-darkening=0"
