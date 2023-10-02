extends MeshInstance3D

func _ready():
	var mat = mesh.material.duplicate(true)
	mesh.material = mat
	mat.albedo_color = Color(1,0,0,0)
	var tween = get_tree().create_tween()
	tween.tween_property(mat,"albedo_color", Color(1,0,0,1), 1.0)
	await get_tree().create_timer(1.0).timeout
	tween = get_tree().create_tween()
	tween.tween_property(mat,"albedo_color", Color(1,0,0,0), 1.0)
	await get_tree().create_timer(1.0).timeout
	queue_free()
