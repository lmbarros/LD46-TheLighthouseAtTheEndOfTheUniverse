extends Node2D

class_name PlayingField

func _ready():
	SS.setInitialScene(self)
	SM.playInGameMusic()
	G.gs = GameState.new()
	G.gs.playingField = self
	G.gs.player = get_tree().get_nodes_in_group("player").front()
	G.gs.lighthouse = get_tree().get_nodes_in_group("lighthouse").front()
	G.createAsteroidMaybe()


func _process(delta: float) -> void:
	match G.gs.waveMode:
		G.gs.waveModes.WAITING:
			G.gs.secsToNextWave -= delta
			if G.gs.secsToNextWave <= 0.0:
				G.startNextWave()
				G.gs.waveMode = G.gs.waveModes.FIGHTING

		G.gs.waveModes.FIGHTING:
			if G.isWaveDefeated():
				G.gs.score += int(pow(G.gs.waveNumber, 1.5) * 8)
				
				G.gs.secsToNextWave = G.gs.WAVE_INTERVAL
				G.gs.waveMode = G.gs.waveModes.WAITING
				G.gs.waveNumber += 1
				G.createAsteroidMaybe()

				SM.playConfirm()
				yield(get_tree().create_timer(0.3), "timeout")
				SM.playConfirm()
				yield(get_tree().create_timer(0.3), "timeout")
				SM.playConfirm()
