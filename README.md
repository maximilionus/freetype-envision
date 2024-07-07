## About
Carefully tuned adjustments for the font rendering software library
**FreeType**, designed to improve visibility and refine appearance on the
**Linux** platform.

You can find demo images to compare the changes
[here](https://drive.google.com/drive/folders/1gPoAsNOPaaACBdEX2YEvlK0cw5miBfOd?usp=sharing).

### Overall
- Improve the visibility of medium and small-sized fonts by utilizing the
  disabled by default FreeType 'stem-darkening' feature.
- Use additional fontconfig rules to prepare the environment for all the new
  FreeType features.


## Install

### Fedora, RHEL
1. Enable the **copr** repository:
```sh
$ sudo dnf copr enable maximilionus/freetype-envision
```
2. Install with:
```sh
# Normal mode
$ sudo dnf install freetype-envision

# Full mode
$ sudo dnf install freetype-envision-full
```
3. Reboot to apply the changes.

### Manual
#### Install
1. Download the latest release
   [here](https://github.com/maximilionus/freetype-envision/releases/latest)
   *(download "Source code")* and unpack it to any user available location.
2. Open the terminal in the unpacked directory.
3. Run the command below, root required:
```sh
# Normal mode:
$ sudo ./freetype-envision.sh install
# or
$ sudo ./freetype-envision.sh install normal

# Full mode:
$ sudo ./freetype-envision.sh install full
```
4. Reboot to apply the changes.

#### Uninstall
1. Run the command below, root required:
```sh
$ sudo ./freetype-envision.sh remove
```
2. Reboot to apply the changes.

#### Upgrade
1. Follow the **uninstall procedure** using the script exactly the version of
   the project that is installed in the system.
2. Download the new version and proceed with **install procedure**.


## Details
Currently, there are several configuration presets with different levels of
safety. **Normal** preset is considered least likely to cause visual errors in
the user's environment and is therefore used by default, while the **Full** one
tries to maximize the readability of the rendering for all the font drivers and
options, at the cost of severe distortions in the rendering of some elements.


- Configurations in profile.d:
   - Stem-darkening (embolden) for drivers:
   > This feature improves visibility of the medium and small sized-fonts.
   > Especially helpful for the LowPPI displays.

     | Driver       | Normal | Full |
     | :----------- | :----: | :--: |
     | `autofitter` | Yes    | Yes  |
     | `type1`      | Yes    | Yes  |
     | `t1cid`      | Yes    | Yes  |
     | `cff`        | Yes    | Yes  |

   - Stem-darkening enabled for the small font sizes in `autofitter` driver:
   > Darkening for small sized fonts with `autofitter` driver in **Normal**
   > mode is disabled to avoid various rare distortions in the font rendering

     | Normal | Full |
     | :----: | :--: |
     | No     | Yes  |

- Configurations in fontconfig:
   - Enforce grayscale antialiasing (disable sub-pixel).
   > Grayscale antialiasing should be enforced in the system to make the
   > stem-darkening work properly.

   - Reject usage of *Droid Sans* family for Japanese and Chinese, force the
     environment to use other fonts.
   > Stem-darkening does not work well with these typefaces, causing characters
   > over-emboldening.


## Notes
### GNOME DE
GNOME users should consider changing the default system-ui font *Cantarell* to
any other similar font that doesn't render with the `cff` engine. `cff` engine
hinting is broken, making the fonts look very distorted after stem-darkening.

Changing the fonts is possible through the `gnome-tweaks` utility.

Fonts to consider:
- Noto Sans
- Inter


## Build
The repository also contains a GNU Make - Makefile for building the project
archive for further distribution via package managers. Note that this archive
does not contain the main script, as all file handling is expected to be done
by the package manager! The final build made by this method is distributed with
each release.

To create the release archive:
1. Execute:
    ```sh
    $ make
    ```
2. Final archive will be placed in `dist/` directory with name `freetype-envision-X.Y.Z.tar.gz`, where:
    - `X.Y.Z` stands for current version
