extends GutTest

func test_take_damage_WhenDamageIsLessThanHealth_DoesntDieAndSendsSignal() -> void:
	# Given
	var damageable : Damageable = autofree(Damageable.new())
	damageable.health = 10.0
	watch_signals(damageable)
	# When
	damageable.take_damage(5.0, Vector3.ZERO)
	await wait_frames(1)
	# Then
	assert_almost_eq(damageable.health, 5.0, 0.01)
	assert_not_freed(damageable, "")
	assert_signal_emitted(damageable, "took_damage")

func test_take_damage_WhenDamageIsMoreThanHealth_Dies() -> void:
	# Given
	var damageable : Damageable = autofree(Damageable.new())
	damageable.health = 5.0
	# When
	damageable.take_damage(5.0, Vector3.ZERO)
	await wait_frames(1)
	# Then
	assert_freed(damageable)

func test_take_damage_WhenDamageIsNegative_DoesNothing() -> void:
	# Given
	var damageable : Damageable = autofree(Damageable.new())
	damageable.health = 5.0
	watch_signals(damageable)
	# When
	damageable.take_damage(-5.0, Vector3.ZERO)
	await wait_frames(1)
	# Then
	assert_almost_eq(damageable.health, 5.0, 0.01)
	assert_not_freed(damageable, "")
	assert_signal_not_emitted(damageable, "took_damage")
