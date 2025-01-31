Hello MOBsters, welcome to this brand new Github repository! This is where you will find all the instructions to switch from our Dropbox platform to Github.

# First steps

I will assume you already have a GitHub account, and have access to the PrgGithub repo. I will also assume that your connection with the Github server runs smoothly via ssh. Inorder to do so, simply run in your terminal :

```bash
ssh -T git@github.com
```

If this raises an error, please see the [Github documentation](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh) to set up your ssh keys. You might also find the [troubleshoot section](#troubleshoot) useful.

## How to use this repository

This repository is seen as a total replacement of our current Dropbox folder for codes. In order to use it, there are two important steps you should follow :

1. Clone the repository on your computer
2. Set up the repository as a Matlab path

### Clone the repository

In your terminal, navigate to the folder where you want to clone the repository. Then, run the following command :

```bash
git clone git@github.com:MobsLab/PrgGithub.git
```

This will create a folder named `PrgGithub` in the folder you are currently in. This folder will contain all the codes that are in the repository.

**This folder can be anywhere, as long as your computer always has access to it.** I suggest you put it in your home folder, or in your Documents. This "clone" will be your local version of the repository, and will be where you will work on the codes.

### Set up the repository as a Matlab path

After cloning the repository, you will need to set it up as a Matlab path. This will allow you to use the functions and scripts in the repository from anywhere in your Matlab environment. You probably already have a `startup.m` file in your Matlab path that currently loads the Dropbox/PrgMatlab folder. If you don't, you can create one in your home folder (usually in `$HOME/Documents/MATLAB/startup.m`). If you don't know where is this file, you can run the following command in Matlab :

```matlab
userpath
```

This will give you the path to the folder where Matlab looks for the `startup.m` file. You can then create or edit this file to add the following lines :

```matlab
addpath(genpath('path/to/PrgGithub'))
```

You will also need to comment/delete the current line stating to add the Dropbox folder to the path and that looks roughly like this :

```matlab
% addpath(genpath('/home/username/Dropbox/Kteam/PrgMatlab'))
```

This will make sure that Matlab looks for the functions and scripts in the `PrgGithub` folder for now on.

> [!WARNING]
> Make sure to replace `path/to/PrgGithub` with the actual path to the `PrgGithub` folder on your computer.
> Make also sure to close all the matlab windows before changing the `startup.m` file.

# How to contribute

**Note**: maybe this is not necessary yet, need to check in team meetings.

In order to contribute to the repository, you will need to create a new branch. This will allow you to work on your own version of the repository without affecting the main branch. Once you are done with your modifications, you can create a pull request to merge your branch with the main branch.

## Create a new branch

In your terminal, navigate to the `PrgGithub` folder. Then, run the following command :

```bash
git checkout -b your-branch-name
```

This will create a new branch named `your-branch-name` and switch to it. You can now work on your modifications.
If you want to switch back to the main branch, you can run the following command :

```bash
git checkout main
```

If you want to know which branch you are currently on, you can run the following command :

```bash
git branch
```

## Start modifying the codes and scripts

> [!NOTE]
> At any time, you can check your current git status by running the following command in your terminal :
>
> ```bash
> git status
> ```
>
> If at any time you don't know what to do, you can run the following command in your terminal : `man git` or `git help`. Git also supports tab autocompletion, so you can type `git ch` and then press the `tab` key to autocomplete the command `git checkout`.

You can now start modifying the codes and scripts in the repository. You can create new files, modify existing ones, or delete some. Once you are done with your modifications, you can commit them to your branch.

> [!WARNING]
> Before any modifications, you should always pull the latest version of the repository to make sure you are up to date with the latest changes. To do so, run the following command in your terminal :

```bash
git fetch
git pull
```

## Commit your modifications

Once you are done with your modifications, you can commit them to your branch. If you want to know which files you modified, created, or deleted, you can run the following command in your terminal :

```bash
git status
```

This will give you a list of the files you modified, created, or deleted. You can then add them to the staging area. It will also list the files that are not tracked by git yet (for example, new files you created). You can add them to the staging area as well.

To do so, in your terminal, run the following commands :

```bash
git add modified-file1 modified-file2 new-file1 deleted-file1 ...
```

This will add the files you modified, created, or deleted to the so-called staging area (you can check that by running `git status` again!). This means you are telling git that you are ready to commit the modifications done on _these files and these files only_. Thus, this doesn't apply to _*future*_ modifications, or modificatiions done on other files. This is a way to keep track of what you are doing, and selectively commit your modifications in a logical way. For example, if you are working on two different features (SleepScoring and MouseTracking), you might want to selectively stage and commit the modifications done on the SleepScoring files, and then the modifications done on the MouseTracking files. This will make a cleaner version history and will be easier to understand for everyone/go back to a previous version if needed.

If you really want to add all the modifications you made, you can run the following command in the `PrgGithub` folder (and not a subfolder):

```bash
git add .
```

**You can then commit them with the following command :**

```bash
git commit -m "Your commit message"
```

If you now run `git status` (again :) ), you will see that the files you modified, created, or deleted are no longer listed. This means they are now committed to your branch.
This can be confirmed by running the following command :

```bash
git log
```

which lists all the commits, and all the history of our codebase/repository. You will see your commit message, the author, the date, and a unique commit hash at the very top of the list!

## Push your modifications to the repository

For now on, the modifications and commits you made are only visible in your local repository! In order to make them visible to everyone, you will need to push them to the remote repository (ie the Github platform). To do so, run the following command (if you want to push to the main replace `your-branch-name` by `main`):

```bash
git push -u origin your-branch-name
```

This will push your modifications to the remote repository, and update your branch on the Github platform. This can be verified by directly checking the [repo](https://github.com/MobsLab/PrgGithub).

# Troubleshoot

### Set up the ssh keys

Go to your terminal and run the following command :

```bash
cd ~/.ssh
ssh-keygen -t ed25519 -C "your.email@espci.fr"
```

You're free to use a passphrase or not. Then, you can copy the .pub file to your github account in settings and SSH and GPG keys.

To run this time and at every reboot:

```bash
ssh-add $HOME/.ssh/id_ed25519
eval $(ssh-agent -s)
```

Check it’s working

```bash
ssh -T git@github.com
```
