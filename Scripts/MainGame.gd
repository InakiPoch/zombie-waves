extends Node2D

# Recursos que necesitaremos
const ENEMY_NORMAL = preload("res://Scenes/enemies/Enemigo.tscn");

#arreglos que contendrán a los enemigos instanciados.
var queue_enemies := {
	"normal": [],
	"chiquito":[],
	"grande":[]
}
var n_enemies:float; # Numero de enemigos totales, no modificar en codigo a menos que sea necesario.
var n_enemies_max:float;
var n_waves:int = 0; #Cantidad de rondas que llevamos.
var waveStart:bool;

#NODOS QUE UTILIZAREMOS MUCHO.
#Dejo una camara afuera porque es la que unica que vamos a utilizar para todo el juego. Una sola camara independiente del jugador.
onready var camera := get_node("Camera2D");
onready var player := get_node("Player");
onready var progress_bar := get_node("UI/round_progress");
onready var spawnTimer := get_node("ENEMIES/spawnTimer");
onready var spawnPoints := get_node("MAP_1/SpawnPoints").get_children();
onready var wave_number = get_node("UI/round_progress/TextureRect/Label2")
onready var game_over = preload("res://Scenes/GameOver.tscn")
onready var game_ui = $UI

func _ready():
	$UI/WaveGuide.visible = true
	n_waves = 0
	waveStart = false;
	player.connect("hurt",game_ui,"update_player_hearts");
	Signals.connect("game_over",self,"on_game_over")
#	$Area2D.connect("dies",self,"update_progress");
#	$Area2D.target = self;
#
func _process(delta) -> void:
	camera.position = player.position;
	if Input.is_action_just_pressed("ui_accept") && !waveStart:
		n_waves+=1;
		wave_number.text = str(n_waves)
		waveStart = true
		startWave();
		game_ui.disable_waveguide()
	
func startWave() -> void:
	#dependiendo de la cantidad de rondas, los enemigos aumentan y aparecen más.
	n_enemies_max = 10*n_waves;
	n_enemies = n_enemies_max
	#por ahora no variamos con las waves, es normal.
	randomize();
	for i in range(n_enemies_max):
		var enemy = ENEMY_NORMAL.instance();
		enemy.init(player);
		enemy.connect("dies",self,"update_progress");
		queue_enemies["normal"].append(enemy);
#		get_node("ENEMIES").add_child(enemy);
#		enemy.hide()
	
	progress_bar.value = 0;
	
	spawnTimer.start();
	AudioManager.zombie_sound_play()
	

func _on_spawnTimer_timeout() -> void:
	#por ahora así, cuando agreguemos más tipos, le hago otra cosita.
	for sp in spawnPoints:
		var enemyChild = queue_enemies["normal"].pop_back();
		if enemyChild:
			#SPAWN DE ENEMIGO; Será por puntos del mapa.
			enemyChild.position = sp.position;
#			enemyChild.show();
			get_node("ENEMIES").add_child(enemyChild);
			
	if queue_enemies["normal"].size() == 0:
		spawnTimer.stop();
#POr cada enemigo que muere, se actualiza el progreso de la ronda
func update_progress():
	n_enemies-=1;
	progress_bar.value = 100 - float(n_enemies/n_enemies_max)*100;
	if progress_bar.value == 100:
		wave_ends();

func wave_ends():
	AudioManager.zombie_sound_stop()
	game_ui.set_winlabel_visibility(n_waves)
	yield(get_tree().create_timer(2),"timeout");#Pequeña pausa para quitar la barra
	waveStart = false;
	game_ui.disable_winlabel()
	
func on_game_over():
	GameStatus.can_play = false
	var game_over_screen = game_over.instance()
	add_child(game_over_screen)
	AudioManager.zombie_sound_stop()
	
