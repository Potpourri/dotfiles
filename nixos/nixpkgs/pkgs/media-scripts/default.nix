{
  stdenv,
  fetchFromGitHub,
  ffmpeg_4,
  imagemagick7
}:

stdenv.mkDerivation rec {
  name = "media-scripts-${version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "Potpourri";
    repo = "media-scripts";
    rev = "ae16fdbbe42fc2f4b0f8cc34ccc91e6ad0093189";
    sha256 = "195lj4m102fy5ys3n58a8ixp4rk16ad3y0qlrgbdv6fd277kjnp0";
  };

  patchPhase = ''
    substituteInPlace pic-is-portrait-fullhd --replace 'identify' '${imagemagick7}/bin/identify'
    substituteInPlace pic-to-portrait-fullhd --replace 'convert' '${imagemagick7}/bin/convert'
    substituteInPlace merge-video-and-audio --replace 'ffmpeg' '${ffmpeg_4}/bin/ffmpeg'
    substituteInPlace m4a-to-mp3 --replace 'ffmpeg' '${ffmpeg_4}/bin/ffmpeg'
  '';

  installPhase = ''
    install -Dm755 pic-is-portrait-fullhd $out/bin/pic-is-portrait-fullhd
    install -Dm755 pic-to-portrait-fullhd $out/bin/pic-to-portrait-fullhd
    install -Dm755 merge-video-and-audio $out/bin/merge-video-and-audio
    install -Dm755 m4a-to-mp3 $out/bin/m4a-to-mp3
  '';
}
