extends Node

func _ready():
	# Her forbindes main menu knapperne til funktioner
	get_node("MainMenu/Margin/Container/NewGameButton").connect("pressed", self, "on_new_game_pressed")
	get_node("MainMenu/Margin/Container/QuitButton").connect("pressed", self, "on_quit_pressed")

func on_new_game_pressed():
	# Sæt MainMenu i queue til næste ledige frame, og indlæs den når klar.
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/GameScene.tscn").instance()
	add_child(game_scene)
	

# Afslut spillet.
func on_quit_pressed():
	get_tree().quit()

