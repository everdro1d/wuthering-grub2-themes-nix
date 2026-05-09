{ stdenvNoCC
, lib
, imagemagick
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
  nativeBuildInputs = [ imagemagick ];

  installPhase = ''
    runHook preInstall

    install -d -m0755 "$out/icons"

    install -m0644 common/*.pf2 "$out/"
    install -m0644 "config/theme-${screen}.txt" "$out/theme.txt"
    install -m0644 "backgrounds/background-${theme}.jpg" "$out/background.jpg"
    cp -r "assets/assets-icons/icons-${screen}/." "$out/icons/"
    chmod -R u=rwX,go=rX "$out/icons"
    install -m0644 "assets/assets-other/other-${screen}/"*.png "$out/"

    # Match script install behavior: normalize JPEG for GRUB compatibility.
    magick "$out/background.jpg" \
      -auto-orient \
      -colorspace sRGB \
      -interlace none \
      -strip \
      -sampling-factor 4:2:0 \
      -quality 100 \
      "$out/background.jpg"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/everdro1d/wuthering-grub2-themes-nix";
    description = "Wuthering Waves GRUB2 theme packages";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
  };
}
