extends CanvasLayer

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
