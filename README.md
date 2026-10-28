<h2 align="center">🗼 Tokyo Night SDDM 🗼</h2>

<p align="center">
A sleek, modern, and reactive SDDM theme tailored for the <a href="https://github.com/t4lentles5/minflair"><b>Minflair</b></a> desktop environment, featuring dynamic color scheme and wallpaper synchronization.
</p>

---

## ✨ Features

- 🕒 **Stylized Digital Clock**: 12h/24h format support with blinking colon and formatted date.
- 👤 **Modern Authentication Card**:
  - Circular avatar with automatic `~/.face` detection and user initial fallback.
  - Portable multi-user support with a dropdown selector.
  - Interactive login feedback and shake animation on failed authentication.
- 🎨 **Dynamic Theming**: Automatically synchronizes with <a href="https://github.com/t4lentles5/minflair">Minflair</a> (Quickshell) colors and wallpapers via `/var/tmp/sddm-theme/`, with static fallbacks in `theme.conf`.
- ⚙️ **Top Bar Controls**:
  - Time-adaptive greeting pill.
  - Desktop session selector (Hyprland, Wayland, X11, etc.).
  - Power action controls (Suspend, Reboot, Power Off).

---

## 📦 Dependencies

Ensure the following Qt 5 packages are installed on your system:

- `qt5-quickcontrols2`
- `qt5-graphicaleffects`
- `qt5-svg`

On Arch Linux:

```sh
sudo pacman -S qt5-quickcontrols2 qt5-graphicaleffects qt5-svg
```

---

## ⚙️ Configuration (`theme.conf`)

Main customization options available in `theme.conf`:

| Setting                  | Description                                             | Default                   |
| :----------------------- | :------------------------------------------------------ | :------------------------ |
| `Background`             | Fallback wallpaper path relative to theme root          | `"Backgrounds/win11.png"` |
| `Font`                   | UI font family (must be accessible to X11/root)         | `"Geist"`                 |
| `MainColor`              | Primary accent color fallback                           | `"#7aa2f7"`               |
| `BackgroundColor`        | Card background color fallback                          | `"#16161e"`               |
| `HourFormat`             | Hour format (`"hh:mm AP"` for 12h or `"HH:mm"` for 24h) | `"HH:mm"`                 |
| `DateFormat`             | Date format used by the clock (`Qt.formatDate` syntax)  | `"ddd · dd MMM · yyyy"`   |
| `HeaderText`             | Custom greeting text (leave empty for dynamic greeting) | `""`                      |
| `ForceHideSystemButtons` | Completely hide power actions pill                      | `"false"`                 |

---

## 📜 License

[GNU Lesser General Public License v3.0](LICENSE)
