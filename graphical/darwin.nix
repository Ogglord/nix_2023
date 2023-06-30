{ ... }:
let
  error = throw "Darwin is not configured yet for graphical";
in
{
  imports = [ error ];
}
