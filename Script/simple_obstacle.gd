extends Node2D

func take_damage(damage,source):
	if damage > 0:
		print("%s was killed by %s" % [self,source])
		queue_free()
