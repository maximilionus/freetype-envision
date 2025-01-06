## About
Carefully tuned FreeType font rendering library adjustments, designed to
improve fonts visibility on Linux platform.

Visual demonstration can be found
[here](https://github.com/maximilionus/freetype-envision/wiki/Comparison).


### Overall
- Improve the visibility of medium and small-sized fonts.
- Prepare the font environment to work correctly with the new features.


## Usage
You can easily install and control the project with web wrapper script
```sh
curl -s -L https://maximilionus.github.io/freetype-envision/wrapper.sh \
    | sudo bash -s -- install
```

You can also specify the version of project you want to use by declaring the
`VERSION` environmental variable
```sh
curl -s -L https://maximilionus.github.io/freetype-envision/wrapper.sh \
    | sudo VERSION="0.2.0" bash -s -- [COMMAND]
```


### Install
1. Download the latest release
   [here](https://github.com/maximilionus/freetype-envision/releases/latest)
   *(download "Source code")* and unpack it to any user available location.
2. Open the terminal in the unpacked directory.
3. Run the command below, root required:
   ```sh
   sudo ./freetype-envision.sh install
   ```
4. Reboot to apply the changes.

### Remove
1. Run the command below, root required:
   ```sh
   sudo ./freetype-envision.sh remove
   ```
2. Reboot to apply the changes.

### Upgrade
**Versions above `0.7.0`:**  
Follow the same steps from "Install" section. If there's a supported version of
the project already installed, the "install" command will prompt the user to
allow the upgrade.

**Versions below `0.7.0`:**  
1. Follow the "Remove" section steps using the script exactly the version of
   the project that is currently installed on the system.
2. Now you can install the new version by simply following the "Install"
   section.


## Details
- Environmental configurations:
   - Stem-darkening *(fonts emboldening)* with custom values for `autofitter`,
   `type1`, `t1cid` and `cff` drivers.
   > This feature improves visibility of the medium and small sized-fonts.
   > Especially helpful for the LowPPI displays.

- Rules for fontconfig:
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
