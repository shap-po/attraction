extends Interactible
class_name WorldItem

var item: Item

const WORLD_ITEM: PackedScene = preload("res://entities/inventory/world_item/world_item.tscn")
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	sprite_2d.texture = item.item_texture

static func create(item: Item) -> WorldItem:
	var instance: WorldItem = WORLD_ITEM.instantiate()
	instance.item = item
	return instance

func try_pickup(inventory: EditableInventory) -> bool:
	var res: bool = inventory.add_item(item)
	if res:
		queue_free()
	return res

func interact(player: Player, _item: Item) -> InteractionResult:
	var res: bool = try_pickup(player.inventory)

	if res:
		return InteractionResult.SUCCESS
	return InteractionResult.PASS
