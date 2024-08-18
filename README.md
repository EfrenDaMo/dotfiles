# .dotfiles

A repo with my .dotfiles to keep workspace consistent

I personally use Arch but this should work on other distros and possibly Mac but i'm not sure.

## Configurations 

This repo contains multiple configurations for different tools that I use on my day to day development work flow,
most of them work completely out of the box with very few exceptions like Kanata.

Make sure you have the correspondng packages installed for the configurations you wish to use.

That being said here is a list of all the configurations in the repo:

- Zsh

- Neovim

- tmux

- Kitty

- Font

- Oh my posh

- Neofetch

## Requirements for installation 

Use your distros built-in package manager to install the following packages, 
on Arch I use pacman most of the time and Yay for files not found in pacman.

### Git

Arch:

```
$ pacman -S git.
```

### Stow

Arch:

```
$ pacman -S stow
```

### Hack Nerd Font 

Arch AUR:
```
$ yay -S ttf-hack-nerd
```

### Other dependencies 
- fzf
- zoxide
- fd
- tpm

## Installation 

Clone the repo in to your $HOME directory for best functionality

```
$ git clone https://github.com/EfrenDaMo/.dotfiles.git
$ cd .dotfiles
```

then use stow to create symlinks to your system

```
$ stow .
```
