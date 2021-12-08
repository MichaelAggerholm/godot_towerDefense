extends Node2D

var map_node

var build_mode = false
var build_valid = false
var build_tile
var build_location
var build_type

var current_wave = 0
var enemies_in_wave = 0

func _ready():
	map_node = get_node("Map1") # Gemmer selected map som variabel
	
	# Registrer vores build_buttons, hvis trykket på, tag valgte turret(via i.get_name) med til initiate_build_mode
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])
		
	start_next_wave()

func _process(delta):
	if build_mode:
		update_tower_preview()

func _unhandled_input(event):
	# Hvis ui_cancel(højreklik) er released, og build mode er true, stoppes build mode.
	if event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()
	# Hvis ui_accept(censtreklik) er released, og build mode er true, Bygges der, og derefter stoppes build mode.
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()

##
## MOB WAVE FUNKTIONER ER HERUNDER.
##
func start_next_wave():
	# Her instansieres et wave, da ikke alle waves skal være ens, for senere hen at 
	# kunne tilføje mere modstand.
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(2), "timeout") # Tid imellem waves.
	spawn_enemies(wave_data)

func retrieve_wave_data():
	# Her er hardcoded 2 tanks, 0.7 og 0.1 er spawn tiden mellem de to tanks.
	var wave_data = [["BlueTank", 2.0], ["BlueTank", 2.0], ["BlueTank", 2.0], ["BlueTank", 2.0]]
	# Holder styr på hvilket wave vi er ved.
	current_wave += 1
	# Holder styr på hvor mange enemies der er tilbage i nuværende wave.
	enemies_in_wave = wave_data.size()
	return wave_data

func spawn_enemies(wave_data):
	for i in wave_data:
		# Opretter ny enemy til wave.
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instance()
		map_node.get_node("Path").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]), "timeout")

##
## FUNKTIONER TIL AT BYGGE TOWERS ER HERUNDER.
##
func initiate_build_mode(tower_type):
	# Hvis vi allerede er i build mode, stopper vi build mode. Så der f.eks kan vælges nyt tower_type.
	if build_mode:
		cancel_build_mode()
	
	# Gem valgte tower i build_type og sæt build_mode til true.
	build_type = tower_type
	build_mode = true
	
	# Benyt UI noden, brug funktionen set_tower_preview som kommer fra UI script,
	# til at lave et preview på mussemarkøren af det valgte tårn der skal bygges.
	# set_tower_preview funktionen er i UI scriptet, da den skal være øverste layer, for at være visuelt for brugeren.
	get_node("UI").set_tower_preview(build_type, get_global_mouse_position())

func update_tower_preview():
	# Skaf ny markørposition
	var mouse_position = get_global_mouse_position()
	
	# Her "matcher" vi grid position til vores tower node som følger musen, 
	# det er i bund og grund her systemet ser om tower kan være, hvor vi prøver at placere det.
	# TowerExclusions er hvor på mappet vi har defineret "blocks", altså der ikke kan bygges på.
	var current_tile = map_node.get_node("TowerExclusion").world_to_map(mouse_position)
	var tile_position = map_node.get_node("TowerExclusion").map_to_world(current_tile) + Vector2(32,32)
	
	# hvis der ikke er en eksisterende tile på placeringen, kan vi bygge der
	# og så vil towereret som vi dragger, forblive grønt.
	if map_node.get_node("TowerExclusion").get_cellv(current_tile) == -1:
		get_node("UI").update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		# Sæt build_location til den tile_position som er tilgængelig.
		build_location = tile_position
		build_tile = current_tile
	else :
		# Her kan ikke bygges.. gør tower drag farven til rød og sæt build_valid til false.
		get_node("UI").update_tower_preview(tile_position, "adff4545")
		build_valid = false

func cancel_build_mode():
	# sætter både build_mode og build_valid tilbage til deres default false værdier.
	build_mode = false
	build_valid = false
	
	# Fjerner det tower preview der er på mussemarkøren.
	get_node("UI/TowerPreview").free()

func verify_and_build():
	if build_valid:
		# TODO: Test om spilleren har tilstrækkeligt Penge
		
		# Hvis tower build er valid, laves der en ny instans af tower, og tilføjes til child til Towers, 
		# med den valgte position, da toweret blev placeret. 
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		new_tower.built = true
		new_tower.type = build_type
		map_node.get_node("Turrets").add_child(new_tower, true)
		
		# Tilføj tile med id 3 til Map1, dette er et "usynligt" tile, 
		# som gør at der ikke kan bygges et tårn ovenpå et tårn.
		map_node.get_node("TowerExclusion").set_cellv(build_tile, 3)
		
		# TODO: Reduser pengene fra tårnet.
		# TODO: Opdater penge i visning.
