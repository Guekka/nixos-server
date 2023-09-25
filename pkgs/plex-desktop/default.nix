{
  fetchurl,
  lib,
  stdenv,
  squashfsTools,
  xorg,
  alsaLib,
  makeWrapper,
  openssl,
  freetype,
  glib,
  pango,
  cairo,
  atk,
  gdk-pixbuf,
  gtk2,
  cups,
  nspr,
  nss,
  libpng,
  libnotify,
  libgcrypt,
  systemd,
  fontconfig,
  dbus,
  expat,
  ffmpeg_3,
  curl,
  zlib,
  gnome3,
  at-spi2-atk,
  at-spi2-core,
  libpulseaudio,
  libdrm,
  mesa,
}: let
  # TO UPDATE: just execute the ./update.sh script (won't do anything if there is no update)
  # "rev" decides what is actually being downloaded
  # If an update breaks things, one of those might have valuable info:
  # https://aur.archlinux.org/packages/plex-desktop/
  version = "1.76.2";
  # To get the latest stable revision:
  # curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/plex-desktop?channel=stable' | jq '.download_url,.version,.last_updated'
  # To get general information:
  # curl -H 'Snap-Device-Series: 16' 'https://api.snapcraft.io/v2/snaps/info/plex-desktop' | jq '.'
  # More examples of api usage:
  # https://github.com/canonical-websites/snapcraft.io/blob/master/webapp/publisher/snaps/views.py
  rev = "44";

  deps = [
    alsaLib
    atk
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    curl
    dbus
    expat
    ffmpeg_3
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk2
    libdrm
    libgcrypt
    libnotify
    libpng
    libpulseaudio
    mesa
    nss
    pango
    stdenv.cc.cc
    systemd
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxcb
    xorg.libSM
    xorg.libICE
    zlib
  ];
in
  stdenv.mkDerivation {
    pname = "plex-desktop-unwrapped";
    inherit version;

    src = fetchurl {
      url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_${rev}.snap";
      sha512 = "";
    };

    buildInputs = [squashfsTools makeWrapper];

    dontStrip = true;
    dontPatchELF = true;

    unpackPhase = ''
      runHook preUnpack
      unsquashfs "$src" '/usr/share/plex-desktop' '/usr/bin/plex-desktop' '/meta/snap.yaml'
      cd squashfs-root
      if ! grep -q 'grade: stable' meta/snap.yaml; then
        # Unfortunately this check is not reliable: At the moment (2018-07-26) the
        # latest version in the "edge" channel is also marked as stable.
        echo "The snap package is marked as unstable:"
        grep 'grade: ' meta/snap.yaml
        echo "You probably chose the wrong revision."
        exit 1
      fi
      if ! grep -q '${version}' meta/snap.yaml; then
        echo "Package version differs from version found in snap metadata:"
        grep 'version: ' meta/snap.yaml
        echo "While the nix package specifies: ${version}."
        echo "You probably chose the wrong revision or forgot to update the nix version."
        exit 1
      fi
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall

      libdir=$out/lib/plex-desktop
      mkdir -p $libdir
      mv ./usr/* $out/

      cp meta/snap.yaml $out

      # Work around plex-desktop referring to a specific minor version of
      # OpenSSL.

      ln -s ${openssl.out}/lib/libssl.so $libdir/libssl.so.1.0.0
      ln -s ${openssl.out}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
      ln -s ${nspr.out}/lib/libnspr4.so $libdir/libnspr4.so
      ln -s ${nspr.out}/lib/libplc4.so $libdir/libplc4.so

      ln -s ${ffmpeg_3.out}/lib/libavcodec.so* $libdir
      ln -s ${ffmpeg_3.out}/lib/libavformat.so* $libdir

      rpath="$out/share/plex-desktop:$libdir"

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/share/plex-desktop/plex-desktop

      librarypath="${lib.makeLibraryPath deps}:$libdir"
      wrapProgram $out/share/plex-desktop/plex-desktop \
        --prefix LD_LIBRARY_PATH : "$librarypath" \
        --prefix PATH : "${gnome3.zenity}/bin"

      # fix Icon line in the desktop file (#48062)
      sed -i "s:^Icon=.*:Icon=plex-desktop-client:" "$out/share/plex-desktop/plex-desktop.desktop"

      # Desktop file
      mkdir -p "$out/share/applications/"
      cp "$out/share/plex-desktop/plex-desktop.desktop" "$out/share/applications/"

      # Icons
      for i in 16 22 24 32 48 64 128 256 512; do
        ixi="$i"x"$i"
        mkdir -p "$out/share/icons/hicolor/$ixi/apps"
        ln -s "$out/share/plex-desktop/icons/plex-desktop-linux-$i.png" \
          "$out/share/icons/hicolor/$ixi/apps/plex-desktop-client.png"
      done

      runHook postInstall
    '';

    meta = with lib; {
      homepage = "https://www.plex-desktop.com/";
      description = "Play music from the plex-desktop music service";
      license = licenses.unfree;
      maintainers = with maintainers; [eelco ftrvxmtrx sheenobu mudri timokau ma27];
      platforms = ["x86_64-linux"];
    };
  }
