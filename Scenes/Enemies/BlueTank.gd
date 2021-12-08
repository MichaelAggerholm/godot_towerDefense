extends PathFollow2D

signal base_damage(damage)

var speed = 150
var hp = 50
var base_damage = 21

onready var health_bar = get_node("HealthBar")
onready var impact_area = get_node("Impact")
var projectile_impact = preload("res://Scenes/SupportScenes/projectileImpact.tscn")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	# Sætter healthbar til top level layer.
	health_bar.set_as_toplevel(true)

func _physics_process(delta):
	if unit_offset == 1.0:
		# Base damage er hvor tanken faktisk deler skade til spilleren hvis den ikke bliver ødelagt inden banens udgang.
		emit_signal("base_damage", base_damage)
		# Hvis ikke vi sætter tanks fri af queue ved end of line, stacker de bare ved slutningen af map....!
		queue_free()
	move(delta)

# giver en glidende kørsel af tanken på map, fremfor at hakke, da den udregner hastighed fra sidste passerede tile.
func move(delta):
	set_offset(get_offset() + speed * delta)
	# Sørger for at healthbar altid er på toppen, også hvis enemy position roterer.
	health_bar.set_position(position - Vector2(30, 30))

# Fratræk hp on hit, dø hvis under 0
func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()

func impact():
	# randi() vil altid få samme resultat i samme scene, derfor randomizer jeg randi().
	randomize()
	# % 31 betyder at vi altid vil få et resultat mellem 1 og 30
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	# Vector2 bruges til faktisk at give os en lokation ud fra de to random positioner.
	var impact_location = Vector2(x_pos, y_pos)
	# Her laves en ny instans af vores scene som er defineret med path i toppen.
	var new_impact = projectile_impact.instance()
	# sætter positionen for nye instans, og tilføjer nyt impact som child scene.
	new_impact.position = impact_location
	impact_area.add_child(new_impact)

func on_destroy():
	self.queue_free()
