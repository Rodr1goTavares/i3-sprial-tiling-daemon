# i3 Spiral Tiling Daemon

## How it works

This application manages your i3 windows by organizing them in a **binary tree tiling layout**, creating a clean and efficient spiral pattern.

The window arrangement follows a **binary tree**, where each container splits into two children, alternating between horizontal and vertical splits with each new window. This pattern maximizes screen space while maintaining an intuitive window hierarchy for productivity.

A conceptual example of the spiral binary tree layout:

```
              [root container]
                  /         \
         [split horizontal]  [split vertical]
             /        \          /        \
     [win1]         [win2]  [split h]   [win4]
                            /       \
                       [win3]    [win5]
```

Each new window is inserted following the alternating split direction, expanding the spiral structure while keeping windows easily accessible.

---

## Learn more

* [Tiling Window Manager Concepts](https://en.wikipedia.org/wiki/Tiling_window_manager)
* [Binary Tree Layout in dwm](https://dwm.suckless.org/customisation/layouts/#spiral)
* [i3 Window Manager Documentation](https://i3wm.org/docs/)

---

## Installation (Unix-like systems)

```bash
wget -qO- https://raw.githubusercontent.com/Rodr1goTavares/i3-sprial-tiling-daemon/refs/heads/main/scripts/install.sh | bash
```

---

## Usage

Add this to your i3 config to start automatically:

```bash
exec_always --no-startup-id i3std &
```

Or run manually:

```bash
i3std
```

---

## Uninstall

```bash
wget -qO- https://raw.githubusercontent.com/Rodr1goTavares/i3-sprial-tiling-daemon/refs/heads/main/scripts/uninstall.sh | bash
```

---
