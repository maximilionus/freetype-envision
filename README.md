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
4. Reboot.

### Revert
1. Run the command below, root required.
   ```sh
   $ sudo ./freetype-envision.sh remove
   ```
2. Reboot.

### Modes
Currently, there are several configuration presets with different levels of safety. **Normal** preset is considered least likely to cause visual errors in the user's environment, while the **Full** one tries to maximize the readability of the rendering for all the font drivers and options, while causing severe distortions in the rendering of some elements.

**Normal** mode is used by default, although it is recommended to try if the **Full** mode is suitable for you. Details are placed below.


- Configurations in profile.d
   - Stem-darkening (embolden) for drivers
     |     | Normal | Full |
     | :-- | :----: | :--: |
     | `autofitter` | Yes | Yes |
     | `type1` | Yes | Yes |
     | `t1cid` | Yes | Yes |
     | `cff` | No | Yes |

   - Stem-darkening enabled for the small font sizes
     | Normal | Full |
     | :----: | :--: |
     | No | Yes |

- Configurations in fontconfig
   - Enforce grayscale antialiasing (disable sub-pixel)
     | Normal | Full |
     | :----: | :--: |
     | Yes | Yes |


#### Normal mode
Install and remove. Used by default if no second argument provided:
```sh
# Install
$ sudo ./freetype-envision.sh install normal

# Remove
$ sudo ./freetype-envision.sh remove normal
```

#### Full mode
Install and remove:
```sh
# Install
$ sudo ./freetype-envision.sh install full

# Remove
$ sudo ./freetype-envision.sh remove full
```
