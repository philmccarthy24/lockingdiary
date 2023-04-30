#include "ServoLock.h"
#include <EEPROM.h>

ServoLock::ServoLock(byte pwmPin) :
m_servoPin(pwmPin)
{
  // read the last state of the lock from the EEPROM
  byte lockState = EEPROM.read(LOCK_STATE_EEPROM_ADDRESS);
  if (lockState == 0xff) {
    // eeprom hasn't been written to before - set the initial state to unlocked
    m_isLocked = false;
    EEPROM.write(LOCK_STATE_EEPROM_ADDRESS, m_isLocked);
  } else {
    m_isLocked = (bool)lockState;
  }
}

ServoLock::~ServoLock()
{
}

void ServoLock::Initialise()
{
  if (m_isLocked)
    m_servo.write(LOCK_POSITION);
  else
    m_servo.write(OPEN_POSITION);
  m_servo.attach(m_servoPin);
}

void ServoLock::Lock()
{
  m_servo.write(LOCK_POSITION);
  m_isLocked = true;
  EEPROM.update(LOCK_STATE_EEPROM_ADDRESS, m_isLocked);
}

void ServoLock::Unlock()
{
  m_servo.write(OPEN_POSITION);
  m_isLocked = false;
  EEPROM.update(LOCK_STATE_EEPROM_ADDRESS, m_isLocked);
}

bool ServoLock::IsLocked()
{
  return m_isLocked;
}