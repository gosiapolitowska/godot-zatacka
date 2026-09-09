class_name TextureGenerator
extends Node

#var margin := -10
var cutoff := 7

func generate(action1: String, action2: String, max_height: float = -1.0) -> Texture2D:
	var icon1 = InputIconTextureRect.new()
	icon1.action_name = action1
	var texture1 = icon1.texture
	
	var icon2 = InputIconTextureRect.new()
	icon2.action_name = action2
	var texture2 = icon2.texture
	
	var combined = Image.create_empty(texture1.get_size().x * 2 - 4 * cutoff, texture1.get_size().y - 2 * cutoff, false, Image.FORMAT_RGBA8)
	var cutoff_v = Vector2(cutoff, cutoff)
	combined.blit_rect(texture1.get_image(), Rect2(cutoff_v, texture1.get_size() - 2 * cutoff_v), Vector2.ZERO)
	combined.blit_rect(texture2.get_image(), Rect2(cutoff_v, texture2.get_size() - 2 * cutoff_v), Vector2(texture1.get_size().x - 2 * cutoff, 0))
	
	var texture = ImageTexture.create_from_image(combined)
	var texture_height = texture.get_size().y
	if max_height > 0 and texture_height > max_height:
		var shrinking_factor = texture_height / max_height
		texture.set_size_override(texture.get_size() / shrinking_factor)
	return texture
