#ifndef HDR_ILOCKMANAGER_H
#define HDR_ILOCKMANAGER_H

#include <Arduino.h>

#define PIN_ENTRY_TIMEOUT 2000

typedef enum _ELockState
{
  Unlocked,
  Locked,
  ChangePin
} ELockState;

class ILockManagerContext
{
public:
  virtual ~ILockManagerContext() {}

  virtual void UpdateState(ELockState newState) = 0;
  virtual void SetPin(const char* newPin) = 0;
  virtual const char* GetPin() = 0;
};

class ILockManagerState
{
public:
  virtual ~ILockManagerState() {}

  virtual void OnStateChanged() = 0;
  virtual void HandleKeypress(char k) = 0;
  virtual void CheckTimeout() = 0;
};

#endif