extends GutTest

func test_enforce_world_boundaries_WhenInsideBoundaries_DoesntDespawn() -> void:
	# Given
	var bullet : Bullet = autofree(Bullet.new())
	add_child_autofree(bullet)
	bullet.global_position = Vector3(0, 0, 0)
	var min_bounds : Vector3 = Vector3(-1, -1, -1)
	var max_bounds : Vector3 = Vector3(1, 1, 1) 
	
	# When
	bullet.enforce_world_boundaries(min_bounds, max_bounds)
	await wait_frames(1)
	
	# Then 
	assert_not_null(bullet)

func test_enforce_world_boundaries_WhenOutsideBoundaries_Despawns() -> void:
	# Given
	var bullet : Bullet = autofree(Bullet.new())
	add_child_autofree(bullet)
	bullet.global_position = Vector3(2, 0, 0)
	var min_bounds : Vector3 = Vector3(-1, -1, -1)
	var max_bounds : Vector3 = Vector3(1, 1, 1) 
	
	# When
	bullet.enforce_world_boundaries(min_bounds, max_bounds)
	await wait_frames(1)
	
	# Then 
	assert_freed(bullet)

func test__on_body_entered_WhenDamageable_CallsMethod() -> void:
	# Given
	var bullet : Bullet = autofree(Bullet.new())
	
	var damageable_object = autofree(double(Damageable).new())
	
	# When
	bullet._on_body_entered(damageable_object)
	await wait_frames(1)
	
	# Then 
	assert_called(damageable_object, "take_damage")
	assert_freed(bullet)

func test__on_body_entered_WhenNotDamageable_DoesNotCrash() -> void:
	# Given
	var bullet : Bullet = autofree(Bullet.new())
	
	var non_damageable_object = autofree(double(Bullet).new())
	
	# When
	bullet._on_body_entered(non_damageable_object)
	await wait_frames(1)
	
	# Then 
	assert_freed(bullet)
