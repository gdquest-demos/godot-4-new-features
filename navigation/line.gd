extends MeshInstance3D

	
func create_line(points : PackedVector3Array):
	var points_dir = _get_points_direction(points)
	points = _smooth_points(points)
	var curve_points = []
	
	for i in points.size():
		var p : Vector3 = points[i]
		var dir : Vector3 = points_dir[i]
		
		var t = Transform3D().looking_at(dir) * 0.8
		
		var p_1 = p + t.basis.x
		var p_2 = p - t.basis.x
		curve_points.append(p_1)
		curve_points.append(p_2)
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	
	var cumulative_distance = 0.0
	var relative_distance = []
	for i in range(points.size() - 1):
		var p = points[i]
		var next = points[i + 1]
		var dist = p.distance_to(next)
		relative_distance.append(cumulative_distance)
		cumulative_distance += dist
	relative_distance = relative_distance.map(func(d):return d / cumulative_distance )
	relative_distance.append(1.0)
	
	for i in curve_points.size() / 2 - 1:
		var diff_i = i * 2
		
		_quad(st, [
			curve_points[diff_i],
			curve_points[diff_i + 2],
			curve_points[diff_i + 3],
			curve_points[diff_i + 1]
		], relative_distance[i], relative_distance[i + 1])
		
		
	st.generate_normals()
	mesh = st.commit()
	
	material_override.set_shader_parameter("ratio", Vector2(cumulative_distance / 3.0, 1.0))

func _smooth_points(source_points : PackedVector3Array):
	
	var points = source_points.duplicate()
	for i in range(1, points.size() - 1):
		var p = points[i]
		var previous = p.lerp(source_points[i - 1], 0.5)
		var next = p.lerp(source_points[i + 1], 0.5)
		p = lerp(previous, next, 0.5)
		points[i] = p
	return points
	
func _get_points_direction(points : PackedVector3Array):
	# Get lines direction
	var lines_dir = []
	for i in points.size() - 1:
		var p : Vector3 = points[i]
		var next_p : Vector3 = points[i + 1]
		lines_dir.append(p.direction_to(next_p))
	
	var points_dir = [lines_dir[0]]
	
	for i in range(1, points.size() - 1):
		var past_dir : Vector3 = lines_dir[i - 1]
		var next_dir : Vector3 = lines_dir[i]
		points_dir.append(past_dir.lerp(next_dir, 0.5))
		
	points_dir.append(lines_dir[lines_dir.size() - 1])
	
	return points_dir
	
func _quad(st : SurfaceTool, points : PackedVector3Array, offset_start : float = 0.0, offset_end : float = 0.0):
	if points.size() != 4: return
	
	st.set_uv(Vector2(0,offset_start))
	st.add_vertex(points[0])
	st.set_uv(Vector2(0,offset_end))
	st.add_vertex(points[1])
	st.set_uv(Vector2(1,offset_start))
	st.add_vertex(points[3])
	
	st.set_uv(Vector2(0,offset_end))
	st.add_vertex(points[1])
	st.set_uv(Vector2(1,offset_end))
	st.add_vertex(points[2])
	st.set_uv(Vector2(1,offset_start))
	st.add_vertex(points[3])
	
