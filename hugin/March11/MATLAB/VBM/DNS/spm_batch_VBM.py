#!/usr/bin/env python
import sys,os,time,re,datetime,smtplib

#------SPM_BATCH.py---------------------------
#
# This script is used for preprocessing of anatomical and functional data
# in SPM.  It runs single subject analysis, checks registration, performs
# Artifact Detection (Art), and then a second analysis with Art Outliers.
# 

#########user section#########################
#user specific constants
username = "vvs4"                               #your cluster login name (use what shows up in qstatall)
useremail = "vsochat@gmail.com"                 #email to send job notices to
template_f = file("spm_batch_VBM.sh")      #job template location (on head node)
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
subnums = ["20100125_10274","20100125_10276","20100128_10293","20100129_10298","20100129_10300","20100208_10325","20100208_10327","20100212_10337","20100215_10341","20100215_10343","20100215_10344","20100215_10345","20100215_10346","20100219_10378","20100219_10380","20100225_10391","20100225_10392","20100225_10393","20100225_10395","20100226_10401","20100226_10402","20100226_10403","20100226_10405","20100301_10408","20100301_10410","20100301_10411","20100304_10433","20100304_10434","20100305_10443","20100305_10444","20100305_10445","20100305_10447","20100315_10503","20100315_10504","20100315_10505","20100318_10530","20100318_10531","20100319_10539","20100319_10541","20100319_10542","20100322_10551","20100322_10552","20100322_10553","20100322_10555","20100325_10569","20100325_10571","20100325_10572","20100325_10573","20100325_10574","20100326_10584","20100329_10591","20100329_10592","20100329_10593","20100329_10594","20100329_10595","20100401_10617","20100401_10618","20100401_10619","20100401_10621","20100401_10622","20100402_10630","20100402_10631","20100402_10632","20100405_10646","20100405_10648","20100405_10650","20100409_10688","20100409_10690","20100409_10691","20100415_10712","20100415_10715","20100416_10724","20100416_10725","20100419_10737","20100419_10740","20100419_10741","20100426_10772","20100426_10773","20100426_10774","20100426_10775","20100426_10776","20100429_10798","20100429_10801","20100430_10808","20100430_10809","20100430_10810","20100430_10811","20100503_10819","20100503_10820","20100503_10821","20100503_10822","20100505_10839","20100507_10846","20100510_10852","20100513_10871","20100513_10872","20100513_10873","20100513_10874","20100513_10875","20100524_10919","20100601_10950","20100602_10959","20100602_10960","20100602_10962","20100607_10982","20100607_10986","20100608_10989","20100614_11011","20100614_11013","20100615_11023","20100618_11043","20100621_11055","20100623_11063","20100917_11417","20100917_11418","20100920_11428","20100921_11432","20100923_11440","20100923_11443","20100924_11449","20100924_11450","20100927_11460","20100928_11465","20100929_11474","20100930_11480","20100930_11481","20100930_11484","20101001_11490","20101001_11491","20101005_11502","20101006_11505","20101006_11506","20101007_11518","20101007_11519","20101007_11521","20101008_11527","20101008_11529","20101008_11530","20101008_11531","20101012_11554","20101013_11565","20101014_11576","20101014_11580"]
#subnumsuppercase = ["20100218_10367","20100218_10369","20100218_10370","20100219_10376","20100219_10377","20100211_10329","20100408_10679","20100416_10727","20100528_10942","20100624_11071","20100917_11416"]
runs = [1]                                      #[ run01 ] range cuts the last number off any single runs should still be in [ ] or can be runs=range(1,2)
anatfolder = "anat"                             # This is the name of the anatomical folder in the single subject directory
gmmodulation = "1"                              # This is the grey matter modulation: 1: affine&nonlinear (SPM default), 2: non-linear only
                                                # If gmmodulation = 1, output folder will be "SPM_Default_Modulation" 
                                                # If gmmodulation = 2, output folder will be "SPGR" 
anatfilename = "sdns01-0005-00001-000001-01"    # Write the FULL name of the highres image, WITHOUT the extension

####!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!###############################################
 
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
		tmp_job_file = tmp_job_file.replace( "SUB_ANATFOL_SUB", str(anatfolder) )
		tmp_job_file = tmp_job_file.replace( "SUB_ANATNAME_SUB", str(anatfilename) )
		tmp_job_file = tmp_job_file.replace( "SUB_MODULATIONGM_SUB", str(gmmodulation) )
 		tmp_job_file = tmp_job_file.replace( "SUB_RUNNUM_SUB", str(run) )
		
		#make fname and write job file to cwd
		tmp_job_fname = "_".join( ["SPM_VBM", subnum, runstr ] )
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
