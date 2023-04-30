#ifndef HDR_CHANGEPINSTATE_H
#define HDR_CHANGEPINSTATE_H

#include "ILockManager.h"

// forward decs
class IStatusLed;
class ILockManagerContext;

class ChangePinState : public ILockManagerState
{
public:
  ChangePinState(ILockManagerContext* pContext, IStatusLed* pStatusLed);
  virtual ~ChangePinState();

  virtual void OnStateChanged();
  virtual void HandleKeypress(char k);
  virtual void CheckTimeout();

private:
  ILockManagerContext* m_pContext;
  IStatusLed* m_pStatusLed;

  String m_keyBuffer;
  unsigned long m_lastKeyTime;
};

#endif