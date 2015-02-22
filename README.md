<h1>Sari-Wallpaper</h1>
![Wallpaper changer web interface](http://www.davepagurek.com/content/images/2015/2/sari-wallpaper.png)

A joke I'm playing on my sister where I remotely change her wallpaper to pictures of me.

See the past wallpapers and web interface here: http://davepagurek.com/stuff/wallpaper

<h2>The Backstory</h2>
So my sister is seven years younger than me. I thought it might be weird for her not having me in the house once I left for university so I decided to play this joke on her where I repeatedly change her wallpaper to pictures of me instead.

I started first by changing her wallpaper while I was in the house, so she thought I was physically sneaking into her room at night to change her wallpaper. Passwords were changed but the wallpapers still arrived. I laid low for a week or so after going to Waterloo to lure her back into a false sense of security and then made the wallpapers come back with a vengeance.

Since then, the surprise of having my wallpapers arrive has warn off, so the fun exists mostly in picking interesting photos and selfies to set her wallpaper to. I showed her how the whole thing works and she <a href="http://saripagurek.com/wallpaper/" target="_blank">implemented her own version</a> to change my dad's wallpapers.

<h2>Client Setup</h2>
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
  <li>Add the line <code>0 * * * * python3 /home/username/path/to/file/wallpaper_linux.py</code> to run the script every hour</li>
</ol>

<h2>Server Setup</h2>
<ol>
  <li>Make sure the HTML::Template Perl module is installed by running <code>cpan install HTML::Template</code></li>
  <li>Edit <code>server/config-example.pl</code> and change the password string to the password to use for the upload server. Change the devices you are listening for, corresponding to the contents of <code>client/identity.txt</code> earlier. Then, rename the file to <code>server/config.pl</code>.</li>
  <li>Copy all of the files from the <code>server</code> folder onto your hosting directory.</li>
  <li>Make sure everything is <code>chmod 775</code> and <code>chown www-data:www-data</code>.</li>
  <li>If you want to edit the visual styles of the server code, edit the files in <code>server/templates</code>. They use Perl HTML::Template syntax.</li>
</ol>
