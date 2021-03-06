extends StaticBody2D

var maxHealth := 250.0
var health := maxHealth
var isDead := false

# Suffers damage, maybe dies.
func sufferDamage(damage: float) -> void:
	health -= damage
	health = max(health, 0.0)
	if health <= 0:
		die()


# Dies. Triggers game over.
func die() -> void:
	isDead = true
	visible = false
	collision_layer = 0
	collision_mask = 0
	G.addLargeExplosion(global_position)
	G.gameOver()


func getCollisionDamage() -> float:
	return 1000.0
