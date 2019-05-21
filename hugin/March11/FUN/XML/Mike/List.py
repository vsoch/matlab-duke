#!/usr/bin/python

from xml.dom.minidom import getDOMImplementation
import os, os.path

filetypes = ['.avi','.mpg','.mpeg','.divx','.wav']

def findVideos(path):
  filepaths = list()
  for (root, dirs, files) in os.walk(path):
    for filename in files:
      if os.path.splitext(filename)[1] in filetypes:
        filepaths.append(os.path.join(root,filename))
  return filepaths

def makeXmlDocument(source_path, output_path):
  # Create XML document specific handles
  impl = getDOMImplementation()
  doc = impl.createDocument(None, 'library', None)
  root = doc.documentElement
 
  # Run our video finder
  filepaths = findVideos(source_path)
  if filepaths == None:
    print "Couldn't find any video files"
    return

  # Make nodes for our filepaths and append them to the DOM
  for filepath in filepaths:
    video = doc.createElement('video')
    video.setAttribute('source', filepath)
    root.appendChild(video)
  
  try:
    outputXml = open(output_path,'w')
    outputXml.write(doc.toprettyxml())
  except:
    print "Could not write XML document."
    return 
  
  print "Xml document generated successfully!"
  return

def main():
  makeXmlDocument('/media/Terabyte/Videos','library.xml')

if __name__ == '__main__':
  main()
