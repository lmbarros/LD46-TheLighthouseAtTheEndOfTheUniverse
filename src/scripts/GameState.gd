extends Object

class_name GameState

# The game score.
var score: int = 0

# The player.
var player = null

# The playing field.
var playingField = null

# The lighthouse.
var lighthouse = null

# Did we trigger a hame over yet?
var isGamingOver := false

# Time between waves, in seconds.
const WAVE_INTERVAL := 5.0

# The current (or next) wave
var waveNumber: int = 1

# We are either waiting the next wave or fighting a wave.
enum waveModes { WAITING, FIGHTING }
var waveMode = waveModes.WAITING

# Seconds until the next wave start.
var secsToNextWave := WAVE_INTERVAL

# Message to display on the Game Over screen.
var gameOverMessage := ""
