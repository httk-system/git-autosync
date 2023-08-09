# Git-autosync

Tools for setting up continous dropbox-like syncronization of the working state of Git repositories into branches named `git-autosync-<hostname>`,
which can (but must not) be in a separate repository.

## Setup

On both your ssh-accssible server and your local machine do:
```
mkdir -p ~/Sync
mkdir -p ~/Tools
cd ~/Tools
git clone https://github.com/httk-system/git-autosync.git
```
Add ~/Tools/git-autosync/bin to your path (e.g., in `.bashrc`).

If you do not want to use a setup for completely passwordless authentication with your server, you can setup a connection-sharing socket with:
```
git-autosync-setup-ssh username@server
```

## For each repo 

(If you want to setup an empty repo, create it on your main repo host, e.g., GitHub, first.)

Clone a bare copy of the repo you want to work with on your server:
```
ssh username@server git clone --bare git@github.com:example_user/example_repo ~/Sync/example_repo
```
Then, on your local system:
```
cd ~/Sync
git-autosync-clone git@github.com:example_user/example_repo username@server:Sync/example_repo.git
```

## Usage

Now edit files as normal on your local system. To sync your working state (possibly via a cron job) of a repo, run:
```
git-autosync-commit ~/Sync/example_repo
```

To sync all repos under `~/Sync`:
```
git-autosync-commit-all ~/Sync
```
This can, e.g., be placed in an hourly cron job.

## Notes

Operation keeps another set of full copies of your repos inside ~/.git-autosync, which may be a waste of time.
These complete copies are not actually necessary, but speed things up. 




