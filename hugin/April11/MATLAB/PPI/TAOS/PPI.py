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
experiment = "TAOS.01"                           #experiment name for qsub
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
#subnums = ["178","EI0008"]
subnums = ["191","201","202","204","211","214","218","225","227","234","237","242","246","247","250","270","277","281","291","296","302","305","306","307","314","323","324","330","331","332","344","350","357","363","364","365","367","370","375","376","380","383","387","389","398","399","400","401","411","416","425","426","431","432","433","443","452","453","454","455","456","457","458","459","460","461","EI0010","EI0015","EI0018","EI0022","EI0023","EI0026","EI0030","EI0031","EI0034","EI0037","EI0040","EI0041","EI0045","EI0046","EI0051","EI0058","EI0061","EI0068","EI0069","EI0073","EI0074","EI0076","EI0078","EI0079","EI0083","EI0085","EI0086","EI0087","EI0090","EI0097","EI0102","EI0105","EI0110","EI0113","EI0114","EI0117","EI0118","EI0123","EI0124","EI0125","EI0129","EI0130","EI0139","EI0145","EI0149","EI0150","EI0156","EI0157","EI0160","EI0163","EI0168","EI0169","EI0175","EI0182","EI0183","EI0187","EI0188","EI0189","EI0194","EI0195","EI0200","EI0202","EI0203","EI0206","EI0207","EI0212","EI0214","EI0215","EI0216","EI0217","EI0221","EI0225","EI0226","EI0227","EI0228","EI0230","EI0231","EI0232","EI0234","EI0236","EI0238","EI0239","EI0240","EI0250","EI0251","EI0253","EI0254","EI0260","EI0261","EI0262","EI0265","EI0266","EI0270","EI0271","EI0281","EI0283","EI0287","EI0291","EI0293","EI0295","EI0297","EI0302","EI0303","EI0304","EI0305","EI0308","EI0309","EI0311","EI0314","EI0315","EI0316","EI0319","EI0320","EI0322","EI0323","EI0326","EI0327","EI0328","EI0332","EI0334","EI0335","EI0338","EI0341","EI0353","EI0354","EI0356","EI0358","EI0359","EI0360","EI0361","EI0363","EI0366","EI0368","EI0370","EI0373","EI0374","EI0375","EI0376","EI0381","EI0382","EI0383","EI0387","EI0388","EI0389","EI0392","EI0393","EI0395","EI0396","EI0397","EI0399","EI0400","EI0402","EI0403","EI0404","Ei0406","EI0408","EI0410","EI0413","EI0415","EI0418","EI0419","EI0421","EI0427","EI0428","EI0429","EI0431","EI0435","EI0436","EI0438","EI0440","EI0441","EI0443","EI0444","EI0447","EI0448","EI0454","EI0455","EI0457","EI0460","EI0461","EI0463","EI0464","EI0468","EI0475","EI0476","EI0482","EI0485","EI0491","EI0494","EI0495","EI0497","EI0500","EI0501","EI0502","EI0503","EI0507","EI0508","EI0512","EI0513","EI0516","EI0517","EI0522","EI0523","EI0524","EI0529","EI0530","EI0531","EI0535","EI0536","EI0537","EI0539","EI0540","EI0541","EI0543","EI0547","EI0548","EI0551","EI0552","EI0553","EI0554","EI0558","EI0559","EI0562","EI0563","EI0564","EI0566","EI0567","EI0568","EI0572","EI0573","EI0574","EI0577","EI0588","EI0590"]
#subnums = ["191"]
runs = [1]                     # [ run01 ] range cuts the last number off any single runs should still be in [ ] or can be runs=range(1,2)

# ppi general variables
task = "faces"                 # MUST be either "faces" or "cards" or "rest" SCRIPT ONLY WORKING WITH FACES CURRENTLY!
outputfolder="lAMY_cluster_ventral"    # This is the name that you would like for the output folder under "Analyzed/Subject/PPI"
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
fcontrast = "8"               # Index of F-contrast number used to adjust data GUI default is 0
numsess = "1"                  # Choice for the number of the session (should it be 1?)

# Mask with another contrast?
maskwithother = "no"           # Do you want to mask with another contrast? (yes/no)
otherconnumber = "1"           # If yes to mask_with_other, the contrast #
otherconthresh = "1"           # If yes to mask_with_other, the contrast threshold
otherinclusive = "0"           # If yes to mask_with_other, the type of mask to do (0-inclusive, 1-exclusive)

# VOI Variables
voiname = "lAMY_cluster_ventral"   # Name that we want our resulting VOI to have (VOI_ is auto. prefixed)
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
subincluded ="all"            # The name of the subject-number-folder under ROI/PPI/Task/ with masks in it ("141s")
maskname ="LAMY_ven_fwe05_mask.img"   # Tbe full name (including extension) of a mask to be used to define VOI
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
