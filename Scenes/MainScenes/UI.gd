extends CanvasLayer

onready var hp_bar = get_node("HUD/InfoBar/H/HP")
# Denne del med Tween, i got no fucking idea.. rent kopieret fra youtube..
onready var hp_bar_tween = get_node("HUD/InfoBar/H/HP/Tween")

var tower_range = 750

# Funktion til preview visning af tower ved byg af nyt tower, 
# får tower_type og mouse_position fra GameScene script func initiate_build_mode
func set_tower_preview(tower_type, mouse_position):
	# Laver ny instans af valgte tower.
	var drag_tower = load("res://Scenes/Turrets/" + tower_type + ".tscn").instance()
	drag_tower.set_name("DragTower")
	
	# Hardcoded drag farve til grøn, burde skiftes til rød hvis tower ikke kan placeres
	drag_tower.modulate = Color("ad54ff3c")
	
	# Ny instans af Control som vi navngiver og sætter til mussemarkørens position.
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.rect_position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	
	# Her flyttes TowerPreview noden til layer position 0, så preview ikke dækker over de øvrige knapper i HUD.
	move_child(get_node("TowerPreview"), 0)

# Sæt position til tower_previews position, og hvis farven ikke er den samme som modtaget, ændres den.
func update_tower_preview(new_position, color):
	get_node("TowerPreview").rect_position = new_position
	if get_node("TowerPreview/DragTower").modulate != Color(color):
		get_node("TowerPreview/DragTower").modulate = Color(color)

func update_health_bar(base_health):
	# Denne del er igen med Tween for at reducere hp_bar smoothly.. got no clue how it works.. kopieret fra youtube..
	hp_bar_tween.interpolate_property(hp_bar, 'value', hp_bar.value, base_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	hp_bar_tween.start()
	if base_health >= 60:
		hp_bar.set_tint_progress("4eff15") # grøn
	elif base_health <= 60 and base_health >= 25:
		hp_bar.set_tint_progress("e1be32") # orange
	else:
		hp_bar.set_tint_progress("e11e1e") # rød
