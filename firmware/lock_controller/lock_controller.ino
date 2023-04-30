#include "ServoLock.h"
#include "StatusLed.h"
#include "LockManagerContext.h"
#include <Keypad.h>

const byte ROWS = 4; //four rows
const byte COLS = 3; //three columns
char keys[ROWS][COLS] = {
  {'1','2','3'},
  {'4','5','6'},
  {'7','8','9'},
  {'*','0','#'}
};
byte rowPins[ROWS] = {15, 20, 19, 17}; //connect to the row pinouts of the keypad
byte colPins[COLS] = {16, 14, 18}; //connect to the column pinouts of the keypad

Keypad keypad = Keypad( makeKeymap(keys), rowPins, colPins, ROWS, COLS );

ServoLock lockDevice(10); // attach to PWM pin 10
// rgb led on pwm pins 3,5 and 6
// 3 = r (150ohm resistor needed), 5 = g (100ohm resistor needed), 6 = b (100ohm resistor needed)
StatusLed statusLed(3,5,6);
LockManagerContext lockManager(&lockDevice, &statusLed);


void setup() {
  Serial.begin(115200);
  while (!Serial) {} // wait for serial interace to connect

  lockDevice.Initialise();
  lockManager.Initialise(); // needed because we can't analogueWrite to pins before this point
}

void loop() {

  // check timeouts
  lockManager.CheckTimeout();

  char key = keypad.getKey();
  if (key){
    Serial.println(key);
    lockManager.HandleKeypress(key);
  }

  // process led updates
  statusLed.ProcessUpdate();
}