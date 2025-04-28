class_name Util

static func enum_to_str(enum_def: Dictionary, value: int) -> String:
	for key in enum_def.keys():
		if enum_def[key] == value:
			return key
	return ""
