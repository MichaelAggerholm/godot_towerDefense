extends Node2D

var type
var enemy_array = []
var built = false
var enemy
var ready = true

func _ready():
	if built:
		self.get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

# Physics_process er som standard sat til 60 i settings. 
# Delta er den tid som er gået siden physics_process() blev kaldt.
func _physics_process(delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
		if ready:
			fire()
	else:
		enemy = null
	

func turn():
	# Vi laver en variabel som indeholder vores nuværende musseposition og sætter sprite filen "Turret" til at følge den.
	get_node("Turret").look_at(enemy.position)

func select_enemy():
	# For hver enemy på mappet, måles deres progress igennem mappet.
	var enemy_progress_array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func fire():
	ready = false
	# Muzzle flash aktivering
	fire_gun()
	
	enemy.on_hit(GameData.tower_data[type]["damage"])
	yield(get_tree().create_timer(GameData.tower_data[type]["rof"]), "timeout")
	ready = true

func fire_gun():
	get_node("AnimationPlayer").play("Fire")

## TURRET1
func _on_Range_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)

func _on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())

## TURRET2
func _on_Area2D_body_entered(body):
	enemy_array.append(body.get_parent())
	print(enemy_array)

func _on_Area2D_body_exited(body):
	enemy_array.erase(body.get_parent())
	
