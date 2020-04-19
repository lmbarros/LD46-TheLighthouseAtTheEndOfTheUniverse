# LD 46: The Lighthouse at the End of the Universe

My entry for Ludum Dare 46; theme is "Keep it Alive".

License is GPL3.

Game title is based on two books. Fining out which ones is left as an exercise
to the player. 🙂

## Credits

* Engine: [Godot](http://godotengine.org) 3.2.1.
* Graphics: [Inkscape](https://inkscape.org) 0.92.4.
  Used [GIMP](https://www.gimp.org) 2.10.18 for the icon.
* Sound: [SFXR](http://www.drpetter.se/project_sfxr.html).
* Music created with [Otomata](http://earslap.com/page/otomata.html) and edited
  with [Audacity](https://www.audacityteam.org).
* Font: [Orbitron](https://www.theleagueofmoveabletype.com/orbitron), by [Matt
  McInerney](http://pixelspread.com), [SIL Open Font License
  1.1](orbitron-font-license.md).

## Notes to self

### TODO

* Main menu: start, quit
* Main menu: help
* Double check volume (isn't it too loud?)
* Custom game over messages ("you survived to tell the story and feel the shame")
* Asteroids
* Killing asteroids give health to the lighthouse
* Excess health to the lighthouse increases its max health
* Killing other type of asteroids give health to the player
* Excess health to the player increases its max health
* Sniper (enemy that targets the lighthouse(and maybe the player?) from distance)
* Balancing!

### Damage

* Weak bullet: 1
* Sniper bullet: 25
* Kamikaze: 100

### Layers

* Layer 0: Lighthouse
* Layer 1: Player
* Layer 2: Asteroids
* Layer 3: Enemies
* Layer 4: Bullets
* Layer 5: Mines

### Screen

* Game window: 1280 x 720
