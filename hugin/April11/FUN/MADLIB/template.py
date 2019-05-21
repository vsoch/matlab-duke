#!/usr/bin/python

# The line above is to run the script using ./template.py.
# Change the path after the shebang (#!) to whatever your python path is.
# Comments have a '#' in front of them.

# 'template' is the name of the class.
# Any inherited classes go in the ().
class template():

  # '__init__' is the constructor for the class... defines what goes in the object when it's made.
  # 'self' is the object itself... useful for setting object variables.
  def __init__(self):
    self.someobjectvariable = None # None is null in python.

  def __repr__(self):
    # __repr__ is what the object will look like if you print it
    # In this case we will print template<somebojectvariable:value>
    return "template<someobjectvariable:%s>"%self.someobjectvariable

  def myFunction(self):
    print "Hello world!"


# The 'main' routine for the class.
# This is where the script goes.
def main():
  mytemplate = template()
  print mytemplate
  mytemplate.myFunction()

# Only call 'main' if you're being run as a script.
# Otherwise don't do anything and act like an object
# for another script.
if __name__ == '__main__':
  main()
