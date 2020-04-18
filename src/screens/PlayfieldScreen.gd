extends Node2D

class_name PlayingField

func _ready():
	SS.setInitialScene(self)
	G.gs = GameState.new()
	G.gs.playingField = self
	G.gs.player = get_tree().get_nodes_in_group("player").front()
