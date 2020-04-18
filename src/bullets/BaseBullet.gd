extends KinematicBody2D

# Time to live in seconds
var _ttl := 15.0

# In pixels per second
var _speed := 1000

# Velocity, in pixels per second.
var _velocity := Vector2(0, 0)

func fire(who) -> void:
	var isPlayer = who == G.gs.player
	self.position = who.position
	_velocity = polar2cartesian(_speed, who.rotation)
	set_collision_mask_bit(1, !isPlayer)
	set_collision_mask_bit(3, isPlayer)

	G.gs.playingField.add_child(self)

	if has_method("onFire"):
		call_deferred("onFire", _velocity)


# Move!
func _process(delta: float) -> void:
	move_and_slide(_velocity)
	rotation = _velocity.angle()

	_ttl -= delta
	if _ttl <= 0.0:
		if has_method("onExpireTTL"):
			call_deferred("onExpireTTL")


func onExpireTTL() -> void:
	queue_free()
