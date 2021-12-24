extends Object

class_name ItemStack

func _init(info: ItemInfo, amount: int) -> void:
	assert(info, "the itemInfo cannot be null in an ItemStack")
	assert(amount > 0, "the given amount: %s cannot be smaller or equal to 0" % amount)
	self.info = info
	self.amount = amount

func add(amount: int) -> int:
	var result = self.amount + amount
	var stackLimit = info.stackLimit
	if result > stackLimit:
		amount = stackLimit
		return result - stackLimit
	# else
	
	amount = result
	return 0

func reduce(amount: int) -> int:
	var result = self.amount - amount
	if result < 0:
		# make sure this is positive
		amount = 0 # normally this should not exist, but if this is 0, then that means you forgot to remove this item stack
		return -result
	# else
	amount = result
	return 0

func is_full() -> bool:
	return self.amount >= info.stackLimit

var info: ItemInfo
var amount: int
