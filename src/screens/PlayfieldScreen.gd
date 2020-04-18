extends Node2D

func _ready():
	SS.setInitialScene(self)
	G.gs = GameState.new()
