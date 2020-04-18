extends KinematicBody2D

# Top speed in pixels/second.
const TOP_SPEED = 300

var maxHealth: float = 10.0

# Health. Player dies if <= 0.0.
var health: float = maxHealth

# Current velocity
var _velocity = Vector2(0, 0)

# Is the player dead?
var isDead = false

onready var _bulletClass = preload("res://bullets/WeakBullet.tscn")

func _process(_delta: float) -> void:
	if isDead:
		return

	_processMove()
	_processFire()


func _processMove() -> void:
	_velocity = Vector2(
		Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft"),
		Input.get_action_strength("moveDown") - Input.get_action_strength("moveUp"))

	# If using keys, diagonals will be [1, 1]. Clamp to unit vector.
	if _velocity.length_squared() > 1.0:
		_velocity = _velocity.normalized()

	# No need to multiply by delta (this is implied by move_and_slide)
	_velocity *= TOP_SPEED

	if _velocity.length_squared() > 0:
		rotation = _velocity.angle()

	move_and_slide(_velocity)


func _processFire() -> void:
	if Input.is_action_just_pressed("fire"):
		var bullet = _bulletClass.instance()
		bullet.fire(self)


func getSpeed() -> float:
	return _velocity.length()


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
	
	if !G.gs.isGamingOver:
		G.gs.isGamingOver = true
		yield(get_tree().create_timer(5.0), "timeout")
		queue_free()
		SS.pop()
