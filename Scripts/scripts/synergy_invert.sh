#!/bin/bash

pkill picom kwin_x11 mutter 2>/dev/null
picom --backend xrender --invert-color-include "class_g = 'synergy'" &
flatpak run com.symless.synergy
pkill picom
