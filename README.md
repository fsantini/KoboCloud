# KoboCloud
A set of scripts to synchronize a kobo reader with popular cloud services. At the moment Owncloud and Dropbox are supported

## Installation
Run the script makeKoboRoot.sh . This will create a KoboRoot.tgz archive. Copy said archive in the .kobo directory of your reader (it is a hidden directory, so you might want to enable the visualization of hidden files) and restart your Kobo.

## Configuration
After restarting, plug your kobo back into the computer. Navigate to the .kobo directory. A new kobocloud directory should have appeared. Inside, edit the file kobocloudrc to add the links to the cloud services (one per line).
Notice: No subdirectories are supported at the moment, so be sure that your books are all in the same directories that you are sharing. **Important:** make sure that there are no spaces before or after the link on the line.

### Nextcloud (Owncloud)
To add a nextcloud (owncloud) link, open your nextcloud website in a browser and select the folder that you want to share. Click on "Share" and select "Share with link". Copy the link into the kobocloudrc file.
Please note that you need a recent Nextcloud version. Owncloud is at the moment not tested, but should also work.

### Dropbox
To add a Dropbox link, open your dropbox in a browser. Select the folder that you want to share and click "Share" and "Send link". Copy the link that appears into the kobocloudrc file.

### pCloud
Files added into a subfolder of the *public* folder of pCloud are also supported. Add the public link to the containing folder (starting with https://filedn.com/) to the kobocloudrc file.

### Google Drive
Google Drive is supported. Use the "link sharing" option on a Google Drive folder and select the option "anyone with the link can view." Copy-paste the link in the kobocloudrc file. *Note:* Folders with many files might not work.

### Restart
Restart your Kobo after making changes to kobocloudrc to make them effective.

## Usage
The new files will be downloaded when the kobo connects to the Internet for a sync.

## Uninstallation
To properly uninstall KoboCloud, edit the kobocloudrc file so that it contains the word `UNINSTALL` in a single line (all capital, no spaces before or after). Restart your Kobo. The next time the Kobo is connected to the Internet, the program will delete itself.
The directory .kobo/kobocloud will not be deleted: after connecting the ereader to a computer, you should move the files from the Library subfolder in order not to lose your content, and delete the whole kobocloud directory manually.

## Troubleshooting
KoboCloud keeps a log of each session in the .kobo/kobocloud/get.log file. If something goes wrong, useful information can be found there. Please send a copy of this file with every bug report.

## Known issues
* No subdirectories are supported

## Acknowledgment
Thanks to the defunct SendToKobo service for the inspiration of the project and for the basis of the scripts.
Curl for Kobo was downloaded from here: https://www.mobileread.com/forums/showthread.php?p=3734553 . Thanks to NiLuJe for providing it!
Thanks to Christoph Burschka for the help in updating this tool to the recent versions of kobo and nextcloud.
