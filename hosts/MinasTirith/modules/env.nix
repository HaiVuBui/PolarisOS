{ pkgs, lib ? pkgs.lib, username, ... }:

let
  cDevLibs = with pkgs; [
    zlib
    openssl
  ];

  cCudaLibs = with pkgs; [
    cudatoolkit
  ];

  cDevTools = with pkgs; [
    llvmPackages_latest.clang
    llvmPackages_latest.libcxx
    llvmPackages_latest.lld
    llvmPackages_latest.lldb
    gcc
    gdb
    mold
    cmake
    ninja
    meson
    pkg-config
    ccache
    bear
    clang-tools
    cppcheck
    valgrind
    gnumake
  ];

  cRuntimeLibs = cDevLibs ++ (with pkgs; [
    stdenv.cc.cc
    llvmPackages_latest.libcxx
  ]) ++ cCudaLibs;

  mkColonPath = paths: lib.concatStringsSep ":" (lib.filter (s: s != "") paths);

  includePath = lib.makeSearchPathOutput "dev" "include" cDevLibs;
  pkgConfigPath = lib.makeSearchPathOutput "dev" "lib/pkgconfig" cDevLibs;
  runtimeLibPath = lib.makeLibraryPath cRuntimeLibs;
in {
  environment.systemPackages =
    (with pkgs; [
      # nix lsp
      nixd
      nixfmt-classic

      #nvim
      tree-sitter

      # Java/JS
      nodejs
      yarn

      #Python
      basedpyright
      python310
      pixi
      black

      # Haskell
      cabal-install
      ormolu
      haskell-language-server
      ghc
      stack

      #Nvim
      rsync

      # latex
      texlab
      texliveFull
    ])
    ++ cDevTools
    ++ cDevLibs
    ++ cCudaLibs
    ;

  programs.ccache.enable = true;

  xdg.mime.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };

  environment.variables =
    let
      baseSessionVars = {
        # XDG_PICTURES_DIR = "/home/${username}/randomShits/Pictures";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        OZONE_PLATFORM = "wayland";
      };

      cSessionVars = {
        PKG_CONFIG_PATH = pkgConfigPath;
        CPATH = includePath;
        LIBRARY_PATH = runtimeLibPath;
        LD_LIBRARY_PATH = mkColonPath [
          runtimeLibPath
          "/run/opengl-driver/lib"
        ];
      };
    in
    baseSessionVars // cSessionVars;
}
