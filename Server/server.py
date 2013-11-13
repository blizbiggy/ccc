"""
Camera Server
"""
import serial, time, socket, datetime
print 'Server Started, Awaiting Connection!'
global ser
global speedVal
global camConStat
camConStat = 1
speedVal = 3

def COMportScan():
	"""scans for available COM ports."""
	global availableCOMports
	availableCOMports = []
	for i in range(256):
		try:
			COMport = serial.Serial(i, baudrate=9600, stopbits=1, rtscts=True, dsrdtr=0, timeout=0.1)
			availableCOMports.append(COMport.portstr)
			COMport.close()
		except serial.SerialException:
			pass
	print 'Listing Camera COM Ports:'
	value = 0
	try:
		while len(availableCOMports) > value:
			print availableCOMports[value]
			print ''
			value = value+1
	except ValueError:
		pass

def hostReturn():
	time.sleep(0.1)
	ser.write("\xFF\x30\x31\x00\x90\x31\xEF") #Return to remote control
	reading()

def reading():
	reading = ser.readline()

def hostPull():
	ser.write("\xFF\x30\x31\x00\x90\x30\xEF")
	reading()
	time.sleep(0.1)

def moveWaitStop():
	global speedVal
	if speedVal is 1:
		speedVal1()
	elif speedVal is 2:
		speedVal2()
	elif speedVal is 3:
		speedVal3()
	elif speedVal is 4:
		speedVal4()
	elif speedVal is 5:
		speedVal5()
	else:
		speedVal3()
	ser.write("\xFF\x30\x31\x00\x53\x30\xEF") #Stop command
	reading()
	time.sleep(0.1)
	hostReturn()
	
def speedVal1():
	time.sleep(0.1)

def speedVal2():
	time.sleep(0.2)
	
def speedVal3():
	time.sleep(0.25)
	
def speedVal4():
	time.sleep(0.3)

def speedVal5():
	time.sleep(0.4)

def zoomWaitStop():
	time.sleep(0.5)
	ser.write("\xFF\x30\x31\x00\xA2\x30\xEF") #Stop command
	reading()
	time.sleep(0.1)
	hostReturn()

def initialize():
	global camConStat
	ser.flushInput()
	ser.flushOutput()		
	try:
		ser.write("\xFF\x30\x30\x00\x8F\x30\xEF")
		reading()
		ser.write("\xFF\x30\x30\x00\x8F\x31\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\x94\x31\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xA0\x31\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xB4\x31\x32\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\x88\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\x86\x30\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xA1\x30\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xA5\x3C\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xA7\x35\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xA5\x38\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xA5\x36\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xA5\x3A\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\x86\x30\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\xA4\xEF")
		reading()
		ser.write("\xFF\x30\x31\x00\x90\x30\xEF")
		reading()
		time.sleep(0.1)
		speed3()
	except ser.SerialException:
		camConStat = 1

def panLeft():
	hostPull()
	print("Command Received Pan Left")
	ser.write("\xFF\x30\x31\x00\x53\x32\xEF")
	moveWaitStop()

def panRight():
	hostPull()
	print("Command Received Pan Right")
	ser.write("\xFF\x30\x31\x00\x53\x31\xEF")
	moveWaitStop()

def tiltUp():
	hostPull()
	print("Command Received Tilt Up")
	ser.write("\xFF\x30\x31\x00\x53\x33\xEF")
	moveWaitStop()

def tiltDown():
	hostPull()
	print("Command Received Tilt Down")
	ser.write("\xFF\x30\x31\x00\x53\x34\xEF")
	moveWaitStop()

def home():
	speed5()
	hostPull()
	print("Command Received Home")
	ser.write("\xFF\x30\x31\x00\x57\xEF")
	time.sleep(2.5)
	hostReturn()
	speed3()

def camOn():
	hostPull()
	print("Command Received Camera On")	
	ser.write("\xff\x30\x31\x00\xA0\x31\xEF")
	hostReturn()

def camOff():
	hostPull()
	print("Command Received Camera Off")	
	ser.write("\xff\x30\x31\x00\xA0\x30\xEF")
	hostReturn()

def zoomWide():
	hostPull()
	print("Command Received Zoom Wide")
	ser.write("\xff\x30\x31\x00\xA2\x31\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\xb4\x31\x32\xef")
	reading()
	zoomWaitStop()

def zoomTele():
	hostPull()
	print("Command Received Zoom Tele")
	ser.write("\xff\x30\x31\x00\xA2\x32\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\xb4\x31\x32\xef")
	reading()
	zoomWaitStop()

def set1():
	hostPull()
	print("Command Received Set 1")
	ser.write("\xff\x30\x31\x00\x89\x31\xEF")
	hostReturn()

def set2():
	hostPull()
	print("Command Received Set 2")
	ser.write("\xff\x30\x31\x00\x89\x32\xEF")
	hostReturn()

def set3():
	hostPull()
	print("Command Received Set 3")
	ser.write("\xff\x30\x31\x00\x89\x33\xEF")
	hostReturn()

def set4():
	hostPull()
	print("Command Received Set 4")
	ser.write("\xff\x30\x31\x00\x89\x34\xEF")
	hostReturn()

def set5():
	hostPull()
	print("Command Received Set 5")
	ser.write("\xff\x30\x31\x00\x89\x35\xEF")
	hostReturn()

def set6():
	hostPull()
	print("Command Received Set 6")
	ser.write("\xff\x30\x31\x00\x89\x36\xEF")
	hostReturn()

def set7():
	hostPull()
	print("Command Received Set 7")
	ser.write("\xff\x30\x31\x00\x89\x37\xEF")
	hostReturn()

def set8():
	hostPull()
	print("Command Received Set 8")
	ser.write("\xff\x30\x31\x00\x89\x38\xEF")
	hostReturn()

def set9():
	hostPull()
	print("Command Received Set 9")
	ser.write("\xff\x30\x31\x00\x89\x39\xEF")
	hostReturn()

def move1():
	speed5()
	hostPull()
	print("Command Received Move 1")
	ser.write("\xff\x30\x31\x00\x8a\x31\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x30\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def move2():
	speed5()
	hostPull()
	print("Command Received Move 2")	
	ser.write("\xff\x30\x31\x00\x8a\x32\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x31\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def move3():
	speed5()
	hostPull()
	print("Command Received Move 3")	
	ser.write("\xff\x30\x31\x00\x8a\x33\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x32\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def move4():
	speed5()
	hostPull()
	print("Command Received Move 4")	
	ser.write("\xff\x30\x31\x00\x8a\x34\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x33\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def move5():
	speed5()
	hostPull()
	print("Command Received Move 5")	
	ser.write("\xff\x30\x31\x00\x8a\x35\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x34\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def move6():
	speed5()
	hostPull()
	print("Command Received Move 6")	
	ser.write("\xff\x30\x31\x00\x8a\x36\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x35\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def move7():
	speed5()
	hostPull()
	print("Command Received Move 7")	
	ser.write("\xff\x30\x31\x00\x8a\x37\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x36\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def move8():
	speed5()
	hostPull()
	print("Command Received Move 8")	
	ser.write("\xff\x30\x31\x00\x8a\x38\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x37\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def move9():
	speed5()
	hostPull()
	print("Command Received Move 9")	
	ser.write("\xff\x30\x31\x00\x8a\x39\xEF")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\xef")
	reading()
	ser.write("\xff\x30\x31\x00\x8b\x38\xef")
	reading()
	time.sleep(2.5)
	hostReturn()
	speed3()

def focusAuto():
	hostPull()
	print("Command Received Auto-Focus")	
	ser.write("\xff\x30\x31\x00\xA1\x30\xEF")
	reading()
	hostReturn()

def focusManual():
	hostPull()
	print("Command Received Manual-Focus")
	ser.write("\xff\x30\x31\x00\xA1\x31\xEF")
	reading()
	hostReturn()

def focusNear():
	hostPull()
	print("Command Received Focus-Near")
	ser.write("\xff\x30\x31\x00\xA1\x32\xEF")
	reading()
	time.sleep(0.05)
	focusManual()

def focusFar():
	hostPull()
	print("Command Received Focus-Far")
	ser.write("\xff\x30\x31\x00\xA1\x33\xEF")
	reading()
	time.sleep(0.05)
	focusManual()

def speed1():
	global speedVal
	speedVal = 1
	hostPull()
	print("Command Received Speed1")
	ser.write("\xff\x30\x31\x00\x50\x30\x3A\x30\xEF")
	reading()
	time.sleep(0.1)
	ser.write("\xff\x30\x31\x00\x51\x30\x37\x3E\xEF")
	reading()
	time.sleep(0.1)
	hostReturn()

def speed2():
	global speedVal
	speedVal = 2
	hostPull()
	print("Command Received Speed2")
	ser.write("\xff\x30\x31\x00\x50\x31\x34\x30\xEF")
	reading()
	time.sleep(0.1)
	ser.write("\xff\x30\x31\x00\x51\x30\x3F\x3A\xEF")
	reading()
	time.sleep(0.1)
	hostReturn()

def speed3():
	global speedVal
	speedVal = 3
	hostPull()
	print("Command Received Speed3")
	ser.write("\xff\x30\x31\x00\x50\x31\x3E\x30\xEF")
	reading()
	time.sleep(0.1)
	ser.write("\xff\x30\x31\x00\x51\x31\x37\x36\xEF")
	reading()
	time.sleep(0.1)
	hostReturn()

def speed4():
	global speedVal
	speedVal = 4
	hostPull()
	print("Command Received Speed4")
	ser.write("\xff\x30\x31\x00\x50\x32\x38\x30\xEF")
	reading()
	time.sleep(0.1)
	ser.write("\xff\x30\x31\x00\x51\x31\x3F\x32\xEF")
	reading()
	time.sleep(0.1)
	hostReturn()

def speed5():
	global speedVal
	speedVal = 5
	hostPull()
	print("Command Received Speed5")
	ser.write("\xff\x30\x31\x00\x50\x33\x32\x30\xEF")
	reading()
	time.sleep(0.1)
	ser.write("\xff\x30\x31\x00\x51\x32\x36\x3E\xEF")
	reading()
	time.sleep(0.1)
	hostReturn()
	
def cam1Activate():
	global ser
	try:
		ser.close()
	except:
		pass
	COMportScan()
	time.sleep(0.1)
	print 'Trying to select camera 1...'
	try:
		ser = serial.Serial(availableCOMports[0], baudrate=9600, stopbits=1, rtscts=True, dsrdtr=0, writeTimeout=1, timeout=0.1)
		ser.flushInput()
		ser.flushOutput()
		time.sleep(0.1)
		initialize()
		time.sleep(0.1)
		print 'Success! Opened camera on ' + availableCOMports[0]
	except:
		print 'No COM/camera available!  Check Camera/Connections.'
		global camConStat
		camConStat = 0
		return
	
	
def cam2Activate():
	global ser
	try:
		ser.close()
	except:
		pass
	COMportScan()
	time.sleep(0.2)
	print 'Trying to select camera 2...'
	try:
		ser = serial.Serial(availableCOMports[1], baudrate=9600, stopbits=1, rtscts=True, dsrdtr=0, writeTimeout=1, timeout=0.1)
		ser.flushInput()
		ser.flushOutput()
		time.sleep(0.1)
		initialize()
		time.sleep(0.1)
		print 'Success! Opened camera on ' + availableCOMports[1]
	except:
		print 'Or no COM available!  Check Camera/Connections.'
		global camConStat
		camConStat = 0
		return

options = { '0' : camOff,
			'1' : camOn,
			'3' : tiltUp,
			'4' : tiltDown,
			'5' : panLeft,
			'6' : panRight,
			'7' : home,
			'8' : zoomTele,
			'9' : zoomWide,
			'a' : set1,
			'b' : set2,
			'c' : set3,
			'd' : set4,
			'e' : set5,
			'f' : set6,
			'g' : set7,
			'h' : set8,
			'i' : set9,
			'k' : move1,
			'l' : move2,
			'm' : move3,
			'n' : move4,
			'o' : move5,
			'p' : move6,
			'q' : move7,
			'r' : move8,
			's' : move9,
			'u' : focusAuto,
			'v' : focusManual,
			'w' : focusNear,
			'x' : focusFar,
			'A' : speed1,
			'B' : speed2,
			'C' : speed3,
			'D' : speed4,
			'E' : speed5,
			'G' : cam1Activate,
			'H' : cam2Activate
}

def setkeepalives(sck):
  sck.setsockopt(socket.SOL_SOCKET, socket.SO_KEEPALIVE, 1)

host = ''
port = 25559
backlog = 5
size = 1024
while 1:
	s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
	setkeepalives(s)
	s.bind((host,port))
	s.listen(backlog)
	client, address = s.accept()
	data = 1
	mean = 0
	client.send("2")

	print "Client connected to server at:"
	print datetime.datetime.now().strftime("%I:%M:%S%p on %B %d, %Y")
	print "Waiting for data.."
	while data > 0:
		data = client.recv(size)
		try:
			if len(data) is not 0:
				"""print len(data)"""
				"""print data"""
				options[data]()
				if camConStat is 1:
					client.send(data)
				else:
					client.send('Z')
					camConStat = 1
				print "Return command complete at:"
				print datetime.datetime.now().strftime("%I:%M:%S%p on %B %d, %Y")
			elif len(data) == 0:
				client.send("1");
				print "Client closed connection at:"
				print datetime.datetime.now().strftime("%I:%M:%S%p on %B %d, %Y")
				ser.close()
				break
			else:
				pass
		except:
			pass