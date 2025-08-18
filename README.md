# smartfolders
generate dock folders in ubuntu

<img width="546" height="113" alt="image" src="https://github.com/user-attachments/assets/eb279828-6123-4194-b82a-52c9f438988d" />

<br />

<img width="611" height="345" alt="image" src="https://github.com/user-attachments/assets/ed15cd32-2bca-433a-9f13-027338c7faf7" />

for usage with pcmanfm (not suitable if you're using pcmanfm as your default file explorer/adjust the code for another application)


## requirements

```
sudo apt-get install imagemagick
sudo apt-get install inkscape
sudo apt-get install pcmanfm
```

open pcmanfm and hide every control element (like statusbar etc.) <br /><br />
if you want to hide the menu bar like in the screenshot you'll need to rebuild pcmanfm yourself with a .patch file <br />(https://gist.github.com/M4he/3a8171a7f39d9ba9a0cf6bb387b08061#file-pcmanfm_hide_menubar-patch)<br />


## how to use:<br />

1. download script and place it in a folder
2. find the full paths of the .desktop files of your applications they are usually in `~/.local/share/applications ` `/usr/share/applications` or `/var/lib/snapd/desktop/applications/` <br /><br />you can also use `gsettings get org.gnome.shell favorite-apps` to show the .desktop filenames in your dock and then run `./find_desktop_file.sh filename.desktop` to find the full path
3. `./smartfolder.sh <full-path-of-desktop-file1> <full-path-of-desktop-file2> <full-path-of-desktop-file3>` etc
4. new .desktop file of the group will be generated and put into activities. type one of the added application names into the search and you will find the foldergroup
5. right click and add to dock
