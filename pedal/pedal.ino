#include <HijelHID_BLEKeyboard.h>

// Cards installed: ESP32
// Libs installed: HijelHID_BLEKeyboard
// Connect pins 13, 12, 14, 27, 26, 25 to GND to get 0, 1, 2, 3, 4, 9
HijelHID_BLEKeyboard keyboard;

// Define the GPIO pins you want to use
const int NUM_KEYS = 6;
const int buttonPins[NUM_KEYS] = {13, 12, 14, 27, 26, 25};

// Map each pin to its corresponding key
const uint8_t keyMap[NUM_KEYS] = {KEY_0, KEY_1, KEY_2, KEY_3, KEY_4, KEY_9};

// Track the previous state of each button to detect initial press
int lastButtonStates[NUM_KEYS];

void setup() {
	Serial.begin(115200);
	keyboard.setLogLevel(HIDLogLevel::Normal);
	keyboard.begin();

	// Initialize all pins with internal pull-up resistors
	for (int i = 0; i < NUM_KEYS; i++) {
		pinMode(buttonPins[i], INPUT_PULLUP);
		lastButtonStates[i] = HIGH;
	}
	Serial.println("Multi-pin Keyboard Ready. Connect mapped pins to GND.");
}

void loop() {
	// Only process keypresses if a Bluetooth device is connected
	if (!keyboard.isPaired()) { return; }

	for (int i = 0; i < NUM_KEYS; i++) {
		int currentState = digitalRead(buttonPins[i]);

		// Detect transitions from HIGH to LOW (button press)
		if (currentState == LOW && lastButtonStates[i] == HIGH) {
			delay(50); // Debounce delay

			// Re-verify the pin is still pulled LOW
			if (digitalRead(buttonPins[i]) == LOW) {
				Serial.print("Pin ");
				Serial.print(buttonPins[i]);
				Serial.println(" triggered.");
				keyboard.tap(keyMap[i]);
			}
		}
		lastButtonStates[i] = currentState;
	}
	delay(10);
}
