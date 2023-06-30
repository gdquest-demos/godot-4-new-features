@tool
extends MultiMeshInstance3D

@export var count := 600
@export var base_scale := 1.0
@export_node_path var target_mesh_path
@onready var target_mesh_node := get_node(target_mesh_path) as MeshInstance3D

var triangles: Array[int] = []
var mdt : MeshDataTool
var cumulated_triangle_areas : Array
var rand : RandomNumberGenerator

func _ready() -> void:
	var mesh := target_mesh_node.mesh
	mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)

	triangles = []

	for i in mdt.get_face_count():
		var normal := mdt.get_face_normal(i)
		if normal.dot(Vector3.UP) < 0.95: continue

		var v1 := mdt.get_vertex_color(mdt.get_face_vertex(i, 0))
		var v2 := mdt.get_vertex_color(mdt.get_face_vertex(i, 1))
		var v3 := mdt.get_vertex_color(mdt.get_face_vertex(i, 2))
		var redness := (v1.r + v2.r + v3.r) / 3.0
		if redness > 0.25: continue
		triangles.append(i)

	var triangle_count := triangles.size()

	cumulated_triangle_areas.resize(triangle_count)
	cumulated_triangle_areas[-1] = 0

	for i in range(triangle_count):
		var triangle := get_triangle_verteces(triangles[i])
		var t_area: float = callv("triangle_area", triangle)
		cumulated_triangle_areas[i] = cumulated_triangle_areas[i - 1] + t_area

	multimesh.instance_count = count


	for i in count:
		var t := Transform3D(Basis(Vector3.UP, 0.0), get_random_point() + to_local(target_mesh_node.global_position))
		t = t.scaled_local(base_scale * Vector3.ONE * randfn(0.6, 0.1))
		multimesh.set_instance_transform(i, t)


func get_random_point() -> Vector3:
	var choosen_triangle := get_triangle_verteces(triangles.pick_random())
	return callv("random_triangle_point", choosen_triangle)


func get_triangle_verteces(triangle_index: int) -> Array[Vector3]:
	var a: Vector3 = mdt.get_vertex(mdt.get_face_vertex(triangle_index, 0))
	var b: Vector3 = mdt.get_vertex(mdt.get_face_vertex(triangle_index, 1))
	var c: Vector3 = mdt.get_vertex(mdt.get_face_vertex(triangle_index, 2))
	var ret: Array[Vector3] = [a, b, c]
	return ret


func triangle_area(p1 : Vector3, p2 : Vector3, p3 : Vector3) -> float:
	return (p2 - p1).cross( p3 - p1 ).length() / 2.0


func random_triangle_point(a: Vector3, b: Vector3, c: Vector3) -> Vector3:
	return a + sqrt(randf()) * (-a + b + randf() * (c - b))
