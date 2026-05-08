self: super: {
  i3 = super.i3.overrideAttrs (oldAttrs: {
    postInstall = oldAttrs.postInstall or "" + ''
      wrapProgram $out/bin/i3-nagbar 
        --set COLOR_BACKGROUND "#333333" 
        --set COLOR_TEXT "#ffffff" 
        --set COLOR_BORDER "#888888"
    '';
  });
}
