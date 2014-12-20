import ctypes
import os
import urllib
import random
import string
import re

def random_string(size=6, chars=string.ascii_uppercase + string.digits):
	return ''.join(random.choice(chars) for _ in range(size))

#Get latest wallpaper from the web
latest = urllib.urlopen("http://www.davepagurek.com/stuff/wallpaper/latest.txt")
num = int(latest.readline() )
url = latest.readline()

#Isolate the filename from all the previous directories
r = re.search(r'[\/\\]*([a-zA-Z0-9-_ ]*\.[a-z]+)$', url)
filename = r.group(1)

#Check if the website's file is newer than ours
update = False
if os.path.isfile("current.txt"):
	current = open("current.txt")
	old_num = int(current.readline() )
	
	if num > old_num:
		update = True

#If we have none so far, download the newest
else:
	update = True

#Apply new wallpaper
if update:

	#Hide the file in an obscure directory
	localpath = "C:\\w\\" + random_string()  + "\\" + random_string() + "\\" + random_string()
	if not os.path.exists(localpath):
		os.makedirs(localpath)
	urllib.urlretrieve("http://www.davepagurek.com/stuff/wallpaper/" + url, localpath + "\\" + filename)

	#Mark the number
	current = open("current.txt", "w")
	current.write(str(num) )

	#Apply wallpaper
	SPI_SETDESKWALLPAPER = 20
	ctypes.windll.user32.SystemParametersInfoA(SPI_SETDESKWALLPAPER, 0, localpath + "\\" + filename , 0)

	identity = open("identity.txt")
	id = identity.readline()
	read = urllib.urlopen("http://www.davepagurek.com/stuff/wallpaper/read.pl?id=" + id)
