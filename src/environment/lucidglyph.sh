# Embolden small and medium sized fonts to make them easier to read.
# Copyright (C) 2023-2025  Max Gashutin <maximilionuss@gmail.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Includes the safe font drivers tweaks, with stem-darkening disabled for the
# small font sizes in autofitter driver.

# FreeType documentation on stem darkening:
# https://freetype.org/freetype2/docs/reference/ft2-properties.html#no-stem-darkening

export FREETYPE_PROPERTIES=\
"autofitter:no-stem-darkening=0\
 autofitter:darkening-parameters=500,0,1000,500,2500,500,4000,0\
 cff:no-stem-darkening=0\
 cff:darkening-parameters=500,475,1000,475,2500,475,4000,0\
 type1:no-stem-darkening=0\
 type1:darkening-parameters=500,475,1000,475,2500,475,4000,0\
 t1cid:no-stem-darkening=0\
 t1cid:darkening-parameters=500,475,1000,475,2500,475,4000,0"
