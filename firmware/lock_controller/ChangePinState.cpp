#include "ChangePinState.h"
#include "IStatusLed.h"

ChangePinState::ChangePinState(ILockManagerContext* pContext, IStatusLed* pStatusLed) :
m_pContext(pContext),
m_pStatusLed(pStatusLed)
{
  m_keyBuffer.reserve(5);
  m_keyBuffer = "";
  m_lastKeyTime = millis();
}

ChangePinState::~ChangePinState()
{
}

void ChangePinState::OnStateChanged()
{
  m_keyBuffer = "";
  m_lastKeyTime = millis();
  m_pStatusLed->SetColour(BLUE);
}

void ChangePinState::HandleKeypress(char k)
{
  // check if user has cancelled
  if (k == '#') {
    m_pContext->UpdateState(ELockState::Unlocked);
    return;
  }

  // stop keypress timeout
  m_lastKeyTime = millis();

  m_keyBuffer += String(k);
  m_pStatusLed->Pulse();

  if (m_keyBuffer.length() == 4)
  {
    // reached 4 digits - store new pin
    m_pContext->SetPin(m_keyBuffer.c_str());
    m_pStatusLed->SetBlink(RAPID_BLINK);
    m_pContext->UpdateState(ELockState::Unlocked);
  }
}

void ChangePinState::CheckTimeout()
{
  unsigned long currTime = millis();
  if (m_keyBuffer.length() > 0 && currTime > m_lastKeyTime + PIN_ENTRY_TIMEOUT)
  {
    // reset buffer
    m_keyBuffer = "";
    m_pStatusLed->SetBlink(SLOW_BLINK);
  }
}