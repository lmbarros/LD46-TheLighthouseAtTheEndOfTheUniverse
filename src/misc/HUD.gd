extends CanvasLayer


func _process(delta):
	var lh = G.gs.lighthouse
	var p = G.gs.player
	
	$Stats/Lighthouse/Label/Value.text = "%s / %s" % [ lh.health, lh.maxHealth ]
	$Stats/Lighthouse.max_value = lh.maxHealth
	$Stats/Lighthouse.value = lh.health
	
	$Stats/Ship/Label/Value.text = "%s / %s" % [ p.health, p.maxHealth ]
	$Stats/Ship.max_value = p.maxHealth
	$Stats/Ship.value = p.health
