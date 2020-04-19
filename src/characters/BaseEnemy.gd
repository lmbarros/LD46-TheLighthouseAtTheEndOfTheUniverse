extends "res://misc/BaseCollider.gd"

# Base enemy speed, in pixels per second. 
var speed = 300

# Remaining health
var health = 5.0

const INITIAL_POSITION_RADIUS := 1000.0

# Suffers damage, maybe dies.
func sufferDamage(damage: float) -> void:
	health -= damage
	if health <= 0:
		commonDie()


# Initializes the position of a newly created enemy. By default, uses a random
# point on a large circumference centered at the origin (where the lighthouse
# is).
func initPosition() -> void:
	position = RNG.pointOnCircumference(INITIAL_POSITION_RADIUS)


func die() -> void:
	G.addSmallExplosion(global_position)
	queue_free()
