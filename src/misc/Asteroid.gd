extends BaseCollider

const CURE_PLAYER_AMOUNT := 5
const CURE_LIGHTHOUSE_AMOUNT := 15


# Remaining health
var health = 15.0

# Either cures player or lighthouse.
var curesLighthouse := true


func _ready() -> void:
	curesLighthouse = RNG.flipCoin()
	var oreColor := "#d12e33" if curesLighthouse else "#4087bf"
	$RotatingStuff/Ore.self_modulate = oreColor


# Suffers damage, maybe dies.
func sufferDamage(damage: float) -> void:
	health -= damage
	if health <= 0:
		commonDie()


func die() -> void:
	G.addLargeExplosion(global_position)
	queue_free()
	var cureTarget = G.gs.lighthouse if curesLighthouse else G.gs.player
	var cureAmount = CURE_LIGHTHOUSE_AMOUNT if curesLighthouse else CURE_PLAYER_AMOUNT

	cureTarget.health += cureAmount
	if cureTarget.health > cureTarget.maxHealth:
		cureTarget.maxHealth += int((cureTarget.health - cureTarget.maxHealth) / 2)
		cureTarget.health = cureTarget.maxHealth


func _process(delta: float) -> void:
	$RotatingStuff.rotation += delta * PI
	while rotation >= 2*PI:
		rotation -= 2*PI


func getCollisionDamage() -> float:
	return 20.0
