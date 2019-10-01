#!/bin/bash

 
#----------------------------------------------------------#
# Preparation
#----------------------------------------------------------#
usage_str="Requirements for this setup:\n* exuberant-ctags (ctags)\n* clang\n* libclang-dev\n* cmake\n* python-dev\n* python3-dev\n* wget\notherwise it will not work.\nIt will also delete your current .vimrc so it's better to keep a backup.\nKeeping a backup anyway at /tmp/.vimrc.\n\n"
cp ~/.vimrc /tmp/.vimrc 2 > /dev/null
printf "$usage_str"
read -p "Are you ready to proceed? (y/n) " start
case $start in
    [Nn]* ) exit;;
esac

echo "Setting up directories..."
rm -f ~/.virmc
mkdir -p ~/.vim ~/.vim/bundle ~/.vim/colors ~/.vim/autoload


#----------------------------------------------------------#
# Plugins
#----------------------------------------------------------#
echo "Installing Pathogen..."
wget "https://www.vim.org/scripts/download_script.php?src_id=19375" -O ~/.vim/autoload/pathogen.vim

echo "Installing Syntastic..."
cd ~/.vim/bundle && \
git clone --depth=1 https://github.com/vim-syntastic/syntastic.git
echo "execute pathogen#infect()" >> ~/.vimrc
vim +Helptags +qall

echo "Installlig NERDTree..."
git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
vim +Helptags ~/.vim/bundle/nerdtree/doc/ +qall

echo "Installing CtrlP..."
cd ~/.vim
git clone https://github.com/kien/ctrlp.vim.git bundle/ctrlp.vim
vim +helptags ~/.vim/bundle/ctrlp.vim/doc +qall
echo "Configuring ctags..."
echo "set tags=tags" >> ~/.vimrc

echo "Installing Jedi..."
git clone --recursive https://github.com/davidhalter/jedi-vim.git ~/.vim/bundle/jedi-vim

echo "Installing TagBar..."
git clone https://github.com/majutsushi/tagbar ~/.vim/bundle/tagbar

echo "Installing airline..."
git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
vim +helptags ~/.vim/bundle/ctrlp.vim/doc +qall
cd ~/.vim/bundle

echo "Installing UltiSnips..."
git clone https://github.com/SirVer/ultisnips ~/.vim/bundle/ultisnips
vim +Helptags +qall

echo "Installing SnipMate..."
git clone https://github.com/tomtom/tlib_vim.git
git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
git clone https://github.com/garbas/vim-snipmate.git
git clone https://github.com/honza/vim-snippets.git
vim +Helptags +qall

echo "Installing clangc-complete..."
git clone https://github.com/Rip-Rip/clang_complete
vim +Helptags +qall
hwplat=`uname -i | sed "s/i686/i386/g"`
cd /usr/lib/${hwplat}-linux-gnu
sudo ln -s libclang-*-so.* libclang.so
cd ~/.vim/bundle/clang_complete
make install

echo "Installing Goyo..."
git clone https://github.com/junegunn/goyo.vim ~/.vim/bundle/goyo.vim
vim +Helptags +qall

echo "Installing Airline themes..."
git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
vim +Helptags +qall
cd /tmp
git clone https://github.com/powerline/fonts
cd fonts
./install.sh


#----------------------------------------------------------#
# Themes and appearance
#----------------------------------------------------------#
cd
echo "Installing colour schemes..."
wget "https://www.vim.org/scripts/download_script.php?src_id=10496" -O ~/.vim/colors/twilight.vim
wget "https://raw.githubusercontent.com/0xLeo/nighted.vim/master/colors/nighted.vim" -O ~/.vim/colors/nighted.vim
wget "https://raw.githubusercontent.com/wolf-dog/nighted.vim/master/colors/nighted.vim" ~/.vim/colors/nighted.vim
wget "https://www.vim.org/scripts/download_script.php?src_id=14937" -O ~/.vim/colors/twilight256.vim
echo "Adding vimrc..."
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.vimrc" -O ~/.vimrc
sed -i "s/i386-linux-gnu/${hwplat}-linux-gnu/g" .vimrc

# fix clang library path for Ubuntu
[ ! -z `cat /etc/os-release | grep ^ID= | grep ubuntu` ] && clang_dir=`ls /usr/lib/llvm-*/lib -d`
[ ! -z $clang_dir ] && sed -i "/clang_library_path/c\let g:clang_library_path = \'$clang_dir\'" ~/.vimrc 

echo "Setup complete."
