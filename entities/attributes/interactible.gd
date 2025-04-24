extends Area2D
class_name Interactible

enum InteractionResult {
	PASS, ## Interaction did not happen, will be ignored
	SUCCESS, ## Interaction was successful
	FAIL ## Interaction failed
}

func interact(_item: Item) -> InteractionResult:
	return InteractionResult.PASS
