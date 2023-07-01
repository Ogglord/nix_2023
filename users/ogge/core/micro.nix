{ ... }:
{

  programs.micro = {
    enable = true;
    settings = {
      autosu = true;
      clipboard = "external";
      colorscheme = "dracula-tc";
      diffgutter = true;
      keymenu = true;
      tabsize = 2;
    };
  };

  home.file.".config/micro/bindings.json".text = ''
    	{
    	    "Ctrl-y": "Undo",
    	    "Ctrl-z": "Redo",
    	    "Ctrl-u": "Paste",
    	    "Ctrl-w": "Save",
    	    "Ctrl-x": "Quit"
    	    
    	}
  '';

  home.shellAliases = {
    "nano" = "micro";
  };

}
