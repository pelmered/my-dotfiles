# README #

Dev tools and common files for developers. Nice vagrant shortcuts, global gitignore, shuttle.json, a lot of handy aliases and more

##Setup

```
git clone https://github.com/pelmered/ZSH-Dotfiles.git ~/.dotfiles

~/.dotfiles/install.sh
```

####Add to global git config ( usually ~/.gitconfig ) 

```
[core]
        excludesfile = ~/.dotfiles/gitignore
```

####Source the dotfiles loader in your .zshrc ( ~/.zshrc )
```
source ~/.dotfiles/loader.sh
```