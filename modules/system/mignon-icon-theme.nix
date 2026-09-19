{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
}:

stdenvNoCC.mkDerivation {
  pname = "mignon-icon-theme";
  version = "0-unstable-2026-08-22";

  src = fetchFromGitHub {
    owner = "IgorFerreiraMoraes";
    repo = "Mignon-icon-theme";
    rev = "7a7ea5768f2826ca7e54eedf2aefa72092ab6fba";
    hash = "sha256-AKFRZngtjZ23/75j9TMIdPerp5J8JL7NQyDE/DwBMLM=";
  };

  nativeBuildInputs = [ gtk3 ];

  dontBuild = true;

  # install.sh hardcodes $HOME/.local/share/icons as the destination
  installPhase = ''
    runHook preInstall

    export HOME="$NIX_BUILD_TOP/home"
    patchShebangs install.sh
    ./install.sh --all

    install -d "$out/share/icons"
    cp -r "$HOME/.local/share/icons/." "$out/share/icons/"

    # upstream ships symlinks inherited from Tela whose targets this theme
    # does not draw; leaving them dangling blocks icon fallback
    find "$out/share/icons" -xtype l -delete

    # brave-origin ships no Mignon icon of its own
    for apps in "$out"/share/icons/Mignon-pastel*/scalable/apps; do
      ln -s brave.svg "$apps/brave-origin.svg"
    done

    runHook postInstall
  '';

  meta = {
    description = "Flat, pastel, cute icon theme for Linux";
    homepage = "https://github.com/IgorFerreiraMoraes/Mignon-icon-theme";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
  };
}
