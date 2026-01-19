extends HBoxContainer

@onready var HeartGUIClass = preload("res://HeartGUI.tscn")

func setMaxHearts(maxNum: int):
	for i in range(maxNum):
		var heart = HeartGUIClass.instantiate()
		add_child(heart)

func updateHearts(currentHealth: int):
	var hearts = get_children()
	for i in range(currentHealth):
		hearts[i].update(true)
	for i in range(currentHealth, hearts.size()):
		hearts[i].update(false)
