## About
Carefully tuned **FreeType** font rendering library adjustments, designed to
improve fonts visibility on **Linux** platform.

Compare the changes
[here](https://github.com/maximilionus/freetype-envision/wiki/Comparison).

### Overall
- Improve the visibility of medium and small-sized fonts.
- Prepare the font environment for the new features.

## Install

### Fedora, RHEL
1. Enable the **copr** repository:
   ```sh
   sudo dnf copr enable maximilionus/freetype-envision
   ```
2. Install with:
   ```sh
   sudo dnf install freetype-envision
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
   sudo ./freetype-envision.sh install
   ```
4. Reboot to apply the changes.

#### Uninstall
1. Run the command below, root required:
   ```sh
   sudo ./freetype-envision.sh remove
   ```
2. Reboot to apply the changes.

#### Upgrade
1. Follow the **uninstall procedure** using the script exactly the version of
   the project that is installed in the system.
2. Download the new version and proceed with **install procedure**.


## Details
- Configurations in profile.d:
   - Stem-darkening *(universal fonts emboldening)* with custom values for
     `autofitter`, `type1`, `t1cid` and `cff` drivers.
   > This feature improves visibility of the medium and small sized-fonts.
   > Especially helpful for the LowPPI displays.

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
#### Antialiasing
While GNOME does use the grayscale antialiasing method by default, there are a
few Linux distributions that change this setting to the subpixel method, making
the font rendering appear incorrect after the tweaks from this project.

This issue is
[already tracked](https://github.com/maximilionus/freetype-envision/issues/7),
but manual user intervention is still required for now. You can enable the
grayscale antialiasing method by executing the command below:

```sh
gsettings set org.gnome.desktop.interface font-antialiasing grayscale
```

To reset the changes:

```sh
gsettings reset org.gnome.desktop.interface font-antialiasing
```

#### Fonts
GNOME users should consider changing the default interface font *Cantarell* to
any other similar font that doesn't render with the `cff` engine. Hinting in
`cff` engine is broken, making the fonts look very distorted after emboldening.

Changing the fonts is possible through the `gnome-tweaks` utility.

Fonts to consider:
- Inter *(size: `10.5pt`)*
- Noto Sans *(size: `10.5pt`)*


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
2. Final archive will be placed in `dist/` directory with name
   `freetype-envision-X.Y.Z.tar.gz`, where:
    - `X.Y.Z` stands for current version
