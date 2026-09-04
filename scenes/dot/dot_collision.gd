extends CollisionShape2D

var size: int = 8:
	set(value):
		size = value
		recreate()

func recreate():
	(shape as CircleShape2D).radius = size / 2
