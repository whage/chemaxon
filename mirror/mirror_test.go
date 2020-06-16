package mirror

import "testing"

func TestDecodeMirrorImage(t *testing.T) {
	inputs := []ClockReading{
		ClockReading{5, 25},
		ClockReading{1, 50},
		ClockReading{11, 58},
		ClockReading{12, 1},
		ClockReading{4, 0},
		ClockReading{12, 0},
		ClockReading{6, 0},
	}

	expectedOutputs := []ClockReading{
		ClockReading{6, 35},
		ClockReading{10, 10},
		ClockReading{12, 2},
		ClockReading{11, 59},
		ClockReading{8, 0},
		ClockReading{12, 0},
		ClockReading{6, 0},
	}

	for idx, expected := range expectedOutputs {
		result := DecodeMirrorImage(inputs[idx])
		if result != expected {
			t.Errorf("Expected %v for %v, got %v instead.", expected, inputs[idx], result)
		}
	}
}
