#ifndef HDR_ILOCK_H
#define HDR_ILOCK_H

class ILock
{
public:
  virtual ~ILock() {}

  virtual void Lock() = 0;
  virtual void Unlock() = 0;
  virtual bool IsLocked() = 0;
};

#endif