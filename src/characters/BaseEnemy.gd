extends "res://misc/BaseCollider.gd"

# Base enemy speed, in pixels per second. 
var speed = 300

# Remaining health
var health = 5.0


# Suffers damage, maybe dies
func sufferDamage(damage: float) -> void:
	health -= damage
	if health <= 0:
		commonDie()
