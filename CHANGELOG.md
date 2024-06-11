## Release 0.3.0
### Tweaked
- Project license changed to the BSD-3-Clause. I don't think it makes sense to use a license as restrictive as the GPL.
- Stem-darkening value increased for the min. sized fonts in "Full" preset.


## Release 0.2.3
### Tweaked
- Stem-darkening values adjusted:
    - Improve the small-sized fonts visibility.
    - Reduced visual artifacts for medium-sized fonts.
    - Turned back on the darkening max. threshold for big-sized fonts.


## Release 0.2.2
### Tweaked
- Minor enhancements to the installation script.


## Release 0.2.1
### Fixed
- Problems with the lack of visual distinction between fonts of different weights on dark backgrounds.

### Tweaked
- The visibility of small font sizes has been slightly improved.


## Release 0.2.0
> [!IMPORTANT]  
> When upgrading from versions `0.1.*`, be sure to uninstall the previous installation with its `uninstall.sh` script. Because of some incompatible enhancements made to the project it no longer can work with previous version tweaks.

### New
- Revamped main script, everything in one place.
- Grayscale antialiasing enforcement is automated now, no manual actions required anymore.
- `cff` driver stem-darkening added to **full** preset.
- Enabled stem-darkening for `type1` and `t1cid` drivers.

### Tweaked
- Stem darkening values tweaked to enhance visibility.
- Modes renamed:
    - `safe` --> `normal`.
    - `unsafe` --> `full`.

### Removed
- Old control scripts `install.sh` and `uninstall.sh` cut from project.


## Release 0.1.1
### Tweaked
- Improve the structure of profile.d scripts, add comment blocks describing actions.


## Release 0.1.0
Initial release of this project.
