#
# Scene Stack
# StackedBoxes' GDScript Hodgepodge
#
# Copyright (c) 2019 Leandro Motta Barros
#

extends Node


# The stack of states.
onready var _stack: Array = [ ]


# Sets the initial game scene.
#
# One way to do this is using this in your initial scene:
#
#    func _ready():
#        SceneStack.setInitialScene(self)
#
# It is fine to call this method multiple times -- only the first call will have
# effect. This might come handy. For example, maybe your initial scene is a
# splash screen, that then proceeds to a game title scene, which moves on to a
# scene telling the game's background story and just then, finally, reaches the
# gameplay scene itself. Fine, that's how many games are. But during development
# you'll often want to start right from the gameplay to check if everything is
# working as expected. You don't want to go through all those screens. No
# problem! Simply call setInitialScene() in the _ready() method of both your
# splash screen and your gameplay scene. Then you can use either of them as the
# initial screen during development and testing.
func setInitialScene(scene: Node) -> void:
	if _stack.size() == 0:
		_stack.push_back(scene)


# Pushes a new scene into the scene stack. The scene parameter can be any of
# these types:
#
#    - String: The scene parameter is assumed to be the path to a scene, like
#      "res://screens/ShopScreen.tscn". A new instance of this scene will be
#      created and pushed into the stack. This is the most straightforward way
#      to use push().
#
#    - PackedScene: This is for the cases in which you already preloaded the
#      desired scene using load() or preload(). This can be handy if you are
#      going to push new instances of the same large scene over and over again.
#      A large scene can take some time to load and this allows you to do the
#      time-consuming step only once.
#
# Pushing a scene can trigger the execution of some other methods:
#
#    - onBury(): If the scene previously on the top of the stack has a method
#      named onBury(), it is called receiving buryArg as argument.
#    - onPush(): If the scene being pushed has a method named onPush(), it is
#      called, receiving pushArg as argument.
func push(scene, pushArg = null, buryArg = null) -> void:
	call_deferred("_deferredPush", scene, pushArg, buryArg)


# The real implementation of push(), actually called during idle processing
# time.
func _deferredPush(scene, pushArg, buryArg) -> void:
	if _stack.size() > 0:
		var oldTop := _stack.back() as Node
		if oldTop.has_method("onBury"):
			oldTop.onBury(buryArg)
		oldTop.get_parent().remove_child(oldTop)

	var newTop := _sceneNodeFromParam(scene)
	_stack.push_back(newTop)

	if newTop.has_method("onPush"):
		newTop.onPush(pushArg)

	get_tree().get_root().add_child(newTop)


# Pops the current scene from the stack, freeing its resources.
#
# The new scene on top of the stacks becomes the current scene. If after popping
# the stack becomes empty, the game exits.
#
# Calling pop() may trigger the execution of the following methods:
#
#     - onDigOut: If the new node on top of the stack has a metod named
#       onDigOut() it is called receiving digOutArg as argument.
#     - onPop: If the scene previously on top of the stack has a method named
#       onPop() it is called receiving popArg as argument.
func pop(digOutArg = null, popArg = null) -> void:
	call_deferred("_deferredPop", digOutArg, popArg)


# The real implementation of pop(), guaranteed to be called during idle
# processing time.
func _deferredPop(digOutArg, popArg) -> void:
	assert(_stack.size() > 0)

	var oldTop := _stack.back() as Node
	if oldTop.has_method("onPop"):
		oldTop.onPop(popArg)

	oldTop.free()
	_stack.pop_back()

	if _stack.size() > 0:
		var newTop := _stack.back() as Node
		get_tree().get_root().add_child(newTop)
		if newTop.has_method("onDigOut"):
			newTop.onDigOut(digOutArg)
	else:
		get_tree().quit()


# Replaces the top of the stack with a new scene. The scene parameter can be of
# different types, just as explained in push().
#
# This almost the same as calling pop() followed by push(). Almost:
#
#     - If you have one single state on the stack, that initial call to pop()
#       would cause the game to exit before your push().
#     - No calls to onDigOut() or onBury() are made (any state that was buried
#       is still buried). But onPop() and onPush() are called normally for the
#       old top and the new top scene, respectively.
func replaceTop(scene, pushArg = null, popArg = null) -> void:
	call_deferred("_deferredReplaceTop", scene, pushArg, popArg)


# The real implementation of replaceTop(), guaranteed to be called during idle
# processing time.
func _deferredReplaceTop(scene, pushArg, popArg) -> void:
	# Pop old top scene
	assert(_stack.size() > 0)

	var oldTop := _stack.back() as Node
	if oldTop.has_method("onPop"):
		oldTop.onPop(popArg)

	oldTop.free()
	_stack.pop_back()

	# Push new top scene
	var newTop := _sceneNodeFromParam(scene)
	_stack.push_back(newTop)

	if newTop.has_method("onPush"):
		newTop.onPush(pushArg)

	get_tree().get_root().add_child(newTop)


# Returns a scene node, being a little bit smart in the handling of the scene
# parameter. It implements the type-dependent behavior described in the push()
# docs.
func _sceneNodeFromParam(scene) -> Node:
	if scene is String:
		var packedScene := load(scene)
		return packedScene.instance()
	elif scene is PackedScene:
		return scene.instance()
	else:
		assert(false)
		return null
