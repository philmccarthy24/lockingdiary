#ifndef HDR_SERVOLOCK_H
#define HDR_SERVOLOCK_H

#include <Arduino.h>
#include <Servo.h>
#include "ILock.h"

// forward class decs
class Servo;

#define LOCK_POSITION 10
#define OPEN_POSITION 100
#define LOCK_STATE_EEPROM_ADDRESS 32

// wrapper for using a servo motor as a lock. It remembers its state between power cycles
// using EEPROM, becaue servo motor can't read back the position. Other types of electromechanical
// lock might be able to.
class ServoLock : public ILock
{
public:
  ServoLock(byte pwmPin);
  virtual ~ServoLock();

  void Initialise();
  
  virtual void Lock();
  virtual void Unlock();
  virtual bool IsLocked();

private:
  Servo m_servo;
  bool m_isLocked;
  byte m_servoPin;
};

#endif