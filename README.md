## About
Carefully tuned adjustments for the font rendering software library **FreeType**, designed to improve visibility and refine appearance on the **Linux** platform.

You can find demo images to compare the changes [here](./assets/comparison).

## Usage

### Install
1. Download the latest release [here](https://github.com/maximilionus/freetype-envision/releases/latest) and unpack it to any user available location.
2. Open the terminal in the unpacked directory.
3. Run the command below, root required.
   ```sh
   $ sudo ./freetype-envision.sh install
   ```
4. Provide the user input.
5. Reboot.

### Revert
1. Run the command below, root required.
   ```sh
   $ sudo ./freetype-envision.sh remove
   ```
2. Provide the user input.
3. Reboot.

### Modes
Currently, there are several configuration presets with different levels of safety. **Normal** preset is considered least likely to cause visual errors in the user's environment, while **Full** one try to maximize the readability of the rendering for all the font drivers and options, while causing severe distortions in the rendering of some elements.

**Normal** mode is used by default, although it is recommended to try if the **Full** mode is suitable for you. Details are placed below.

#### Normal mode
List of features:
- Configurations for **profile.d**:
    - Stem darkening (embolden) for safe drivers, such as:
        - `autofitter`
        - `type1`
        - `t1cid`
- Configurations for **fontconfig**:
    - Enforce grayscale antialiasing (disable sub-pixel)

#### Full mode
List below only contains the new features, added by this mode:
- Configurations for **profile.d**:
    - Additional stem darkening (embolden) for unsafe drivers, such as:
        - `cff`
