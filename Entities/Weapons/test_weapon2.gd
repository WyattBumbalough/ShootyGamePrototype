extends Weapon

var mag: int = 0

func _ready() -> void:
	hide()

func equip():
	show()
	mag = 0
	if animations:
		animations.play("equip")

func unequip():
	audio.stop()
	hide()


func shoot():
	super()
	animations.play("shoot")
	audio.stream = load("res://Assets/SFX/doom_SS_shoot.mp3")
	audio.play()
	can_shoot = false
	await animations.animation_finished
	reload()

func reload():
		can_shoot = false
		animations.play("reload")
		audio.stream = load("res://Assets/SFX/doom_SS_reload.mp3")
		audio.play()
		await animations.animation_finished
		can_shoot = true
		
