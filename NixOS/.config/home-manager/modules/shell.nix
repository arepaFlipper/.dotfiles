{ config, pkgs, ... }:
let
  unstable = import <nixos-unstable> { config = {allowUnfree = true;};};
  home.packages = with pkgs; [
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
  ];
  sessionVariables = {};
in 
{
  programs.zsh = {
		enable = true;
		sessionVariables = sessionVariables;
		# enableCompletion = true;
		#
		# autosuggestion.enable = true;
		# syntaxHighlighting = {
		# 		enable = true;
		# };
		#
		#   oh-my-zsh = {
		#    enable = true;
		#    theme = "agnoster";
		#    plugins = [ "git" "sudo" ];
		#   };
		#
			initExtra = ''
				[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
			'';
			zplug = {
				enable = true;
				plugins = [
					{
						name = "romkatv/powerlevel10k";
						tags = [ "as:theme" "depth:1" ];
					}
					{
						# will source zsh-autosuggestions.plugin.zsh
						name = "zsh-users/zsh-autosuggestions";
						# src = pkgs.fetchFromGitHub {
						# 	owner = "zsh-users";
						# 	repo = "zsh-autosuggestions";
						# 	rev = "v0.4.0";
						# 	sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
						# };
					}
					{
						name = "zsh-users/zsh-syntax-highlighting";
					}
				];
			};
  };

  programs.bash = {
    enable = true;
  };
}
