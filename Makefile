#
# StackedBoxes' Convenience Makefile for Godot Projects
#
# Copyright 2020 Leandro Motta Barros
#

# Expected export preset names: Linux, Windows, MacOSX, HTML5

# Fill-in the game name here
GAME_NAME=ld46-lighthouse


# Default target
all:
	@echo "Please run one of the specific targets"


# Clean everything made by make
clean:
	rm -rf export


# Export to all targets
export_all:
	rm -rf export

	# Linux
	mkdir -p export/linux/${GAME_NAME}
	cd src && godot --export Linux ../export/linux/${GAME_NAME}/${GAME_NAME}.x86_64
	cd export/linux && apack ${GAME_NAME}-linux.tar.gz ${GAME_NAME}
	mv export/linux/${GAME_NAME}-linux.tar.gz export/
	rm -rf export/linux

	# Windows (same steps as Linux)
	mkdir -p export/windows/${GAME_NAME}
	cd src && godot --export Windows ../export/windows/${GAME_NAME}/${GAME_NAME}.exe
	cd export/windows && apack ${GAME_NAME}-windows.zip ${GAME_NAME}
	mv export/windows/${GAME_NAME}-windows.zip export/
	rm -rf export/windows

	# MacOS X (easy, no need to create archive)
	cd src && godot --export MacOSX ../export/${GAME_NAME}-macosx.zip

	# HTML5 (all files myst be in the root of the zip)
	mkdir -p export/html5/
	cd src && godot --export HTML5 ../export/html5/index.html
	cd export/html5 && apack ${GAME_NAME}-html5.zip *
	mv export/html5/${GAME_NAME}-html5.zip export/
	rm -rf export/html5
