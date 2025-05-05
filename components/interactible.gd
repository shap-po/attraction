## Base class for objects, player can interact with
## Note that Interactible need to have "2" collision enabled to work
extends Area2D
class_name Interactible

enum InteractionResult {
	PASS, ## Interaction did not happen, will be ignored
	SUCCESS, ## Interaction was successful
	FAIL, ## Interaction failed
	CONSUME, ## Item was consumed
}

func interact(_player: Player, _item: Item) -> InteractionResult:
	return InteractionResult.PASS
