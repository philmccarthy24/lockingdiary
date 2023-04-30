#ifndef HDR_ISTATUSLED_H
#define HDR_ISTATUSLED_H

#include <Arduino.h>

#define GREEN 0,32,0
#define RED 32,0,0
#define BLUE 0,0,64
#define ORANGE 32,8,0

#define RAPID_BLINK 100,100,500
#define SLOW_BLINK 400,250,1300

class IStatusLed
{
public:
  virtual ~IStatusLed() {}

  virtual void SetColour(byte r, byte g, byte b);
  virtual void SetBlink(int onMS, int offMS, int durationMS);
  virtual void Pulse();
};

#endif