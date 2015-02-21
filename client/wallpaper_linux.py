from gi.repository import Gio
import os
import urllib.request
import random
import string
import re

#change wallpaper even if it's not new
FORCE = True


def random_string(size=6, chars=string.ascii_uppercase + string.digits):
	return ''.join(random.choice(chars) for _ in range(size))

#Get latest wallpaper from the web
latest = urllib.request.urlopen("http://saripagurek.com/wallpaper/latest.txt")
num = int(latest.readline().decode('utf-8') )
url = latest.readline().decode('utf-8')

#Isolate the filename from all the previous directories
r = re.search(r'[\/\\]*([a-zA-Z0-9-_ ]*\.[a-zA-Z]+)$', url)
filename = r.group(1)

filepath = ""

#Check if the website's file is newer than ours
update = False
if os.path.isfile("current.txt"):
	current = open("current.txt")
	old_num = int(current.readline() )
	filepath = current.readline()
	
	if num > old_num:
		update = True

#If we have none so far, download the newest
else:
	update = True


#Apply new wallpaper
if update:

	#Hide the file in an obscure directory
	localpath = "/home/steve/Downloads/" + random_string()  + "/" + random_string() + "/" + random_string()
	if not os.path.exists(localpath):
		os.makedirs(localpath)
	urllib.request.urlretrieve("http://" + urllib.parse.quote("saripagurek.com/" + url.rstrip()), localpath + "/" + filename)

	#Mark the number
	current = open("current.txt", "w")
	current.write(str(num) + "\n")
	current.write(os.path.join("file://" + localpath + "/", filename))

	#Apply wallpaper
	os.system("DISPLAY=:0 GSETTINGS_BACKEND=dconf DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-2YdDw7dn6T gsettings set org.gnome.desktop.background picture-uri '%s'" % os.path.join("file://" + localpath + "/", filename))

	
elif (FORCE and len(filepath) > 0):
	#Apply wallpaper
	os.system("DISPLAY=:0 GSETTINGS_BACKEND=dconf DBUS_SESSION_BUS_ADDRESS=unix:abstract=/tmp/dbus-2YdDw7dn6T gsettings set org.gnome.desktop.background picture-uri '%s'" % filepath)
