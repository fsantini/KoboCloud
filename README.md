# KoboCloud
A set of scripts to synchronize a kobo reader with popular cloud services. At the moment Owncloud and Dropbox are supported

## Installation
Run the script makeKoboRoot.sh . This will create a KoboRoot.tgz archive. Copy said archive in the .kobo directory of your reader (it is a hidden directory, so you might want to enable the visualization of hidden files) and restart your Kobo.

## Configuration
After restarting, plug your kobo back into the computer. Navigate to the .kobo directory. A new kobocloud directory should have appeared. Inside, edit the file kobocloudrc to add the links to the cloud services (one per line).
Notice: No subdirectories are supported at the moment, so be sure that your books are all in the same directories that you are sharing.

### Nextcloud (Owncloud)
To add a nextcloud (owncloud) link, open your nextcloud website in a browser and select the folder that you want to share. Click on "Share" and select "Share with link". Copy the link into the kobocloudrc file.
Please note that you need a recent Nextcloud version. Owncloud is at the moment not tested, but should also work.

### Dropbox
To add a Dropbox link, open your dropbox in a browser. Select the folder that you want to share and click "Share" and "Send link". Copy the link that appears into the kobocloudrc file.

### Restart
Restart your Kobo after making changes to kobocloudrc to make them effective.

## Usage
The new files will be downloaded when the kobo connects to the Internet for a sync.

## Troubleshooting
KoboCloud keeps a log of each session in the .kobo/kobocloud/get.log file. If something goes wrong, useful information can be found there. Please send a copy of this file with every bug report.

## Known issues
* No subdirectories are supported
* Support of Google Drive can be considered if there is demand

## Acknowledgment
Thanks to the defunct SendToKobo service for the inspiration of the project and for the basis of the scripts.
Curl for Kobo was downloaded from here: https://www.mobileread.com/forums/showthread.php?p=3734553 . Thanks to NiLuJe for providing it!
Thanks to Christoph Burschka for the help in updating this tool to the recent versions of kobo and nextcloud.
