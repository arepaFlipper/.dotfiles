{ config, pkgs, inputs, lib, ... }:

{
  # Programs

  home.sessionVariables = {
    NODE_ENV = "development";
  };

  # Add packages you want in your shell
  home.packages = with pkgs; [
    # example
    nodePackages_latest.nodejs
    yarn
    typescript
    eslint
  ];
}

