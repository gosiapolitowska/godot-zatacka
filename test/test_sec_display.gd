extends GutTest

func test_0():
	_verify(0, "00:00")

func test_less_than_minute():
	_verify(33, "00:33")

func test_minute():
	_verify(60, "01:00")

func test_more_than_minute():
	_verify(73, "01:13")

func _verify(sec: int, expected: String):
	assert_eq(Globals.seconds_to_string(sec), expected)
