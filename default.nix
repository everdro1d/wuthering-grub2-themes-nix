{ stdenvNoCC
, lib
, theme
, screen
}:

let
  themes = builtins.sort builtins.lessThan (
    builtins.map
      (file: builtins.replaceStrings [ "background-" ".jpg" ] [ "" "" ] file)
      (builtins.filter
        (file: (builtins.match "^background-.*\\.jpg$" file) != null)
        (builtins.attrNames (builtins.readDir ./backgrounds)))
  );

  screens = [ "1080p" "1920x1200" "2k" "4k" ];
in
assert lib.elem theme themes;
assert lib.elem screen screens;

stdenvNoCC.mkDerivation {
  pname = "wuthering-grub2-theme-${theme}-${screen}";
  version = "unstable-2026-05-09";

  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/icons"

    cp common/*.pf2 "$out/"
    cp "config/theme-${screen}.txt" "$out/theme.txt"
    cp "backgrounds/background-${theme}.jpg" "$out/background.jpg"
    cp -r "assets/assets-icons/icons-${screen}/." "$out/icons/"
    cp "assets/assets-other/other-${screen}/"*.png "$out/"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/everdro1d/wuthering-grub2-themes-nix";
    description = "Wuthering Waves GRUB2 theme packages";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
