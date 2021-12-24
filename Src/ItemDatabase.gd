extends Node

func _ready() -> void:
	_initialize_database()
	
	print("loaded %s items" % _items.size())

func _initialize_database() -> void:
	var directory = Directory.new()
	directory.open(DATABASE_DIRECTORY)
	directory.list_dir_begin()
	
	var fileName = directory.get_next()
	
	while(fileName):
		if not directory.current_is_dir():
			_items.append(load(DATABASE_DIRECTORY + ("/%s" % fileName)))
		fileName = directory.get_next()

func get_id(name: String) -> int:
	for i in _items.size():
		var item: ItemInfo = _items[i]
		if item.name != name: continue
		# else
		return i

	# else
	
	return -1

func get_info(id: int) -> ItemInfo:
	return _items[id] as ItemInfo

func valid(id: int) -> bool:
	return id > -1 && id < _items.size()

const DATABASE_DIRECTORY = "res://Vendor/Database/Items"

var _items: Array
