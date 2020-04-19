extends CanvasLayer


func _process(delta):
	updateHealth()
	updateWaveInfo()
	updateScore()


func updateWaveInfo() -> void:
	var info := ""
	
	if G.gs.isGamingOver:
		info = "Succumbed to wave %s. " % (G.gs.waveNumber - 1)

	elif G.gs.waveMode == G.gs.waveModes.WAITING:
		if G.gs.waveNumber > 1:
			info = "Survived wave %s. " % (G.gs.waveNumber - 1)
		info += "Next wave starts in %s..." % int(G.gs.secsToNextWave)

	elif G.gs.waveMode == G.gs.waveModes.FIGHTING:
			info = "Defending against wave %s" % G.gs.waveNumber

	$WaveInfo.text = info


func updateHealth() -> void:
	var lh = G.gs.lighthouse
	var p = G.gs.player
	
	$Stats/Lighthouse/Label/Value.text = "%s / %s" % [ lh.health, lh.maxHealth ]
	$Stats/Lighthouse.max_value = lh.maxHealth
	$Stats/Lighthouse.value = lh.health
	
	$Stats/Ship/Label/Value.text = "%s / %s" % [ p.health, p.maxHealth ]
	$Stats/Ship.max_value = p.maxHealth
	$Stats/Ship.value = p.health


func updateScore() -> void:
	$Score/Value.text = str(G.gs.score)
