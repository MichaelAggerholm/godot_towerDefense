extends Node

func _ready():
	load_main_menu()

func load_main_menu():
	# Her forbindes main menu knapperne til funktioner
	get_node("MainMenu/Margin/Container/NewGameButton").connect("pressed", self, "on_new_game_pressed")
	get_node("MainMenu/Margin/Container/QuitButton").connect("pressed", self, "on_quit_pressed")

func on_new_game_pressed():
	# Sæt MainMenu i queue til næste ledige frame, og indlæs den når klar.
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	
	# Hvis "game_finished" triggers, trigges funktionen "unload_game"
	game_scene.connect("game_finished", self, 'unload_game')	
	add_child(game_scene)
	

# Afslut spillet.
func on_quit_pressed():
	get_tree().quit()

func unload_game(result):
	# Lille hack.. vi loader menuen, men uden de to knapper der er sat i _ready funktionen, så derfor skal load_main_menu køres igen.
	get_node("GameScene").queue_free()
	var main_menu = load("res://Scenes/UIScenes/MainMenu.tscn").instance()
	add_child(main_menu)
	load_main_menu()
