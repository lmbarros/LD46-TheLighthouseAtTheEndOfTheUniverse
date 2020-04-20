extends "res://bullets/BaseBullet.gd"


func _ready() -> void:
	_speed = 2000


func getCollisionDamage() -> float:
	return 10.0
