{
  description = "Wuthering Waves GRUB2 themes with Nix flake packages";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      systems = [ "aarch64-linux" "i686-linux" "x86_64-linux" ];
    in
    flake-utils.lib.eachSystem systems (system:
      let
        pkgs = import nixpkgs { inherit system; };

        themeNames = builtins.sort builtins.lessThan (
          builtins.map
            (file: builtins.replaceStrings [ "background-" ".jpg" ] [ "" "" ] file)
            (builtins.filter
              (file: (builtins.match "^background-.*\\.jpg$" file) != null)
              (builtins.attrNames (builtins.readDir ./backgrounds)))
        );

        screenNames = [ "1080p" "1920x1200" "2k" "4k" ];

        mkThemePackage = theme: screen:
          pkgs.callPackage ./default.nix {
            inherit theme screen;
          };

        flatThemePackages = builtins.listToAttrs (
          pkgs.lib.concatMap
            (theme:
              builtins.map
                (screen: {
                  name = "${theme}-${screen}-grub-theme";
                  value = mkThemePackage theme screen;
                })
                screenNames)
            themeNames
        );

        nestedThemePackages = builtins.listToAttrs (
          builtins.map
            (theme: {
              name = theme;
              value = builtins.listToAttrs (
                builtins.map
                  (screen: {
                    name = screen;
                    value = mkThemePackage theme screen;
                  })
                  screenNames
              );
            })
            themeNames
        );
      in
      {
        packages = flatThemePackages // {
          default = mkThemePackage "changli" "1080p";
        };

        grubThemes = nestedThemePackages;
      });
}
