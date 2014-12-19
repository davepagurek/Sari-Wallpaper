<h1>Sari-Wallpaper</h1>
A joke I'm playing on my sister where I remotely change her wallpaper to pictures of me.

<h2>Client setup</h2>
<ol>
  <li>Run `python setup.py py2exe` to create an exe to store on the client</li>
  <li>Edit `client/wallpaper.vbs` to reflect the correct path to the generated exe</li>
  <li>Edit `client/identity.txt` to give a unique string to each client listening for wallpapers</li>
  <li>Open the Windows Task Scheduler and import `client/update_wallpaper.xml` to create scheduled tasks to update wallpapers. Edit the task's Action to the location you have `wallpaper.vbs` stored.</li>
</ol>
