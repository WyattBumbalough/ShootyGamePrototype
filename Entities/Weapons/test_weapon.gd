extends Weapon

var mag: int = 0

func _ready() -> void:
	hide()

func equip():
	super()
	mag = 0


func unequip():
	audio.stop()
	hide()


func shoot():
	super()
	if mag >= 12:
		can_shoot = false
		animations.play("reload")
		audio.stream = load("res://Assets/SFX/duke_reload.mp3")
		audio.play()
		await animations.animation_finished
		can_shoot = true
		mag = 0
		if Input.is_action_pressed("shoot"):
			shoot()
	else:
		animations.play("shoot")
		audio.stream = load("res://Assets/SFX/duke_shoot.mp3")
		audio.play()
		#Global.CurrentPlayer.raycast()
		can_shoot = false
		await animations.animation_finished
		mag += 1
		can_shoot = true
		if Input.is_action_pressed("shoot"):
			shoot()
