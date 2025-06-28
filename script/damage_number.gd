extends Node


func display_number(value: int, position: Vector2, color: Color = Color.WHITE):
	var number = Label.new()
	number.global_position = position
	number.text = str(value)
	number.z_index = 30
	number.label_settings = LabelSettings.new()


	number.label_settings.font_color = color
	number.label_settings.font_size = 8
	number.label_settings.outline_color = Color.BLACK
	number.label_settings.outline_size = 2
	number.label_settings.shadow_color = Color(0, 0, 0, 0.3)
	number.label_settings.shadow_offset = Vector2(1, 1)
	
	call_deferred("add_child", number)

	await number.resized
	number.pivot_offset = Vector2(number.size / 2)

	
	var strength = 20

	
	var offset = Vector2(randf_range(strength * -1, strength), strength * -1)

	var tween = get_tree().create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		number, "position", number.position + offset, 0.4
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


	# Scale out at end
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.3
	).set_ease(Tween.EASE_IN).set_delay(0.4)

	await tween.finished
	number.queue_free()
