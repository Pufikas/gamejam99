extends Node

@onready var music_player : AudioStreamPlayer = $MusicPlayer
@onready var sfx_player : AudioStreamPlayer = $SFXPlayer

@export var music_tracks : Array[AudioStream] = []

var current_music : int = -1

func _ready() -> void:
	music_player.finished.connect(_on_music_finished)
	music_player.volume_db = -30.0
	sfx_player.volume_db = -20.0

func _on_music_finished() -> void:
	var next_track = (current_music + 1) % music_tracks.size()
	play_music(next_track)

func fade_music(new_track: int) -> void:
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -40.0, 1.0)
	
	await tween.finished
	play_music(new_track)
	
	var fade_in = create_tween()
	fade_in.tween_property(music_player, "volume_db", -20.0, 1.0)

func play_music(index: int) -> void:
	if index < 0 or index >= music_tracks.size():
		return
	
	if current_music == index and music_player.playing:
		return
	
	current_music = index
	music_player.stream = music_tracks[index]
	music_player.play()

func play_sfx(sound: AudioStream) -> void:
	sfx_player.stream = sound
	sfx_player.play()
