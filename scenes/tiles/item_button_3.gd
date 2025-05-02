extends AspectRatioContainer

@onready var item_visual: TextureRect = $button/itemTexture
@onready var item_price: Label = $button/itemPrice
@onready var item_count: Label = $button/itemCount

func update(item: Item):
	if item == null:
		item_visual.visible = false
		item_price.visible = false
		item_count.visible = false
		return
	item_visual.visible = true 
	item_visual.texture = item.item_texture
	
	if item.buy_price != 0:
		item_price.visible = true
		item_price.text = str(item.buy_price)
	else:
		item_price.visible = false
		
	if item is CountableItem:
		item_count.text = str(item.count)
		item_count.visible = true
	else	:
		item_count.visible = false
