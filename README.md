# GitSync
### Sync All Starred and Owned Repos to Local Folder
This script will sync all of the public repositories for a user to a local folder.  It will also sync all of the private repositories for a user to a local folder if the Personal Token is provided.  This script is designed to be run on a schedule to keep a local folder up to date with all of the public repositories for a user. Multiple Users can be provided, and you can also sync all of the starred repositories for a user or users.
## Usage
1. Install [Git](https://git-scm.com/downloads)
2. Clone this repo with `git clone https://github.com/michaelphagen/GitSync.git`
3. Run gitSync.bash with at least the -u and -l flags to download all of the public repositiories for a user

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Ex: ```./gitSync.bash -u michaelphagen -l /home/michaelphagen/GitHub```

## Flags
| Flag | Description | Required | Notes |
| --- | --- | --- | --- |
| -u | Github Username | Yes | Multiple usernames can be provided, separated by commas |
| -l | Local Folder | Yes | Path to the folder you want as the root of the sync. The folder will be created if it does not exist. The folder structure will be as follows: ```/Local Folder/Repository Owner/Repository Name``` |
| -p | Personal Token | No | GitHub Personal Token for the user, will alllow Private Repositories to be cloned, Multiple Personal Tokens can be provided to clone the private repos of multiple comma separated users, and if there is not a Personal Token provided for a user it will just get the Public Repos|
| -s | Starred Repos | No | Will clone all starred repos for all specified users. You don't need to put anything after -s, just including the flag will clone starred repos |

