# smartfolders
generate dock folders in ubuntu

<img width="162" height="82" alt="image" src="https://github.com/user-attachments/assets/54263f53-bdb8-4a17-a188-1af55aca3b9a" />




<img width="611" height="345" alt="image" src="https://github.com/user-attachments/assets/ed15cd32-2bca-433a-9f13-027338c7faf7" />

for usage with pcmanfm (not suitable if you're using pcmanfm as your default file explorer/adjust the code for another application)


requirements

```
sudo apt-get install imagemagick
sudo apt install inkscape
sudo apt install pcmanfm
```

open pcmanfm and hide every control element (like statusbar etc.)
if you want to hide the menu bar like in the screenshot you need to rebuild pcmanfm yourself with a .patch file (https://gist.github.com/M4he/3a8171a7f39d9ba9a0cf6bb387b08061#file-pcmanfm_hide_menubar-patch)


how to use:

1. download script
2. find the full paths of the .desktop files of your applications they are usually in ~/.local/share/applications /usr/share/applications or /var/lib/snapd/desktop/applications/ you can also use 'gsettings get org.gnome.shell favorite-apps' to find the .desktop filenames that are in your dock
3. ./smartfolder.sh <full-path-of-desktop-file1> <full-path-of-desktop-file2> <full-path-of-desktop-file3> etc
4. new .desktop file of group will be generated and put into activities. type one of the added application names into the search and you will find the foldergroup
5. right click and add to dock
