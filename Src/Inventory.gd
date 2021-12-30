extends Object

class_name Inventory

func _init(initialSize: int = 0) -> void:
	if initialSize > 0:
		_itemStacks.resize(initialSize)

func remove_item(index: int) -> void:
	_itemStacks.remove(index)
	emit_signal("changed")

func set_item(index: int, itemStack: ItemStack) -> void:
	_itemStacks[index] = itemStack
	emit_signal("changed")

func add_item(itemInfo: ItemInfo, amount: int, maxStackCount: int = 99999999) -> int:
	var remaining = _add_into_existing_slots(itemInfo, amount)
	
	if remaining > 0:
		remaining = _append_to_end(itemInfo, remaining, maxStackCount)
	
	# after adding
	if remaining != amount:
		emit_signal("changed")
	
	return remaining

func add_stack(itemStack: ItemStack, maxStackCount: int = 99999999) -> int:
	return add_item(itemStack.info, itemStack.amount, maxStackCount)

func get_item(index: int) -> ItemStack:
	return _itemStacks[index]

func resize(size: int) -> void:
	if size == size(): return
	# else
	_itemStacks.resize(size)
	emit_signal("changed")

func size() -> int:
	return _itemStacks.size()

func empty() -> bool:
	return _itemStacks.empty()

func get_item_stacks() -> Array:
	return _itemStacks

func _add_into_existing_slots(itemInfo: ItemInfo, amount: int) -> int:
	var remaining = amount
	for i in size():
		if remaining <= 0: break
		
		var currentStack: ItemStack = _itemStacks[i]
		
		# if currently empty, then we just add it into the emptiness
		if not currentStack:
			var extra := _calculate_remaining(itemInfo.stackLimit, remaining)
			var resultAmount := itemInfo.stackLimit if extra > 0 else remaining
			remaining = extra
			_itemStacks[i] = ItemStack.new(itemInfo, resultAmount)
			continue
		if not _can_stack_together(currentStack.info, itemInfo): continue
		# else
		
		
		remaining = currentStack.add(remaining)
	
	return remaining

func _append_to_end(itemInfo: ItemInfo, amount: int, maxStackCount: int) -> int:
	var remaining = amount
	
	var i = max(size() - 1, 0)
	while i < maxStackCount:
		if remaining <= 0: break
		# else
		
		var extra = _calculate_remaining(itemInfo.stackLimit, remaining)
		var resultAmount := itemInfo.stackLimit if extra > 0 else remaining

		var newStack := ItemStack.new(itemInfo, resultAmount)
		_itemStacks.append(newStack)

		remaining = extra
		
		i += 1

	return remaining

func _can_stack_together(infoA: ItemInfo, infoB: ItemInfo) -> bool:
	return infoA.name == infoB.name

static func _calculate_remaining(stackLimit: int, amount: int) -> int:
	if amount > stackLimit:
		return amount - stackLimit
	# else
	
	return 0

var _itemStacks := []

signal changed
