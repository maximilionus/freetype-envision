# Embolden fonts to make them easier to read (mimic the macOS rendering style).
# Official docs:
# - https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening
#
# Safe version doesn't embolden very small font sizes to exclude
# icons emboldening issue.
export FREETYPE_PROPERTIES="autofitter:no-stem-darkening=0\
 autofitter:darkening-parameters=500,0,1000,400,1250,250,1500,0"
