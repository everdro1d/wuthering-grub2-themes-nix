![banner](banner.png?raw=true)

## Nix (flake) usage

This repository now exposes GRUB theme packages through flake outputs.

### 1) Add flake input

```nix
inputs.wuthering-grub2-themes.url = "github:everdro1d/wuthering-grub2-themes-nix";
```

### 2) Select a packaged theme

Use either:

- `inputs.wuthering-grub2-themes.grubThemes.${pkgs.system}.<theme>.<screen>` (nested layout), or
- `inputs.wuthering-grub2-themes.packages.${pkgs.system}.<theme>-<screen>-grub-theme` (flat layout)

### 3) Set GRUB theme path

```nix
{ inputs, pkgs, ... }:
let
  themePkg = inputs.wuthering-grub2-themes.grubThemes.${pkgs.system}.changli."1920x1200";
in {
  boot.loader.grub = {
    enable = true;
    theme = "${themePkg}/theme.txt";
    splashImage = "${themePkg}/background.jpg";
  };
}
```

> No Home Manager integration and no NixOS module are provided.

## Available variants

### Themes

`changli`, `jinxi`, `jiyan`, `yinlin`, `anke`, `weilinai`, `kakaluo`, `jianxin`, `qianxiao`, `cartethyia`, `younuo`, `aemeath`, `lynae`, `mornye`

### Screen profiles

- `1080p` (1920x1080)
- `1920x1200`
- `2k` (2560x1440)
- `4k` (3840x2160)

## Script installation (non-Nix)

Usage: `sudo ./install.sh [OPTIONS...]`

```text
  -t, --theme     Background theme variant(s) [changli|jinxi|jiyan|yinlin|anke|weilinai|kakaluo|jianxin|qianxiao|cartethyia|younuo|aemeath|lynae|mornye] (default is changli)
  -s, --screen    Screen display variant(s)   [1080p|1920x1200|2k|4k|auto] (default is 1080p)
  -r, --remove    Remove/Uninstall theme      [changli|jinxi|jiyan|yinlin|anke|weilinai|kakaluo|jianxin|qianxiao|cartethyia|younuo|aemeath|lynae|mornye]
  -b, --boot      install theme into '/boot/grub' or '/boot/grub2'
  -h, --help      Show this help
```

If no options are used, the script opens a dialog UI.

### Example

```sh
sudo ./install.sh -t yinlin -s 1920x1200
```

## Contributing

- If you changed icons or other SVG-derived assets, regenerate with:
  - `cd assets && ./render-all.sh`
- Open a pull request with your changes.

## Documents

- [Grub2 theme reference](https://wiki.rosalab.ru/en/index.php/Grub2_theme_/_reference)
- [Grub2 theme tutorial](https://wiki.rosalab.ru/en/index.php/Grub2_theme_tutorial)
