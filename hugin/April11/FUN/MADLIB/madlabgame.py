#!/usr/bin/env python

import gtk, sys

class PyApp(gtk.Window):
    def __init__(self):
        super(PyApp, self).__init__()
        self.windowSetup()
	self.show_all()
    
    def windowSetup(self):
	self.set_title("SASS: SPM Analysis Script Setup")
        self.connect("destroy", gtk.main_quit)    # connects destroy signal to main_quit 
        self.set_size_request(400, 200)           # set size of window
        self.modify_bg(gtk.STATE_NORMAL, gtk.gdk.Color(6400, 6400, 6440))
	self.set_position(gtk.WIN_POS_CENTER)
	self.tableSetup()

    # Set up table based on number of variables	(should eventually takeb in various fields?)	
    def tableSetup(self):
	table = gtk.Table(8,4,False)
	table.set_col_spacings(3)
	title = gtk.Label("Title")
	halign = gtk.Alignment(0,0,0,0)
	halign.add(title)
	table.attach(halign,0,1,0,0,gtk.FILL,gtk.FILL,0,0)
	table.set_row_spacing(1,3)
	table = self.textArea(table)
	self.buttonSetup(table)   # should there be an addbutton function?
       
	
    def textArea(self,table):
 	wins = gtk.TextView()
	wins.set_editable(False)
	wins.modify_fg(gtk.STATE_NORMAL,gtk.gdk.Color(5140,5140,5140))
	wins.set_cursor_visible(False)
	table.attach(wins,0,20103,gtk.FILL | gtk.EXPAND | gtk.FILL | gtk.EXPAND,1,1)
	return table 
	
    def menuSetup(self,table,box):
        mb = gtk.MenuBar()
    	filemenu = gtk.Menu()
        filem = gtk.MenuItem("File")
	filea = gtk.MenuItem("About")
	filem.set_submenu(filemenu)
	filea.set_submenu(filemenu)
        mb.append(filem)
	mb.append(filea)
	#box.pack_start(mb, False, False, 0)
        table.attach(box,3,4,2,3,gtk.FILL,gtk.FILL | gtk.EXPAND,1,1)
	

    def buttonSetup(self,table):	
	
	buttonnew = gtk.Button("Button")
	buttonnew.set_sensitive(False)
	buttonopen = gtk.Button("Open")
	buttonopen.set_sensitive(True)
	buttonopen.set_size_request(80,40)
	buttonclose = gtk.Button(stock=gtk.STOCK_CLOSE)
		
	#vbox = gtk.VBox(False, 5)		# vertical box
         #hbox = gtk.HBox(True, 3)		# horizontal box
	
	valign = gtk.Alignment(0, 0, 0, 0)
        #vbox.pack_start(valign)			# xalign,yalign,xscale,yscale

	valign.add(buttonnew)			# put buttons in horizontal box
	valign.add(buttonopen)
	valign.add(buttonclose)
	table.attach(valign,3,4,2,3,gtk.FILL,gtk.FILL | gtk.EXPAND,1,1)
	
	#halign = gtk.Alignment(1, 0, 0, 0)	# create horizontal alignment
        #halign.add(hbox)			# add horizontal box to alignment container
        
	self.menuSetup(table,valign)
       
	
        #box.pack_start(halign, False, False, 3)
	
        self.add(table)

		
PyApp()		# create an instance of our GUI program
gtk.main()	# call the main loop
