package mirror

type ClockReading struct {
	Hours, Minutes int
}

func decodeHours(hours int) int {
	if hours == 11 { return 12}
	if hours == 12 { return 11}
	return 11 - hours
}

func DecodeMirrorImage(in ClockReading) ClockReading {
	var decodedHours int
	if in.Minutes == 0 {
		if in.Hours == 12 {
			decodedHours = 12
		} else {
			decodedHours = 12 - in.Hours
		}
	} else {
		decodedHours = decodeHours(in.Hours)
	}

	return ClockReading{
		decodedHours,
		(60 - in.Minutes) % 60,
	}
}
