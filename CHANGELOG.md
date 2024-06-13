## Release 0.4.0
- Enable `cff` driver in the **Normal** preset with new darkening values that
  reduce font distortion with this driver to a minimum. Major feature for
  vanilla **GNOME** users with **Cantarell** font.
- Stem-darkening values are now specified for all drivers (`cff`, `type1`, `t1cid`)
  in all presets for more predictive results.


## Release 0.3.0
- Project license changed to the BSD-3-Clause. I don't think it makes sense to
  use a license as restrictive as the GPL.
- Stem-darkening value increased for the min. sized fonts in "Full" preset.


## Release 0.2.3
- Stem-darkening values adjusted:
    - Improve the small-sized fonts visibility.
    - Reduced visual artifacts for medium-sized fonts.
    - Turned back on the darkening max. threshold for big-sized fonts.


## Release 0.2.2
- Minor enhancements to the installation script.


## Release 0.2.1
- Fixed problems with the lack of visual distinction between fonts of different
  weights on dark backgrounds.
- Visibility of small font sizes has been slightly improved.


## Release 0.2.0
> [!IMPORTANT]  
> When upgrading from versions `0.1.*`, be sure to uninstall the previous
> installation with its `uninstall.sh` script. Because of some incompatible
> enhancements made to the project it no longer can work with previous version
> tweaks.

- Revamped main script, everything in one place.
- Grayscale antialiasing enforcement is automated now, no manual actions
  required anymore.
- `cff` driver stem-darkening added to **full** preset.
- Enabled stem-darkening for `type1` and `t1cid` drivers.
- Stem darkening values tweaked to enhance visibility.
- Modes renamed:
    - `safe` --> `normal`.
    - `unsafe` --> `full`.
- Removed old control scripts `install.sh` and `uninstall.sh` cut from project.


## Release 0.1.1
- Improve the structure of profile.d scripts, add comment blocks describing
  actions.


## Release 0.1.0
Initial release of this project.
