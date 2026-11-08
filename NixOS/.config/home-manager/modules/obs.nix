{ config, pkgs, lib, ... }:
{
  home.activation.setupOBS = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/OBS"
    _ini="$HOME/.config/obs-studio/basic/profiles/Untitled/basic.ini"
    mkdir -p "$(dirname "$_ini")"
    if ! grep -q "^\[Video\]" "$_ini" 2>/dev/null; then
      cat > "$_ini" <<'OBSEOF'
[General]
Name=Untitled

[Video]
BaseCX=1702
BaseCY=1400
OutputCX=1702
OutputCY=1400
FPSType=0
FPSCommon=60
ColorFormat=NV12
ColorSpace=709
ColorRange=Partial
ScaleType=bicubic

[Audio]
SampleRate=48000
ChannelSetup=Stereo

[Output]
Mode=Simple

[SimpleOutput]
FilePath=/home/cris/OBS
RecFormat2=mkv
VBitrate=2500
ABitrate=160
FileNameWithoutSpace=true
RecQuality=HQ
RecEncoder=x264
UseAdvanced=false
OBSEOF
    fi
  '';

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
    ];
  };
}
