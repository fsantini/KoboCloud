# KoboCloud
A set of scripts to synchronize a kobo reader with popular cloud services.

The following cloud services are supported:

- Dropbox
- Google Drive
- NextCloud/OwnCloud
- pCloud


## Installation

The installation process has 2 steps:

- Compile the script into an archive format
- Install into the Kobo device

Below we describe each step.

### Compilling

- Move to the project directory root
- Run `sh ./makeKoboRoot.sh`

The last command will create a `KoboRoot.tgz` archive.

### Installing

- Connect the Kobo device and mount it (you should be able to access to the kobo filesystem)
- Copy the .tgz archive in the .kobo directory(1) of your device
- Restart your Kobo device

(1) It is a hidden directory, so you have to enable the visualization of hidden files

## Configuration

After following the installation process:

- Plug your Kobo back into the computer
- Open the configuration file located at `.add/kobocloud/kobocloudrc`
- Add the links to the cloud services (one per line)

Configuration example:

```
# Lines starting with '#' are ignored
# Google drive:
https://drive.google.com/drive/folders/<ID>?usp=sharing
# Dropbox:
https://www.dropbox.com/sh/pgSHORTENED
```

**Important**: make sure that there are no spaces before or after the link on the line.

Notice: No subdirectories are supported at the moment. Your books must be all in the same directories that you are sharing.

Restart your Kobo after making changes to kobocloudrc to make them effective.

### Dropbox

To add a Dropbox link:

- Open your dropbox in a browser
- Select the folder that you want to share and click "Share" and "Send link"
- Copy the link that appears into the kobocloudrc file


### Google Drive

- Use the "link sharing" option on a Google Drive folder
- Select the option "anyone with the link can view."
- Copy-paste the link in the kobocloudrc file

**Important**: Folders with many files might not work.

### Nextcloud (Owncloud)

To add a NextCloud (ownCloud) link:

- Open your nextcloud website in a browser
- Select the folder that you want to share
- Click on "Share" and select "Share with link"
- Copy the link into the kobocloudrc file

Please note that you need a recent Nextcloud version. Owncloud is at the moment not tested, but should also work.

### pCloud

- Add the public link to the containing folder (starting with https://my.pcloud.com/ or https://u.pcloud.link/) to the kobocloudrc file.

Files added into a subfolder of the *public* folder of pCloud are also supported.

## Usage

The new files will be downloaded when the kobo connects to the Internet for a sync.

## Uninstallation

To properly uninstall KoboCloud:

- Edit the kobocloudrc file so that it contains the word `UNINSTALL` in a single line (all capital, no spaces before or after)
- Restart your Kobo

The next time the Kobo is connected to the Internet, the program will delete itself.

Note: The directory .add/kobocloud will not be deleted: after connecting the device to a computer, you should move the files from the Library subfolder in order not to lose your content, and delete the whole kobocloud directory manually.

## Troubleshooting

KoboCloud keeps a log of each session in the .add/kobocloud/get.log file. If something goes wrong, useful information can be found there. Please send a copy of this file with every bug report.

## Known issues

* No subdirectories are supported
* Some versions of Kobo make the same book appear twice in the library. This is because it scans the internal directory where the files are saved as well as the "official" folders. To solve this problem find the `Kobo eReader.conf` file inside your `.add` folder and make sure the following line (which prevents the syncing of dotfiles and dotfolders) is set in the `[FeatureSettings]` section:
```
  ExcludeSyncFolders=\\.(?!add|adobe).*?
```


## Acknowledgment

Thanks to the defunct SendToKobo service for the inspiration of the project and for the basis of the scripts.
Curl for Kobo was downloaded from here: https://www.mobileread.com/forums/showthread.php?p=3734553 . Thanks to NiLuJe for providing it!
Thanks to Christoph Burschka for the help in updating this tool to the recent versions of kobo and nextcloud.
