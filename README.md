# Git-cloud

Timeline and syncronization helpers to maintain a 'cloud' tree of git repos.

## Setup

On both your ssh-accssible server, setup your repotree:
```
mkdir -p ~/Sync.repos
touch ~/Sync.repos/.git-cloud-remote-root
```

On your local machine do:
```
mkdir -p ~/Sync
touch ~/Sync/.git-cloud-root
mkdir -p ~/Tools
cd ~/Tools
git clone https://github.com/httk-system/git-cloud.git
```
Add ~/Tools/git-cloud/bin to your path, e.g., by inserting this line at the end of your `~/.bashrc`:
```
export PATH=$PATH:$(find -L ~/Tools -type d -name "bin" -prune | tr "\n" ":")
```

If you do not want to set up a public ssh key for use with git-cloud, you can do so with:
```
git cloud key username@server
```

## For repos that you only keep on your cloud server

## For repos that you work with on, e.g., GitHub

(If you want to setup an empty repo, create it on, e.g., GitHub, first.)

Clone a bare copy of the repo you want to work with on your server:
```
ssh username@server git clone --bare git@github.com:example_user/example_repo ~/Sync/example_repo.git
```
Then, on your local system:
```
cd ~/Sync
git cloud clone git@github.com:example_user/example_repo username@server:Sync/example_repo.git
```

## Usage

Now edit files as normal on your local system. To sync your working state (possibly via a cron job) of a repo, run:
```
git-cloud-commit ~/Sync/example_repo
```

To sync all repos under `~/Sync`:
```
git-cloud-commit-all ~/Sync
```
This can, e.g., be placed in an hourly cron job.

## Notes

Operation keeps another set of full copies of your repos inside ~/.git-cloud, which may be a waste of time.
These complete copies are not actually necessary, but speed things up.
