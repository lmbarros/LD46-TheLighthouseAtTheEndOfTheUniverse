# Scene Stack

*Part of [StackedBoxes' GDScript Hodgepodge](https://gitlab.com/stackedboxes/gdscript/)*

An implementation of the good and old "stack of states" pattern for Godot. Here the "state" is a "game screen", implemented as a Godot Scene.

For example, start with a single scene representing your Title Screen. The player selects "Options" from the initial menu, which makes the Options Screen scene to be pushed into the stack and thus becoming the current scene. After doing all options selections, the player clicks on "Back", which pops the current scene from the stack, bringing the Title Screen back to the top. And so on, and so on.
