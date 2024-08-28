extends GutTest

func test_bullet_HappyPath() -> void:
	# Given
	var scene = RessourceMappings.TEST_BULLET_SCENE.instantiate()
	add_child_autofree(scene)
	var bullet : Bullet = scene.get_node("Bullet")
	var damageable : Damageable = scene.get_node("Damageable")
	
	# When
	await wait_for_signal(damageable.took_damage, 1.0, "Waiting for bullet to hit object")
	
	# Then
	assert_freed(bullet)
	assert_signal_emitted(damageable, "took_damage")
