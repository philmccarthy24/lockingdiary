#ifndef HDR_UNLOCKEDSTATE_H
#define HDR_UNLOCKEDSTATE_H

#include "ILockManager.h"

// forward decs
class ILock;
class IStatusLed;
class ILockManagerContext;

class UnlockedState : public ILockManagerState
{
public:
  UnlockedState(ILockManagerContext* pContext, ILock* pLock, IStatusLed* pStatusLed);
  virtual ~UnlockedState();

  virtual void OnStateChanged();
  virtual void HandleKeypress(char k);
  virtual void CheckTimeout();

private:
  ILockManagerContext* m_pContext;
  ILock* m_pLock;
  IStatusLed* m_pStatusLed;

  String m_keyBuffer;
  unsigned long m_lastKeyTime;
};

#endif