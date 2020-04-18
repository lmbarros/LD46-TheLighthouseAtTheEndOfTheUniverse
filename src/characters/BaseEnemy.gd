extends KinematicBody2D

# Base enemy speed, in pixels per second. 
var speed = 300

# Remaining health
var health = 5.0

# If true, doesn't process stuff
var isDead = false


# Generic processing; do not process AI if dead.
func _process(delta: float) -> void:
	if isDead:
		return

	processAI(delta)


# Override in subclasses if desired.
func processAI(delta: float) -> void:
	pass


# Override in subclasses!
func die():
	assert(false)


# Common behavior: stop processing and calls custom behavior
func _die() -> void:
	isDead = true
	die()


# Suffers damage, maybe dies
func sufferDamage(damage: float) -> void:
	health -= damage
	if health <= 0:
		_die()


# How much damage this causes uppon colliding with something else.
func getCollisionDamage() -> float:
	return 0.0


# Move by a given amount. On collision, dies and causes damage to target
func moveBy(vel: Vector2) -> void:
	rotation = vel.angle()
	var col := move_and_collide(vel)
	
	if col != null:
		var target := col.collider

		if target.has_method("sufferDamage"):
			target.call_deferred("sufferDamage", getCollisionDamage())

		_die()
