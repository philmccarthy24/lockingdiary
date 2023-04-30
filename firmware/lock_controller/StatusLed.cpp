#include "StatusLed.h"

StatusLed::StatusLed(byte Rpin, byte Gpin, byte Bpin) :
m_redPin(Rpin),
m_greenPin(Gpin),
m_bluePin(Bpin),
m_blinkState(NoBlink),
m_blinkOnMs(0),
m_blinkOffMs(0),
m_nextBlinkChangeTS(0),
m_blinkFinishTS(0),
m_colChangeRequested(false),
m_isPulsing(false)
{
  pinMode(Rpin, OUTPUT);
  pinMode(Gpin, OUTPUT);
  pinMode(Bpin, OUTPUT);
}

StatusLed::~StatusLed()
{
}

void StatusLed::SetColour(byte r, byte g, byte b)
{
  if (m_blinkState != EBlinkState::NoBlink) {
    // queue the colour change til after the current blink
    m_colChangeRequested = true;
    m_nextColour[0] = r;
    m_nextColour[1] = g;
    m_nextColour[2] = b;
  } else {
    m_currentColour[0] = r;
    m_currentColour[1] = g;
    m_currentColour[2] = b;
    analogWrite(m_redPin, r);
    analogWrite(m_greenPin, g);
    analogWrite(m_bluePin, b);
  }
}

void StatusLed::SetBlink(int onMS, int offMS, int durationMS)
{
  unsigned long currTS = millis();
  m_blinkState = BlinkingOff;
  m_blinkOnMs = onMS;
  m_blinkOffMs = offMS;
  m_nextBlinkChangeTS = currTS + offMS;
  m_blinkFinishTS = currTS + durationMS;
  // start the off cycle of the blink
  analogWrite(m_redPin, 0);
  analogWrite(m_greenPin, 0);
  analogWrite(m_bluePin, 0);
}

// an inline off-on pulse which delays by 100
void StatusLed::Pulse()
{
  analogWrite(m_redPin, 0);
  analogWrite(m_greenPin, 0);
  analogWrite(m_bluePin, 0);
  delay(100);
  analogWrite(m_redPin, m_currentColour[0]);
  analogWrite(m_greenPin, m_currentColour[1]);
  analogWrite(m_bluePin, m_currentColour[2]);
}

void StatusLed::ProcessUpdate()
{
  if (m_blinkState != EBlinkState::NoBlink) {
    // we are blinking
    unsigned long currTS = millis();
    if (currTS > m_blinkFinishTS)
    {
      // we've finished blinking
      m_blinkState = EBlinkState::NoBlink;
      if (m_colChangeRequested) {
        // a colour change request was lodged while blinking 
        m_currentColour[0] = m_nextColour[0];
        m_currentColour[1] = m_nextColour[1];
        m_currentColour[2] = m_nextColour[2];
        m_colChangeRequested = false;
      }
      analogWrite(m_redPin, m_currentColour[0]);
      analogWrite(m_greenPin, m_currentColour[1]);
      analogWrite(m_bluePin, m_currentColour[2]);
      return;
    }

    if (currTS > m_nextBlinkChangeTS)
    {
      // we need a blink state change
      if (m_blinkState == BlinkingOff)
      {
        // we need to go to on
        analogWrite(m_redPin, m_currentColour[0]);
        analogWrite(m_greenPin, m_currentColour[1]);
        analogWrite(m_bluePin, m_currentColour[2]);
        m_nextBlinkChangeTS = currTS + m_blinkOnMs;
        m_blinkState = EBlinkState::BlinkingOn;
      } else {
        // we need to go to off
        analogWrite(m_redPin, 0);
        analogWrite(m_greenPin, 0);
        analogWrite(m_bluePin, 0);
        m_nextBlinkChangeTS = currTS + m_blinkOffMs;
        m_blinkState = EBlinkState::BlinkingOff;
      }
    }
  }
}