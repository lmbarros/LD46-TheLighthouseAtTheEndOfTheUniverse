extends StaticBody2D

var maxHealth := 100.0
var health := maxHealth


# Suffers damage, maybe dies.
func sufferDamage(damage: float) -> void:
	health -= damage
	health = max(health, 0.0)
	if health <= 0:
		die()


# Dies. Triggers game over.
func die() -> void:
	visible = false
	collision_layer = 0
	collision_mask = 0

	if !G.gs.isGamingOver:
		G.gs.isGamingOver = true
		yield(get_tree().create_timer(5.0), "timeout")
		queue_free()
		SS.pop()
