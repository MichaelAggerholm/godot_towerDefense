extends Node2D

# Physics_process er som standard sat til 60 i settings. 
# Delta er den tid som er gået siden physics_process() blev kaldt.
func _physics_process(delta):
	turn()
	

func turn():
	# Vi laver en variabel som indeholder vores nuværende musseposition og sætter sprite filen "Turret" til at følge den.
	var enemy_position = get_global_mouse_position() # TODO: Skal rettes til at pege mod første enemy fremfor mus.
	get_node("Turret").look_at(enemy_position)
