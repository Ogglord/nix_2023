{ pkgs ? import <nixpkgs> { }, ... }:
let
  inherit (pkgs) stdenv lib;
in
## deps nodePackages.pnpm
stdenv.mkDerivation rec {
  pname = "autobrr";
  version = "1.27.1";

  ## this will fail for unsupported platforms
  supported_arch = {
    "x86_64-linux" = "linux_x86_64";
    "x86_64-darwin" = "darwin_x86_64";
    # "arm64" = "arm64"; # not supported by nix?
    # "armhf" = "armv6"; # not supported by nix?
  }."${stdenv.system}";

  url = "https://github.com/autobrr/autobrr/releases/download/v${version}/autobrr_${version}_${supported_arch}.tar.gz";

  src = pkgs.fetchzip {
    url = url;
    sha256 = "sha256-Qh75rNXZNjNE1iYOEtvMiagQ1VT5PU9tlC/lsHm8OQg=";
    stripRoot = false;
  };


  phases = [ "installPhase" "patchPhase" ];
  installPhase = ''    
    mkdir -p $out/bin
    cp -r $src/. $out/bin    
    chmod +x $out/bin/autobrr
    chmod +x $out/bin/autobrrctl    
  '';

  meta = with lib; {
    description = "Dominate the seeding frenzy";
    longDescription = ''
      autobrr is the modern download automation tool for torrents and usenet.
      With inspiration and ideas from tools like trackarr, autodl-irssi and flexget we built one tool that can do it all, and then some.
    '';
    homepage = "https://github.com/autobrr/autobrr";
    changelog = "https://git.savannah.gnu.org/cgit/hello.git/plain/NEWS?h=v${version}";
    license = licenses.gpl2;
    maintainers = [ maintainers.eelco ];
    platforms = platforms.x86_64;
  };

}

