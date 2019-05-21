#!/usr/bin/python

from car import car

class corvette(car):
  def __init__(self):
    car.__init__(self)
    self.windshieldfluid = False
  
  def __repr__(self):
    return "Corvette<tires:%i,fluid:%s>"%(self.tires,self.windshieldfluid)

  def beepHorn(self):
    print 'Honk honk!'

def main():
  myCar = corvette()
  print myCar
  myCar.beepHorn()

if __name__=='__main__':
  main()
