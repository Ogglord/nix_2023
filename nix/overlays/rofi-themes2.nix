final: _:
let
  rofi-themes2 = { stdenv, fetchurl, perl }:



    stdenv.mkDerivation {
      name = "rofi-themes2";
      src =
        #builtins.filterSource
        #  (path: type: type != "directory" || baseNameOf path != ".rofi")
        final.fetchFromGitHub
          {
            owner = "newmanls";
            repo = "rofi-themes-collection";
            rev = "a1bfac5627cc01183fc5e0ff266f1528bd76a8d2";
            hash = "sha256-0/0jsoxEU93GdUPbvAbu2Alv47Uwom3zDzjHcm2aPxY=";
          } + "/themes";

      nativeBuildInputs = [ ];
      # pathExists path

      installPhase = ''
        runHook preInstall
        ls -al $src
        mkdir -p $out
        cp -r $src/. $out/
        runHook postInstall
      '';
    };
in
{
  rofi-themes2 = final.callPackage rofi-themes2 { };
}
