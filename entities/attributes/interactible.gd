extends Area2D
class_name Interactible

enum InteractionResult {
	PASS,
	SUCCESS,
	FAIL
}

func interact(item) -> InteractionResult:
	return InteractionResult.PASS
