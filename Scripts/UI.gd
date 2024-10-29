extends CanvasLayer

func _ready():
	$WinLabel.visible = false
	$WaveGuide.visible = false
	
func disable_waveguide():
	$WaveGuide.visible = false

func set_winlabel_visibility(n_waves: int):
	$WinLabel.text = str("WAVE ",n_waves," COMPLETE")
	$WinLabel.visible = true

func disable_winlabel():
	$WinLabel.visible = false
	$WaveGuide.visible = true

func update_player_hearts(ui_index):
	$Vida.get_children()[ui_index].modulate = Color(0,0,0)
