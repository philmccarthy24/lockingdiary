#include "UnlockedState.h"
#include "IStatusLed.h"
#include "ILock.h"

UnlockedState::UnlockedState(ILockManagerContext* pContext, ILock* pLock, IStatusLed* pStatusLed) :
m_pContext(pContext),
m_pLock(pLock),
m_pStatusLed(pStatusLed)
{
  m_keyBuffer.reserve(5);
  m_keyBuffer = "";
  m_lastKeyTime = millis();
}

UnlockedState::~UnlockedState()
{
}

void UnlockedState::OnStateChanged()
{
  m_keyBuffer = "";
  m_lastKeyTime = millis();
  m_pStatusLed->SetColour(GREEN);
}

void UnlockedState::HandleKeypress(char k)
{
  // stop keypress timeout
  m_lastKeyTime = millis();

  m_keyBuffer += String(k);
  m_pStatusLed->Pulse();

  if (m_keyBuffer.equals("###"))
  {
    // user wants to change pin
    m_pContext->UpdateState(ELockState::ChangePin);
  }
  else if (m_keyBuffer.equals(m_pContext->GetPin())) 
  {
    // user wants to lock. Move servo to locking position
    m_pLock->Lock();
    m_pContext->UpdateState(ELockState::Locked);
  } 
  else if (m_keyBuffer.length() == 4)
  {
    Serial.println("Buffer reached 4 chars, clearing");
    // reached 4 digits without match - reset buffer
    m_keyBuffer = "";
    m_pStatusLed->SetColour(ORANGE);
    m_pStatusLed->SetBlink(SLOW_BLINK);
    m_pStatusLed->SetColour(GREEN);
  }
}

void UnlockedState::CheckTimeout()
{
  unsigned long currTime = millis();
  if (m_keyBuffer.length() > 0 && currTime > m_lastKeyTime + PIN_ENTRY_TIMEOUT)
  {
    // reset buffer
    m_keyBuffer = "";
    m_pStatusLed->SetColour(ORANGE);
    m_pStatusLed->SetBlink(SLOW_BLINK);
    m_pStatusLed->SetColour(GREEN);
  }
}