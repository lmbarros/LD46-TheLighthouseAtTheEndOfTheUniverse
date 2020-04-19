extends "res://misc/BaseCollider.gd"

# Time to live in seconds
var _ttl := 10.0

# In pixels per second
var _speed := 1000

# Velocity, in pixels per second.
var _velocity := Vector2(0, 0)

func fire(who) -> void:
	var isPlayer = who == G.gs.player
	self.position = who.global_position
	_velocity = polar2cartesian(_speed, who.rotation)
	set_collision_mask_bit(1, !isPlayer)
	set_collision_mask_bit(3, isPlayer)
	G.gs.playingField.add_child(self)


# Move!
func processAI(delta: float) -> void:
	moveAndCollide(_velocity * delta)

	_ttl -= delta
	if _ttl <= 0.0:
		onExpireTTL()


# What to do when the time-to-live reaches zero. By default, simply kills the
# node. Can be overriden.
func onExpireTTL() -> void:
	queue_free()


func die() -> void:
	G.addBulletHit(global_position)
	queue_free()


func sufferDamage(amount: float) -> void:
	die()
