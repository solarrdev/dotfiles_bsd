#!/bin/ksh
#basic OpenBSD setup script

#login as root, modify /etc/doas.conf and add USER to wheel group
#permit persist :wheel
#usermod -G wheel USER

#install packages
export PKG_PATH=https://ftp.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -m)
doas pkg_add -v vim hack-fonts zsh bash git dmenu

#adjust daemons and services
doas rcctl enable xenodm

#set zsh as shell
chsh -s $(which zsh)

#clone oh-my-zsh and custom plugins
git clone http://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/robobenklein/zdharma-history-search-multi-word .oh-my-zsh/custom/plugins/history-search-multi-word
git clone https://github.com/zsh-users/zsh-history-substring-search.git .oh-my-zsh/custom/plugins/zsh-history-substring-search 
git clone https://github.com/CaffeineViking/vimrc.git ~/.vim_temp
#cd ~/.vim_temp && sed -i 's/bash/ksh/g' setup.sh 
#./setup.sh && cd ~ && rm -rf ~/.vim_temp

#copy config files
#cp -v ~/dotfiles_bsd/{.xsession,.Xresources,.zshrc,.tmux.conf,.statusbar.sh} $HOME

#download ports tree
cd /tmp
ftp https://cdn.openbsd.org/pub/OpenBSD/$(uname -r)/{ports.tar.gz,SHA256.sig}
signify -Cp /etc/signify/openbsd-$(uname -r | sed 's/\.//')-base.pub -x SHA256.sig ports.tar.gz
cd /usr
doas tar xzf /tmp/ports.tar.gz

#install font-awesome
cd /usr/ports/fonts/font-awesome
doas make install

#install dwm
cd /usr/ports/x11/dwm
doas make patch
doas cp -v ~/export/config.h /usr/ports/pobj/dwm-6.2/dwm-6.2/
cd `make show=WRKDIST`
doas make
doas make install