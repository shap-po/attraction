## Tool for loading resources from specified directories
class_name ResourceDirLoader

static func _get_files(path: String, recursive: bool = true) -> Array[String]:
	var files: Array[String] = []

	for file: String in DirAccess.get_files_at(path):
		var full_path: String = path.path_join(file)
		if not ResourceLoader.exists(full_path):
			continue

		files.append(full_path)

	if recursive:
		for dir: String in DirAccess.get_directories_at(path):
			files.append_array(_get_files(path.path_join(dir), recursive))

	return files

static func scan(dirs: Array[String], recursive: bool = true) -> Array[String]:
	var output: Array[String] = []

	for dir in dirs:
		if dir == "":
			continue
		for file in _get_files(dir, recursive):
			output.append(file)

	return output

static func load(dirs: Array[String], recursive: bool = true) -> Array[Resource]:
	var output: Array[Resource] = []

	for file: String in scan(dirs, recursive):
		var res: Resource = ResourceLoader.load(file)
		if res:
			output.append(res)

	return output
