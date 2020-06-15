package mirror

type ClockReading struct {
	Hours, Minutes int
}

func DecodeMirrorImage(in ClockReading) ClockReading {
	return ClockReading{0, 0}
}
