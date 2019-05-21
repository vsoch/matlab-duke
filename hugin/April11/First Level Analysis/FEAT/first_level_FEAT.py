#!/usr/bin/env python
import sys,os,time,re,datetime,smtplib

#------first_level_FEAT.py---------------------------
#
# This script is used for first_level_FEAT job submission with python
#

#########user section#########################
#user specific constants
username = "vvs4"             #your cluster login name (use what shows up in qstatall)
useremail = "vsochat@gmail.com"    #email to send job notices to
template_f = file("first_level_FEAT_TEMPLATE.sh")  #job template location (on head node)
experiment = "AHABII.01"    #experiment name for qsub
nodes = 24                   #number of nodes on cluster
maintain_n_jobs = 25         #leave one in q to keep them moving through
min_jobs = 5                 #minimum number of jobs to keep in q even when crowded
n_fake_jobs = 10               #during business hours, pretend there are extra jobs to try and leave a few spots open
sleep_time = 20              #pause time (sec) between job count checks
max_run_time = 720           #maximum time any job is allowed to run in minutes
max_run_hours=24	#maximum number of hours submission script can run
warning_time=18         #send out a warning after this many hours informing you that the deamon is still running
#make job files  these are the lists to be traversed
#all iterated items must be in "[ ]" separated by commas.  
subnums = ["34570_scandata","35829_scandata","36514_scandata","36789_scandata","37027_scandata","37519_scandata","38718_scandata","39433_scandata","39926_scandata","42917_scandata","43161_scandata","43379_scandata","44275_scandata","47600_scandata","48484_scandata","49342_scandata","49529_scandata","50127_scandata","52388_scandata","54895_scandata","54922_scandata","57063_scandata","57255_scandata","58513_scandata","59301_scandata","59509_scandata","33031_scandata","33405_scandata","40409_scandata","44116_scandata","45634_scandata","57037_scandata","35661_scandata","47341_scandata","33760_scandata","38677_scandata","44266_scandata","30435_scandata","30634_scandata","30966_scandata","31684_scandata","31754_scandata","31881_scandata","32366_scandata","32794_scandata","32802_scandata","32950_scandata","33047_scandata","33054_scandata","33218_scandata","33597_scandata","36998_scandata","37795_scandata","38058_scandata","38694_scandata","39223_scandata","40423_scandata","40822_scandata","40897_scandata","40948_scandata","41246_scandata","41673_scandata","41940_scandata","42069_scandata","42447_scandata","42470_scandata","43959_scandata","44179_scandata","44448_scandata","44755_scandata","44963_scandata","45370_scandata","45900_scandata","46003_scandata","46246_scandata","46492_scandata","46507_scandata","46531_scandata","46825_scandata","47019_scandata","47363_scandata","47402_scandata","47658_scandata","48386_scandata","48406_scandata","48508_scandata","49131_scandata","49544_scandata","50567_scandata","51180_scandata","51361_scandata","52145_scandata","52614_scandata","53006_scandata","54154_scandata","54642_scandata","54742_scandata","55064_scandata","55435_scandata","56153_scandata","56160_scandata","56218_scandata","56250_scandata","56515_scandata","57677_scandata","58112_scandata","58920_scandata","59751_scandata","59946_scandata","55674_scandata","30407_scandata","30487_scandata","31002_scandata","31014_scandata","31663_scandata","32080_scandata","32473_scandata","32543_scandata","33004_scandata","33881_scandata","34394_scandata","34506_scandata","34987_scandata","35106_scandata","35115_scandata","35822_scandata","35851_scandata","35864_scandata","36240_scandata","36354_scandata","36524_scandata","36729_scandata","36900_scandata","38081_scandata","38687_scandata","39277_scandata","39375_scandata","40054_scandata","40571_scandata","40661_scandata","41102_scandata","41361_scandata","41762_scandata","42086_scandata","43039_scandata","43470_scandata","43767_scandata","44665_scandata","45666_scandata","46153_scandata","46181_scandata","46198_scandata","46281_scandata","47103_scandata","47169_scandata","48143_scandata","48213_scandata","48337_scandata","49124_scandata","49229_scandata","49310_scandata","49438_scandata","49476_scandata","49992_scandata","50403_scandata","50946_scandata","51091_scandata","51377_scandata","51707_scandata","51726_scandata","51754_scandata","52307_scandata","52327_scandata","52655_scandata","52803_scandata","52897_scandata","53065_scandata","53217_scandata","53782_scandata","53797_scandata","54233_scandata","54628_scandata","55874_scandata","57147_scandata","57221_scandata","57266_scandata","57506_scandata","57536_scandata","57994_scandata","58056_scandata","31592_scandata","35577_scandata","36746_scandata","46822_scandata","52117_scandata","36228_scandata","46042_scandata","30337_scandata"] #should be entered in quotes, separated by commas, to be used as strings
runs = [1] #[ run01 ] range cuts the last number off any single runs should still be in [ ] or can be runs=range(1,2)
runname = "run01" #the name of the .feat output
anatdir = "inplanes_t2_256x256.6" #the folder name that contains the anatomical data
funcdir = "faces_34sli_384x384*" #the foler name that contains the functional data
designvar = "NEWFACES" #the name of the experiment design (for FIGS, 4Block, 4BlockMixed, Individual, etc)
designtype = "Event" #the name of the design type under NEWFACES
####!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
###############################################
 
 
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
	status = os.popen("status -a")
	status_list = status.readlines()
 
	for line in status_list:
		#are these active or q'd jobs?
		if (line.find("Running") > -1):
			running = 1
		elif (line.find("Waiting") > -1):   #all following jobs are in queue not running
			running = 0
 
		#if job is mine
		if (line.find(username) > 0) & (line.find("interact.q") < 0):   #name is in the line, not including first spot
			n_jobs = n_jobs + 1
			if running == 1:   #if active job, check how long its been running and delete it if too long
				job_info = line.split()  #get job information
				start_date = job_info[4].split("/")  #split job start date
				start_time = job_info[5].split(":")  #split time from hours:minutes:seconds format
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
 		tmp_job_file = tmp_job_file.replace( "SUB_RUNNAME_SUB", str(runname) )
		tmp_job_file = tmp_job_file.replace( "SUB_ANATDIR_SUB", str(anatdir) )
 		tmp_job_file = tmp_job_file.replace( "SUB_FUNCDIR_SUB", str(funcdir) )
 		tmp_job_file = tmp_job_file.replace( "SUB_DESIGNVAR_SUB", str(designvar) )
		tmp_job_file = tmp_job_file.replace( "SUB_DESIGNTYPE_SUB", str(designtype) )
 
		#make fname and write job file to cwd
		tmp_job_fname = "_".join( ["FEAT", subnum, runstr ] )
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
 
