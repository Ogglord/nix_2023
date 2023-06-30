(final: prev: {
  rofi-wayland-unwrapped = prev.rofi-wayland-unwrapped.overrideAttrs
    (old: {
      src = prev.fetchFromGitHub {
        owner = "lbonn";
        repo = "rofi";
        rev = "d06095b5ed40e5d28236b7b7b575ca867696d847";
        fetchSubmodules = true;
        sha256 = "0qdp46d8wn3jp57hwj710709drl3dlrjxb8grfmfa6a5lnjwg1zh";
      };
      version = "1.7.6+wayland1-git";
    });
})
