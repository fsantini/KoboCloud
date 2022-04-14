# KoboCloud
A set of scripts to synchronize a kobo reader with popular cloud services.

The following cloud services are supported:

- Dropbox (two methods)
- Google Drive
- NextCloud/OwnCloud
- pCloud
- Box

## <a name="installation"></a>Installation

Download the latest `KoboRoot.tgz` from the Release page (or using [this direct link](https://github.com/fsantini/KoboCloud/releases/download/latest/KoboRoot.tgz)).

Copy it into the Kobo device:

- Connect the Kobo device and mount it (you should be able to access to the kobo filesystem)
- Copy the .tgz archive in the .kobo directory(1) of your device
- Unplug and restart your Kobo device

(1) It is a hidden directory, so you have to enable the visualization of hidden files

**Note for Mac/Safari users:** Safari automatically unpacks `KoboRoot.tgz` into `KoboRoot.tar` after downloading. Please make sure that you transfer the `.tgz` file to your Kobo, and **not** the `.tar`. Either use a different browser to download the package, or re-pack it (using `gzip`) before transferring.

## Configuration

After the installation process:

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
REMOVE_DELETED
```

Some important advice:
- make sure that there are **no spaces** before or after the link on the line
- **no subdirectories** are supported at the moment, your books must be all in the same directories that you are sharing
- **restart your Kobo** after any kobocloudrc changes to to make them effective

### Dropbox public folder (limited)

To add a Dropbox public link:

- Open your dropbox in a browser
- Select the folder that you want to share and click "Share" and "Send link"
- Copy the link that appears into the kobocloudrc file

Note: this method does not work for folders with more than ~30 books, see https://github.com/fsantini/KoboCloud/issues/123.

### Dropbox private folder

This method will create a folder `/Applications/Kobo Cloud Sync` in your Dropbox and sync with it.

- Open this [link](https://www.dropbox.com/oauth2/authorize?response_type=code&token_access_type=offline&client_id=5oyw72cfwcp352f&code_challenge_method=plain&code_challenge=0000000000000000000000000000000000000000000&redirect_uri=https://louisabraham.github.io/KoboCloud/)
- Paste the command in a terminal
- Copy the line starting with `DropboxApp:` from your terminal
- Add it to your `kobocloudrc` file

### Google Drive

- Use the "link sharing" option on a Google Drive folder
- Select the option "anyone with the link can view."
- Copy-paste the link in the kobocloudrc file

Subdirectories are supported for Google Drive.
**Important**: Folders with many files might not work.

### Nextcloud (Owncloud)

To add a NextCloud (ownCloud) link:

- Open your nextcloud website in a browser
- Select the folder that you want to share
- Click on "Share" and select "Share with link"
- Copy the link into the kobocloudrc file

Please note that you need a recent NextCloud (OwnCloud) version.
Subdirectories are supported for NextCloud (OwnCloud).

**Important**: Webdav for public folders should be enabled, see: https://docs.nextcloud.com/server/20/user_manual/en/files/access_webdav.html#accessing-public-shares-over-webdav for more info.

### pCloud

- Add the public link to the containing folder (starting with https://my.pcloud.com/ or https://u.pcloud.link/) to the kobocloudrc file.

Files added into a subfolder of the *public* folder of pCloud are also supported.

### Box

- On a Box folder, click "Create link" in the sidebar and enable "Share Link"
- Select the options "People with the link" and "can view and download"
- Copy-paste the link in the kobocloudrc file

Please note that, even though the script supports folders where the file list has multiple pages, having a list with many pages might not work.

### Matching remote server
To delete files from library when they are no longer in the remote server:

- Edit the kobocloudrc file so it contains the phrase `REMOVE_DELETED` in a single line (all capital, no spaces before or after).
- Restart your Kobo.

The next time the Kobo is connected to the internet, it will delete any files (it will not delete directories) that are not in the remote server.


## Usage

The new files will be downloaded when the kobo connects to the Internet for a sync. Sometimes few minutes is needed after the sync process for the device to recognize and import new downloaded content.

## Uninstallation

To properly uninstall KoboCloud:

- Edit the kobocloudrc file so that it contains the word `UNINSTALL` in a single line (all capital, no spaces before or after)
- Restart your Kobo

The next time the Kobo is connected to the Internet, the program will delete itself.

Note: The directory .add/kobocloud will not be deleted: after connecting the device to a computer, you should move the files from the Library subfolder in order not to lose your content, and delete the whole kobocloud directory manually.

## Installation from source code

To install KoboCloud from source code:

- Download this repository
- Compile the code into an archive format (instructions below)
- Follow [installation](#installation) instructions

### Compiling

- Move to the project directory root
- Open the configuration file located at `src/usr/local/kobocloud/kobocloudrc.tmpl`
- Add the links to the cloud services (see the configuration example that follow below)
- Run `sh ./makeKoboRoot.sh`

The last command will create a `KoboRoot.tgz` archive.

Now you can follow [installation](#installation) instructions.

## Troubleshooting

KoboCloud keeps a log of each session in the .add/kobocloud/get.log file. If something goes wrong, useful information can be found there. Please send a copy of this file with every bug report.

## Known issues

* No subdirectories are supported
* Some versions of Kobo make the same book appear twice in the library. This is because it scans the internal directory where the files are saved as well as the "official" folders. To solve this problem find the `Kobo eReader.conf` file inside your `.kobo/Kobo` folder and make sure the following line (which prevents the syncing of dotfiles and dotfolders) is set in the `[FeatureSettings]` section:
```
  ExcludeSyncFolders=\\.(?!add|adobe).*?
```


## Acknowledgment

Thanks to the defunct SendToKobo service for the inspiration of the project and for the basis of the scripts.
Curl for Kobo was downloaded from here: https://www.mobileread.com/forums/showthread.php?p=3734553 . Thanks to NiLuJe for providing it!
Thanks to Christoph Burschka for the help in updating this tool to the recent versions of kobo and nextcloud.
