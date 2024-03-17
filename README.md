## About
Carefully tuned adjustments for the font rendering software library **FreeType**, designed to improve visibility and refine appearance on the **Linux** platform.

## Usage
### Install
1. Download the latest release [here](https://github.com/maximilionus/freetype-envision/releases/latest) and unpack it to any user available location.
2. Open the terminal in the unpacked directory.
3. Run the command below, root required.
```sh
$ sudo ./install.sh
```
4. Reboot.

### Revert
1. Run the command below, root required.
```sh
$ sudo ./uninstall.sh
```
2. Reboot.

### Safety
Currently, there are several configuration presets with different levels of safety. **Safe** configurations are considered least likely to cause visual errors in the user's environment, while **unsafe** ones try to maximize the readability of the rendering while causing severe distortions in the rendering of some elements.

**Safe** mode is used by default, although it is recommended to try if the unsafe mode is suitable for you. To do so, you must overwrite the `$PRESET` variable on script execution:
```sh
sudo PRESET=unsafe ./install.sh

# and

sudo PRESET=unsafe ./uninstall.sh
```
