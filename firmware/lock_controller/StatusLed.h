#ifndef HDR_STATUSLED_H
#define HDR_STATUSLED_H

#include "IStatusLed.h"

typedef enum _EBlinkState {
  NoBlink,
  BlinkingOff,
  BlinkingOn
} EBlinkState;

class StatusLed : public IStatusLed
{
public:
  StatusLed(byte Rpin, byte Gpin, byte Bpin);
  virtual ~StatusLed();

  virtual void SetColour(byte r, byte g, byte b);
  virtual void SetBlink(int onMS, int offMS, int durationMS);
  virtual void Pulse();

  void ProcessUpdate();

private:
  byte m_redPin;
  byte m_greenPin;
  byte m_bluePin;

  EBlinkState m_blinkState;
  int m_blinkOnMs;
  int m_blinkOffMs;
  unsigned long m_nextBlinkChangeTS;
  unsigned long m_blinkFinishTS;
  bool m_colChangeRequested;
  byte m_currentColour[3];
  byte m_nextColour[3]; // colour to set after current blink

  bool m_isPulsing;
};

#endif