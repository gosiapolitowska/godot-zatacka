class_name TextureGenerator
extends Node

const gap = 10

func generate(action1: String, action2: String, max_height: float = -1.0) -> Texture2D:
	Log.debug("generating texture for %s / %s" % [action1, action2])
	var icon1 = InputIconTextureRect.new()
	icon1.action_name = action1
	var texture1 = icon1.texture
	
	var icon2 = InputIconTextureRect.new()
	icon2.action_name = action2
	var texture2 = icon2.texture
	
	var combined = Image.create_empty(texture1.get_size().x * 2 + gap, texture1.get_size().y, false, Image.FORMAT_RGBA8)
	combined.blit_rect(texture1.get_image(), Rect2(Vector2.ZERO, texture1.get_size()), Vector2.ZERO)
	combined.blit_rect(texture2.get_image(), Rect2(Vector2.ZERO, texture2.get_size()), Vector2(texture1.get_size().x + gap, 0))
	
	var texture = ImageTexture.create_from_image(combined)
	var texture_height = texture.get_size().y
	if max_height > 0 and texture_height > max_height:
		var shrinking_factor = texture_height / max_height
		texture.set_size_override(texture.get_size() / shrinking_factor)
	return texture
