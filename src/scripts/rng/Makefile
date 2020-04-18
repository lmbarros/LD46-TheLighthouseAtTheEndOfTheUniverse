#
# StackedBoxes' GDScript Hodgepodge
#
# Copyright (c) 2019-2020 Leandro Motta Barros
#

.SILENT: help test

help:
	echo "Run 'make test' to run the unit tests."
	echo
	echo "If you don't see any assertion errors, it means all tests passed."
	echo
	echo "A few things are needed to make this work:"
	echo
	echo "1. The "assert" library is available at ../assert"
	echo "2. The "stats" library is available at ../stats"
	echo "3. There is a Godot binary available in your PATH as"
	echo "   'headless-godot'. It doesn't have to be a headless build of Godot,"
	echo "    but that's what I recommend."

test:
	ln -sf ../assert/Assert.gd
	ln -sf ../stats/Stats.gd
	headless-godot --debug --script Test.gd
	rm Assert.gd
	rm Stats.gd
