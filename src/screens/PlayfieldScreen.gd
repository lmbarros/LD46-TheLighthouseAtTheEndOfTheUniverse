extends Node2D

class_name PlayingField

func _ready():
	SS.setInitialScene(self)
	G.gs = GameState.new()
	G.gs.playingField = self
	G.gs.player = get_tree().get_nodes_in_group("player").front()
	G.gs.lighthouse = get_tree().get_nodes_in_group("lighthouse").front()

	var c := preload("res://characters/Kamikaze.tscn")
	var e := c.instance()
	e.initPosition()
	G.gs.playingField.add_child(e)
