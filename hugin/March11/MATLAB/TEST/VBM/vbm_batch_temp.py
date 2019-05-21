#!/usr/bin/env python
import sys,os,time,re,datetime,smtplib

#------VBM_BATCH.py---------------------------
#
# 

#########user section#########################
#user specific constants
username = "vvs4"                               #your cluster login name (use what shows up in qstatall)
useremail = "vsochat@gmail.com"                 #email to send job notices to
#template_f = file("spm_anat_batch_TEMPLATE.sh")      #job template location (on head node)
job_fname = "vbm_batch_temp.sh"			# to be executed shell script
experiment = "DARPA.01"                           #experiment name for qsub
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
#subnums = ["test"]
#subnums = ["1043","1062","1104","1112","1119","1122","1123","1126","1140","1189","1195"]
#subnums = ["1001","1002","1003","1004","1005","1006","1007","1009","1010","1011","1012","1014","1016","1018","1019","1020","1021","1022","1023","1024","1025","1026","1027","1028","1029","1030","1032","1033","1034","1035","1036","1037","1038","1039","1040","1041","1042","1043","1045","1046","1047","1048","1049","1050","1051","1053","1054","1056","1059","1061","1062","1064","1065","1066","1067","1068","1071","1072","1073","1074","1075","1078","1079","1083","1084","1085","1088","1089","1091","1090","1093","1095","1096","1099","1100","1101","1102","1103","1104","1105","1107","1108","1110","1111","1112","1113","1114","1116","1117","1118","1119","1120","1121","1122","1123","1126","1127","1128","1129","1130","1131","1132","1133","1134","1135","1138","1139","1140","1141","1143","1144","1147","1148","1149","1150","1151","1153","1154","1155","1156","1158","1159","1160","1165","1166","1167","1168","1169","1171","1172","1173","1174","1175","1176","1177","1178","1179","1182","1183","1185","1186","1188","1187","1189","1190","1191","1192","1193","1195"]
#subnums = ["test"] #should be entered in quotes, separated by commas, to be used as strings
runs = [1]               #[ run01 ] range cuts the last number off any single runs should still be in [ ] or can be runs=range(1,2)

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
 
##for each subject
#for subnum in subnums:
#	#for each run
#	for run in runs:
		
#	 

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
		cmd = "qsub -v EXPERIMENT=%s %s"  % ( experiment, job_fname )
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
#cmd = "rm *.job"
#os.system(cmd)
#os.chdir(start_dir)
#os.rmdir(tmp_dir)
