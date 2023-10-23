#!/bin/bash

task add "Cardio 20 Min" priority:M project:routine tags:workout,care
task add "Listen Alux" priority:M project:routine tags:mindset
task add "Cold shower" priority:M project:routine tags:care
task add "Listen German" priority:M project:routine tags:education

if [[ "$1" == "--ABS" ]]; then
	task add "ABS 5 minutes" priority:M project:routine tags:workout,care
fi
