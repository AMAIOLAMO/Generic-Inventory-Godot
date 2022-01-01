extends Resource

class_name ItemInfo

func is_in_group(group: String) -> bool:
	if _is_in_built_in_group(group): return true
	return itemGroup.find(group) != -1

func _is_in_built_in_group(group: String) -> bool:
	return false

export var name: String
export var texture: Texture
export var stackLimit: int

export(Array, String) var itemGroup: Array
