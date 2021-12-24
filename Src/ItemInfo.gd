extends Resource

class_name ItemInfo

func can_stack_together(infoA, infoB) -> bool:
	return infoA.name == infoB.name

export var name: String
export var texture: Texture
export var stackLimit: int
