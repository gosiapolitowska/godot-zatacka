extends GutTest

func test_0():
	_verify(0, "00:00.000")

func test_less_than_minute():
	_verify(33000, "00:33.000")

func test_minute():
	_verify(60000, "01:00.000")

func test_more_than_minute():
	_verify(73000, "01:13.000")

func test_millis_more_than_minute():
	_verify(73365, "01:13.365")

func _verify(sec: int, expected: String):
	assert_eq(Globals.millis_to_string(sec), expected)
