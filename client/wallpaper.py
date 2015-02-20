from ctypes import *
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
latest = urllib.request.urlopen("http://www.davepagurek.com/stuff/wallpaper/latest.txt")
num = int(latest.readline().decode('utf-8') )
url = latest.readline().decode('utf-8').rstrip()

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
    localpath = "C:\\w\\" + random_string()  + "\\" + random_string() + "\\" + random_string()
    if not os.path.exists(localpath):
        os.makedirs(localpath)
        urllib.request.urlretrieve("http://www.davepagurek.com/stuff/wallpaper/" + urllib.parse.quote(url), localpath + "\\" + filename)

    #Mark the number
    current = open("current.txt", "w")
    current.write(str(num) + "\n")
    current.write(os.path.join(localpath + "\\", filename))

    #Apply wallpaper
    SPI_SETDESKWALLPAPER = 0x14
    SPIF_UPDATEINIFILE   = 0x1
    SystemParametersInfo = windll.user32.SystemParametersInfoW
    SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, os.path.join(localpath + "\\", filename), SPIF_UPDATEINIFILE)


    identity = open("identity.txt")
    id = identity.readline()
    read = urllib.request.urlopen("http://www.davepagurek.com/stuff/wallpaper/read.pl?id=" + id)


elif (FORCE and len(filepath) > 0):
    #Apply wallpaper
    SPI_SETDESKWALLPAPER = 0x14
    SPIF_UPDATEINIFILE   = 0x1
    SystemParametersInfo = windll.user32.SystemParametersInfoW
    SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, filepath, SPIF_UPDATEINIFILE)

