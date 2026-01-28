extends TextureRect

@onready var player := $"../../../Player"

func _ready():
	visible = false

	if player:
		player.key_changed.connect(_on_key_changed)
	else:
		push_error("Player not found in group 'player'")

func _on_key_changed(hasKey: bool):
	if hasKey:
		visible = true
