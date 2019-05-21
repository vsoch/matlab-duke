#!/usr/bin/env python
import sys,os,time,re,datetime,smtplib

#------PPI.py---------------------------
#
# This script uses the PPI "button" in SPM to first extract a timeseries from
# either faces or cards based on a user specified roi.  It takes in a matrix
# that represents the task specific connectivity that the user is interested in.
# It then moves into a single subject analysis, and uses the extracted values 
# (under PPI.P, PPI.ppi, and PPI.Y) as regressors.  Additionally, it uses the
# ART motion outliers from the subject's original BOLD preprocessing for the
# task of interest as an additional regressor.  Output goes into the user 
# specified folder name under Analysis/SPM/Analyzed/(Subject)
# 

#########user section#########################
#user specific constants
username = "vvs4"                               #your cluster login name (use what shows up in qstatall)
useremail = "vsochat@gmail.com"                 #email to send job notices to
template_f = file("PPI_TEMPLATE.sh")            #job template location (on head node)
experiment = "DNS.01"                           #experiment name for qsub
nodes = 400                                     #number of nodes on cluster
maintain_n_jobs = 100                           #leave one in q to keep them moving through
min_jobs = 5                                    #minimum number of jobs to keep in q even when crowded
n_fake_jobs = 50                                #during business hours, pretend there are extra jobs to try and leave a few spots open
sleep_time = 20                                 #pause time (sec) between job count checks
max_run_time = 720                              #maximum time any job is allowed to run in minutes
max_run_hours=24	                        #maximum number of hours submission script can run
warning_time=18                                 #send out a warning after this many hours informing you that the deamon is still running
                                                #make job files  these are the lists to be traversed
                                                #all iterated items must be in "[ ]" separated by commas.
#experiment variables 
#order1subnums141 = ["20100226_10405","20100128_10293","20100125_10274","20100208_10327","20100322_10555","20100208_10325","20100215_10345","20100225_10391","20100301_10408","20100507_10846","20100225_10393","20100503_10821","20100304_10434","20100226_10403","20100318_10530","20100305_10443","20100325_10573","20100322_10552","20100325_10574","20100408_10679","20100513_10871","20100401_10618","20100401_10621","20100402_10632","20100426_10772","20100430_10810","20100503_10822","20100510_10852","20100607_10986","20100528_10942","20100607_10982","20100614_11011","20100621_11055","20100917_11416","20100927_11460","20100930_11484","20100929_11474","20100426_10773"]
#order2subnums141 = ["20100125_10276","20100129_10298","20100211_10329","20100218_10369","20100409_10689","20100301_10409","20100218_10367","20100305_10445","20100225_10392","20100305_10447","20100322_10551","20100304_10433","20100415_10712","20100315_10503","20100325_10571","20100326_10584","20100426_10774","20100325_10569","20100329_10592","20100409_10691","20100401_10617","20100402_10631","20100405_10646","20100219_10378","20100429_10801","20100503_10819","20100524_10919","20100513_10874","20100624_11071","20100602_10960","20100614_11013","20100917_11417","20100930_11480","20100924_11450","20100930_11481"]
#order3subnums141 = ["20100129_10300","20100129_10299","20100219_10377","20100212_10337","20100215_10343","20100226_10401","20100225_10395","20100218_10370","20100409_10688","20100329_10593","20100319_10542","20100305_10444","20100319_10541","20100315_10504","20100318_10531","20100401_10622","20100416_10727","20100430_10808","20100405_10648","20100419_10737","20100415_10715","20100513_10875","20100329_10591","20100608_10989","20100416_10725","20100503_10820","20100601_10950","20100429_10798","20100615_11023","20100921_11432","20100917_11418"]
#order4subnums141 = ["20100215_10344","20100215_10342","20100219_10380","20100219_10376","20100215_10341","20100301_10410","20100226_10402","20100301_10411","20100513_10873","20100329_10595","20100315_10505","20100322_10553","20100419_10740","20100325_10572","20100329_10594","20100402_10630","20100419_10741","20100426_10775","20100409_10690","20100416_10724","20100215_10346","20100405_10650","20100602_10962","20100426_10776","20100430_10809","20100505_10839","20100513_10872","20100602_10959","20100618_11043","20100623_11063","20100923_11443","20100920_11428","20100924_11449","20100923_11440","20100928_11465","20100430_10811","20100319_10539"]
#order1subnums125 = ["20100226_10405","20100128_10293","20100125_10274","20100208_10327","20100322_10555","20100208_10325","20100215_10345","20100225_10391","20100301_10408","20100225_10393","20100503_10821","20100304_10434","20100226_10403","20100318_10530","20100305_10443","20100325_10573","20100322_10552","20100325_10574","20100408_10679","20100513_10871","20100401_10618","20100401_10621","20100402_10632","20100426_10772","20100430_10810","20100503_10822","20100510_10852","20100607_10986","20100528_10942","20100607_10982","20100614_11011","20100621_11055","20100426_10773"]
#order2subnums125 = ["20100125_10276","20100129_10298","20100211_10329","20100218_10369","20100409_10689","20100301_10409","20100218_10367","20100305_10445","20100225_10392","20100305_10447","20100322_10551","20100304_10433","20100415_10712","20100315_10503","20100325_10571","20100326_10584","20100426_10774","20100325_10569","20100329_10592","20100409_10691","20100401_10617","20100402_10631","20100405_10646","20100219_10378","20100429_10801","20100503_10819","20100524_10919","20100513_10874","20100624_11071","20100602_10960","20100614_11013"]
#order3subnums125 = ["20100129_10300","20100129_10299","20100219_10377","20100212_10337","20100215_10343","20100226_10401","20100225_10395","20100218_10370","20100409_10688","20100329_10593","20100319_10542","20100305_10444","20100319_10541","20100315_10504","20100318_10531","20100401_10622","20100416_10727","20100430_10808","20100405_10648","20100419_10737","20100415_10715","20100513_10875","20100329_10591","20100608_10989","20100416_10725","20100503_10820","20100601_10950","20100429_10798","20100615_11023"]
#order4subnums125 = ["20100215_10344","20100215_10342","20100219_10380","20100219_10376","20100215_10341","20100301_10410","20100226_10402","20100301_10411","20100513_10873","20100329_10595","20100315_10505","20100322_10553","20100419_10740","20100325_10572","20100329_10594","20100402_10630","20100419_10741","20100426_10775","20100409_10690","20100416_10724","20100215_10346","20100405_10650","20100602_10962","20100426_10776","20100430_10809","20100505_10839","20100513_10872","20100602_10959","20100618_11043","20100623_11063","20100923_11443","20100920_11428","20100924_11449","20100923_11440","20100928_11465","20100430_10811","20100319_10539"]
#allsubnums200 = ["20100226_10405","20100125_10276","20100129_10300","20100128_10293","20100215_10344","20100125_10274","20100129_10298","20100219_10377","20100208_10327","20100212_10337","20100322_10555","20100208_10325","20100211_10329","20100218_10369","20100215_10343","20100215_10345","20100225_10391","20100219_10380","20100409_10689","20100226_10401","20100219_10376","20100215_10341","20100301_10410","20100218_10367","20100225_10395","20100218_10370","20100409_10688","20100301_10408","20100329_10593","20100226_10402","20100301_10411","20100305_10445","20100507_10846","20100225_10393","20100319_10542","20100503_10821","20100304_10434","20100226_10403","20100305_10444","20100225_10392","20100319_10541","20100318_10530","20100513_10873","20100305_10447","20100322_10551","20100304_10433","20100305_10443","20100329_10595","20100415_10712","20100315_10503","20100315_10505","20100322_10553","20100419_10740","20100325_10572","20100315_10504","20100325_10573","20100318_10531","20100329_10594","20100325_10571","20100326_10584","20100426_10774","20100325_10569","20100329_10592","20100402_10630","20100322_10552","20100325_10574","20100409_10691","20100416_10727","20100408_10679","20100513_10871","20100430_10808","20100405_10648","20100419_10737","20100415_10715","20100401_10617","20100513_10875","20100329_10591","20100401_10618","20100402_10631","20100608_10989","20100419_10741","20100426_10775","20100405_10646","20100409_10690","20100416_10725","20100416_10724","20100401_10621","20100215_10346","20100219_10378","20100405_10650","20100402_10632","20100602_10962","20100503_10820","20100426_10772","20100429_10801","20100430_10810","20100426_10776","20100503_10822","20100430_10809","20100601_10950","20100503_10819","20100505_10839","20100429_10798","20100513_10872","20100615_11023","20100510_10852","20101001_11490","20100524_10919","20100513_10874","20100607_10986","20100528_10942","20100624_11071","20100602_10959","20101108_11761","20100607_10982","20100602_10960","20100614_11011","20100618_11043","20100623_11063","20100614_11013","20100621_11055","20100917_11416","20100927_11460","20100917_11417","20100921_11432","20101026_11663","20100917_11418","20100923_11443","20100930_11484","20100920_11428","20100930_11480","20100924_11450","20101006_11505","20100924_11449","20101008_11527","20101001_11491","20100923_11440","20101006_11506","20100928_11465","20100929_11474","20100930_11481","20101025_11645","20101007_11519","20101005_11502","20101007_11518","20101008_11529","20101008_11531","20101012_11554","20101103_11722","20101013_11565","20101019_11601","20101008_11530","20101014_11580","20101014_11576","20101022_11638","20101020_11616","20101028_11678","20101021_11626","20101020_11613","20101026_11662","20101029_11691","20101108_11767","20101029_11689","20100430_10811","20100319_10539","20100426_10773","20101027_11667","20101109_11771","20101027_11668","20101104_11736","20101104_11739","20101104_11737","20101029_11695","20101102_11717","20101122_11834","20101117_11813","20101109_11773","20101129_11866","20101118_11819","20101122_11837","20101110_11777","20101112_11789","20101117_11811","20101117_11810","20101119_11829","20101116_11807","20101203_11918","20101129_11861","20101214_11989","20101216_12012","20101215_12001","20110120_12158","20101214_11987","20101217_12018","20101215_12006","20110113_12119","20110119_12147","20110126_12179","20110126_12178","20110121_12167"]
#order1subnums200 = ["20100226_10405","20100128_10293","20100125_10274","20100208_10327","20100322_10555","20100208_10325","20100215_10345","20100225_10391","20100301_10408","20100507_10846","20100225_10393","20100503_10821","20100304_10434","20100226_10403","20100318_10530","20100305_10443","20100325_10573","20100322_10552","20100325_10574","20100408_10679","20100513_10871","20100401_10618","20100401_10621","20100402_10632","20100426_10772","20100430_10810","20100503_10822","20100607_10986","20100528_10942","20100607_10982","20100614_11011","20100621_11055","20100917_11416","20100927_11460","20101026_11663","20100930_11484","20101006_11506","20100929_11474","20101007_11518","20101012_11554","20101103_11722","20100426_10773","20101027_11667","20101104_11736","20101122_11834","20101118_11819","20101110_11777","20101129_11861","20110120_12158","20101214_11987","20110113_12119","20110126_12178"]
#order2subnums200 = ["20100125_10276","20100129_10298","20100211_10329","20100218_10369","20100409_10689","20100218_10367","20100305_10445","20100225_10392","20100305_10447","20100322_10551","20100304_10433","20100415_10712","20100315_10503","20100325_10571","20100326_10584","20100426_10774","20100325_10569","20100329_10592","20100409_10691","20100401_10617","20100402_10631","20100405_10646","20100219_10378","20100429_10801","20100503_10819","20100524_10919","20100513_10874","20100624_11071","20101108_11761","20100602_10960","20100614_11013","20100917_11417","20100930_11480","20100924_11450","20101006_11505","20101008_11527","20100930_11481","20101007_11519","20101014_11580","20101014_11576","20101022_11638","20101029_11691","20101109_11771","20101027_11668","20101104_11737","20101109_11773","20101129_11866","20101119_11829","20101214_11989","20101215_12006","20110121_12167"]
#order3subnums200 = ["20100129_10300","20100219_10377","20100212_10337","20100215_10343","20100226_10401","20100225_10395","20100218_10370","20100409_10688","20100329_10593","20100319_10542","20100305_10444","20100319_10541","20100315_10504","20100318_10531","20100416_10727","20100430_10808","20100405_10648","20100419_10737","20100415_10715","20100513_10875","20100329_10591","20100608_10989","20100416_10725","20100503_10820","20100601_10950","20100429_10798","20100615_11023","20100510_10852","20101001_11490","20100921_11432","20100917_11418","20101001_11491","20101005_11502","20101008_11529","20101008_11531","20101019_11601","20101020_11613","20101026_11662","20101104_11739","20101029_11695","20101122_11837","20101112_11789","20101117_11810","20101116_11807","20101203_11918","20101216_12012","20110126_12179"]
#order4subnums200 = ["20100215_10344","20100219_10380","20100219_10376","20100215_10341","20100301_10410","20100226_10402","20100301_10411","20100513_10873","20100329_10595","20100315_10505","20100322_10553","20100419_10740","20100325_10572","20100329_10594","20100402_10630","20100419_10741","20100426_10775","20100409_10690","20100416_10724","20100215_10346","20100405_10650","20100602_10962","20100426_10776","20100430_10809","20100505_10839","20100513_10872","20100602_10959","20100618_11043","20100623_11063","20100923_11443","20100920_11428","20100924_11449","20100923_11440","20100928_11465","20101025_11645","20101013_11565","20101008_11530","20101020_11616","20101028_11678","20101021_11626","20101108_11767","20101029_11689","20100430_10811","20100319_10539","20101102_11717","20101117_11813","20101117_11811","20101215_12001","20101217_12018","20110119_12147"]
subnums = ["20100928_11465"]

runs = [1]                     # [ run01 ] range cuts the last number off any single runs should still be in [ ] or can be runs=range(1,2)

# ppi general variables
task = "faces"                 # MUST be either "faces" or "cards" or "rest" SCRIPT ONLY WORKING WITH FACES CURRENTLY!
outputfolder="lAMY_cluster_200"    # This is the name that you would like for the output folder under "Analyzed/Subject/PPI"
                               # You should append the number of subjects used to create the group mask "rAMY_cluster_141"
                               # Since this folder will be in a higher directory called "PPI" - you don't need PPI in the name!
ordernumber ="1"               # This is the order number that will specify the matrix weights for each subject
			       # [ condition#   sess   weight; condition#  sess  weight ] with as many conditions needed
			       # SPM.mat Thresh Variables
connum = "1"                   # Number of the contrast from single subject SPM.mat that we want to extract values from
conname = "Faces_gr_Shapes"    # Name of contrast of interest (Faces_gr_Shapes)
threshdesc = "none"            # This is either "FWE" or "none"
thresh = "1"                   # Threshold we want to use when creating VOI (1)

voxextent = "0"                # Voxel extent threshold for when creating VOI
fcontrast = "37"               # Index of F-contrast number used to adjust data GUI default is 0
numsess = "1"                  # Choice for the number of the session (should it be 1?)

# Mask with another contrast?
maskwithother = "no"           # Do you want to mask with another contrast? (yes/no)
otherconnumber = "1"           # If yes to mask_with_other, the contrast #
otherconthresh = "1"           # If yes to mask_with_other, the contrast threshold
otherinclusive = "0"           # If yes to mask_with_other, the type of mask to do (0-inclusive, 1-exclusive)

# VOI Variables
voiname = "lAMY_cluster_200"   # Name that we want our resulting VOI to have (VOI_ is auto. prefixed)
                               # You should append the number of subjects used to create the group mask "rAMY_cluster_141"
voitype = "mask"               # The type of voi to make (box, sphere, or mask) Mask should
                               # be used if the user wants to do a cluster

# Sphere Variables             # ONLY USED IF voitype = "sphere"
spherecenterx ="22"            # Coordinate of center voxel of sphere
spherecentery ="-4"
spherecenterz ="20"
sphereradius = "5"             # Radius of sphere

# Cube Variables               # ONLY USED IF voitype = "box"
boxcenterx ="10"               # Coordinate of center voxel of box
boxcentery ="10"
boxcenterz ="10"
boxdimx = "2"                  # The dimensions of the box
boxdimy = "2"
boxdimz = "2"

# Mask Variables               # ONLY USED IF voitype = "mask"
maskthresh = ".5"              # Threshold for the mask to define the VOI
subincluded ="200s"            # The name of the subject-number-folder under ROI/PPI/Task/ with masks in it ("141s")
maskname ="lAMY_cluster.img"   # Tbe full name (including extension) of a mask to be used to define VOI
                               # Must be saved to ROI/PPI/Task_Name/#Subjects/
####!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!##########################################################################
 
def daemonize(stdin='/dev/null',stdout='/dev/null',stderr='/dev/null'):
	try:
		#try first fork
		pid=os.fork()
		if pid>0:
			sys.exit(0)
	except OSError, e:
		sys.stderr.write("for #1 failed: (%d) %s\n" % (e.errno,e.strerror))
		sys.exit(1)
	os.chdir("/")
	os.umask(0)
	os.setsid()
	try:
		#try second fork
		pid=os.fork()
		if pid>0:
			sys.exit(0)
	except OSError, e:
			sys.stderr.write("for #2 failed: (%d) %s\n" % (e.errno, e.strerror))
			sys.exit(1)
	for f in sys.stdout, sys.stderr: f.flush()
	si=file(stdin,'r')
	so=file(stdout,'a+')
	se=file(stderr,'a+',0)
	os.dup2(si.fileno(),sys.stdin.fileno())
	os.dup2(so.fileno(),sys.stdout.fileno())
	os.dup2(se.fileno(),sys.stderr.fileno())
	
 
 
start_dir = os.getcwd()
 
daemonize('/dev/null',os.path.join(start_dir,'daemon.log'),os.path.join(start_dir,'daemon.log'))
sys.stdout.close()
os.chdir(start_dir)
temp=time.localtime()
hour,minute,second=temp[3],temp[4],temp[5]
prev_hr=temp[3]
t0=str(hour)+':'+str(minute)+':'+str(second)
log_name=os.path.join(start_dir,'daemon.log')
log=file(log_name,'w')
log.write('Daemon started at %s with pid %d\n' %(t0,os.getpid()))
log.write('To kill this process type "kill %s" at the head node command line\n' % os.getpid())
log.close()
t0=time.time()
master_clock=0
 
#build allowed timedelta
kill_time_limit = datetime.timedelta(minutes=max_run_time)
 
 
def _check_jobs(username, kill_time_limit, n_fake_jobs):
#careful, looks like all vars are global
#see how many jobs we have  in
 
	#set number of jobs to maintain based on time of day.
	cur_time = datetime.datetime.now() #get current time  #time.localtime()  #get current time
	if (cur_time.weekday > 4) | (cur_time.hour < 8) | (cur_time.hour > 17):
		n_other_jobs = 0
	else: #its a weekday, fake an extra 6 jobs to leave 5 nodes open
		n_other_jobs = n_fake_jobs
 
	n_jobs = 0
	
	status = os.popen("qstat  -u '*'")
	status_list = status.readlines()
 
	for line in status_list:
		#are these active or q'd jobs?
		if (line.find(" r ") > -1):
			running = 1
		elif (line.find(" qw ") > -1):   #all following jobs are in queue not running
			running = 0
 
		#if job is mine
		if (line.find(username) > 0) & (line.find("interact.q") < 0):   #name is in the line, not including first spot
			n_jobs = n_jobs + 1
			if running == 1:   #if active job, check how long its been running and delete it if too long
				job_info = line.split()  #get job information
				start_date = job_info[5].split("/")  #split job start date
				start_time = job_info[6].split(":")  #split time from hours:minutes:seconds format
				started = datetime.datetime(int(start_date[2]), int(start_date[0]), int(start_date[1]),
							int(start_time[0]), int(start_time[1]), int(start_time[2]))
				if ((cur_time - started) > kill_time_limit) & (line.find("stalled") == -1):   #if the active job is over max run time, delete it
					os.system("qdel %s" % (job_info[0]))   #delete the run away job
					print("Job %s was deleted because it ran for more than the maximum time." % (job_info[0]))
 
		# if line starts " ###" and isnt an interactive job
		elif bool(re.match( "^\d+", line )) & (line.find("interact") < 0) & (line.find("(Error)") < 0):
			n_other_jobs = n_other_jobs + 1
	return n_jobs, n_other_jobs
		
#make a directory to write job files to and store the start directory
tmp_dir = str(os.getpid())
os.mkdir(tmp_dir)
 
#read in template
template = template_f.read()
template_f.close()
os.chdir(tmp_dir)
 
#for each subject
for subnum in subnums:
	#for each run
	for run in runs:
		
		#Check for changes in user settings
		user_settings=("/home/%s/user_settings.txt") % (username)
		if os.path.isfile(user_settings):
			f=file(user_settings)
			settings=f.readlines()
			f.close()
			for line in settings:
				exec(line)
 
		#define substitutions, make them in template 
		runstr = "%05d" %(run)  
		tmp_job_file = template.replace( "SUB_USEREMAIL_SUB", useremail )
		tmp_job_file = tmp_job_file.replace( "SUB_SUBNUM_SUB", str(subnum) )
		tmp_job_file = tmp_job_file.replace( "SUB_RUNNUM_SUB", str(run) )
		tmp_job_file = tmp_job_file.replace( "SUB_ATASK_SUB", str(task) )
		tmp_job_file = tmp_job_file.replace( "SUB_MAT_SUB", str(ordernumber) )
		tmp_job_file = tmp_job_file.replace( "SUB_NAMEOFVOI_SUB", str(voiname) )
		tmp_job_file = tmp_job_file.replace( "SUB_OUTPUTFOL_SUB", str(outputfolder) )
		tmp_job_file = tmp_job_file.replace( "SUB_CONNUM_SUB", str(connum) )
		tmp_job_file = tmp_job_file.replace( "SUB_CONNAME_SUB", str(conname) )
		tmp_job_file = tmp_job_file.replace( "SUB_THRESH_SUB", str(thresh) )
		tmp_job_file = tmp_job_file.replace( "SUB_DESCOFTHRESH_SUB", str(threshdesc) )
		tmp_job_file = tmp_job_file.replace( "SUB_VOXEXT_SUB", str(voxextent) )
		tmp_job_file = tmp_job_file.replace( "SUB_DATAADJUST_SUB", str(fcontrast) )
		tmp_job_file = tmp_job_file.replace( "SUB_NUMSESS_SUB", str(numsess) )
		tmp_job_file = tmp_job_file.replace( "SUB_OTHERMASK_SUB", str(maskwithother) )
		tmp_job_file = tmp_job_file.replace( "SUB_OTHERMASKTHRESH_SUB", str(otherconthresh) )
		tmp_job_file = tmp_job_file.replace( "SUB_OTHERMASKCON_SUB", str(otherconnumber) )
		tmp_job_file = tmp_job_file.replace( "SUB_OTHERMASKINCLUSIVE_SUB", str(otherinclusive) )
		tmp_job_file = tmp_job_file.replace( "SUB_VMASKTYPE_SUB", str(voitype) )
		tmp_job_file = tmp_job_file.replace( "SUB_CENTERSPHEREX_SUB", str(spherecenterx) )
		tmp_job_file = tmp_job_file.replace( "SUB_CENTERSPHEREY_SUB", str(spherecentery) )
		tmp_job_file = tmp_job_file.replace( "SUB_CENTERSPHEREZ_SUB", str(spherecenterz) )
		tmp_job_file = tmp_job_file.replace( "SUB_RADIUSSPHERE_SUB", str(sphereradius) )
		tmp_job_file = tmp_job_file.replace( "SUB_CENTERBOXX_SUB", str(boxcenterx) )
                tmp_job_file = tmp_job_file.replace( "SUB_CENTERBOXY_SUB", str(boxcentery) )
		tmp_job_file = tmp_job_file.replace( "SUB_CENTERBOXZ_SUB", str(boxcenterz) )
		tmp_job_file = tmp_job_file.replace( "SUB_DIMBOXX_SUB", str(boxdimx) )
		tmp_job_file = tmp_job_file.replace( "SUB_DIMBOXY_SUB", str(boxdimy) )
		tmp_job_file = tmp_job_file.replace( "SUB_DIMBOXZ_SUB", str(boxdimz) )
		tmp_job_file = tmp_job_file.replace( "SUB_SUBINCLUDED_SUB", str(subincluded) )
		tmp_job_file = tmp_job_file.replace( "SUB_THEMASKVOI_SUB", str(maskname) )
		tmp_job_file = tmp_job_file.replace( "SUB_MASKVOITHRESH_SUB", str(maskthresh) )
		
		#make fname and write job file to cwd
		tmp_job_fname = "_".join( ["PPI", subnum, runstr ] )
		tmp_job_fname = ".".join( [ tmp_job_fname, "job" ] )
		tmp_job_f = file( tmp_job_fname, "w" )
		tmp_job_f.write(tmp_job_file)
		tmp_job_f.close()
 
 
		#wait to submit the job until we have fewer than maintain in q
		n_jobs = maintain_n_jobs
		while n_jobs >= maintain_n_jobs: 
 
			#count jobs
			n_jobs, n_other_jobs = _check_jobs(username, kill_time_limit, n_fake_jobs)   #count jobs, delete jobs that are too old
 
			#adjust job submission by how may jobs are submitted
			#set to minimum number if all nodes are occupied
			#should still try to leave # open on weekdays
			if ((n_other_jobs+ n_jobs) > (nodes+1)): 
				n_jobs = maintain_n_jobs  - (min_jobs - n_jobs)
 
			if n_jobs >= maintain_n_jobs: 
				time.sleep(sleep_time)
			elif n_jobs < maintain_n_jobs:
				cmd = "qsub -v EXPERIMENT=%s %s"  % ( experiment, tmp_job_fname )
				dummy, f = os.popen2(cmd)
				time.sleep(sleep_time)
 
	#Check what how long daemon has been running
	t1=time.time()
	hour=(t1-t0)/3600
	log=file(log_name,'a+')
	log.write('Daemon has been running for %s hours\n' % hour)
	log.close()
	now_hr=time.localtime()[3]
	if now_hr>prev_hr:
		master_clock=master_clock+1
	prev_hr=now_hr
	serverURL="email.biac.duke.edu"
	if master_clock==warning_time:
		headers="From: %s\r\nTo: %s\r\nSubject: Daemon job still running!\r\n\r\n" % (useremail,useremail)
		text="""Your daemon job has been running for %d hours.  It will be killed after %d.
		To kill it now, log onto the head node and type kill %d""" % (warning_time,max_run_hours,os.getpid())
		message=headers+text
		mailServer=smtplib.SMTP(serverURL)
		mailServer.sendmail(useremail,useremail,message)
		mailServer.quit()
	elif master_clock==max_run_hours:
		headers="From: %s\r\nTo: %s\r\nSubject: Daemon job killed!\r\n\r\n" % (useremail,useremail)
		text="Your daemon job has been killed.  It has run for the maximum time alotted"
		message=headers+text
		mailServer=smtplib.SMTP(serverURL)
		mailServer.sendmail(useremail,useremail,message)
		mailServer.quit()
		ID=os.getpid()
		os.system('kill '+str(ID))
 
 
 
#wait for jobs to complete
#delete them if they run too long
n_jobs = 1
while n_jobs > 0:
	n_jobs, n_other_jobs = _check_jobs(username, kill_time_limit, n_fake_jobs)
	time.sleep(sleep_time)
 
 
#remove tmp job files move to start dir and delete tmpdir
#terminated jobs will prevent this from executing
#you will then have to clean up a "#####" directory with
# ".job" files written in it.
cmd = "rm *.job"
os.system(cmd)
os.chdir(start_dir)
os.rmdir(tmp_dir)
