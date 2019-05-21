#!/usr/bin/python

class car:
  def __init__(self):
    self.tires = 4
    self.windshieldfluid = True
  
  def __repr__(self):
    return "Car<tires:%i,fluid:%s>"%(self.tires,self.windshieldfluid)

  def beepHorn(self):
    print 'Beep beep!'

def main():
  myCar = car()
  print myCar
  myCar.beepHorn()

if __name__=='__main__':
  main()
