<h1>Sari-Wallpaper</h1>
A joke I'm playing on my sister where I remotely change her wallpaper to pictures of me.

See the past wallpapers and web interface here: http://davepagurek.com/stuff/wallpaper

<h2>Client setup</h2>
<h3>Windows</h3>
<ol>
  <li>Run <code>python setup.py py2exe</code> to create an exe to store on the client (using Python 3)</li>
  <li>Edit <code>client/wallpaper.vbs</code> to reflect the correct path to the generated exe</li>
  <li>Edit <code>client/identity.txt</code> to give a unique string to each client listening for wallpapers</li>
  <li>Open the Windows Task Scheduler and import <code>client/update_wallpaper.xml</code> to create scheduled tasks to update wallpapers. Edit the task's Action to the location you have <code>wallpaper.vbs</code> stored.</li>
</ol>

<h3>Linux</h3>
<ol>
  <li>Run <code>crontab -e</code> to edit  cron jobs</li>
  <li>Add the line <code>0 * * * * python3 /home/username/path/to/file/wallpaper.py</code> to run the script every hour</li>
</ol>

<h2>Server Setup</h2>
<ol>
  <li>Edit <code>server/credentials-example.pl</code> and change the contained string to the password to use for the upload server. Then, rename it to <code>server/credentials.pl</code>.</li>
  <li>Copy all of <code>server/*</code> onto your hosting directory.</li>
  <li>Make sure everything is <code>chmod 775</code> and <code>chown www-data:www-data</code></li>
</ol>
