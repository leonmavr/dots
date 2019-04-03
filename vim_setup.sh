usage_str="Requirements for this setup:\n *exuberant-ctags\n* clang\n* libclang-dev\n* cmake\n* python-dev\n* python3-dev\n* wget\notherwise it will not work.\nIt will also delete your current .vimrc so it's better to keep a backup.\n"
printf "$usage_str"
read -p "Are you ready to proceed? (y/n) " start
case $start in
[Nn]* ) exit;;
esac
# need ctags, clang, cmake python-dev, python3-dev, wget, vim compile with python support
echo "Setting up directories..."
rm -f ~/.virmc
mkdir -p ~/.vim ~/.vim/bundle ~/.vim/colors ~/.vim/autoload
echo "Installing Pathogen..."
wget https://tpo.pe/pathogen.vim -O ~/.vim/autoload/pathogen.vim
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
#echo "Installing YouCompleteMe..."
#git clone https://github.com/Valloric/YouCompleteMe ~/.vim/bundle/YouCompleteMe
#cd ~/.vim/bundle/YouCompleteMe
#git submodule update --init --recursive
# --clang-completer didn't work for me, needs --system-libclang and fairly recent clang installed
#./install.py --clang-completer --system-libclang
#printf "def FlagsForFile( filename, **kws ):\n return {\n 'flags': [ '-x', 'c++', '-Wall', '-Wextra', '-Werror' ],\n }\n" >> ~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py
cd ~/.vim/bundle
echo "Installing UltiSnips..."
git clone https://github.com/SirVer/ultisnips ~/.vim/bundle/ultisnips
vim +Helptags +qall
echo "Installing SnipMate"
git clone https://github.com/tomtom/tlib_vim.git
git clone https://github.com/MarcWeber/vim-addon-mw-utils.git
git clone https://github.com/garbas/vim-snipmate.git
git clone https://github.com/honza/vim-snippets.git
vim +Helptags +qall
echo "Installing clangc-complete"
git clone https://github.com/Rip-Rip/clang_complete
vim +Helptags +qall
hwplat=`uname -i`
cd /usr/lib/${hwplat}-linux-gnu
sudo ln -s libclang-*-so.* libclang.so
cd ~/.vim/bundle/clang_complete
make install
cd
echo "Installing Twilight theme..."
wget "https://www.vim.org/scripts/download_script.php?src_id=10496" -O ~/.vim/colors/twilight.vim
wget "https://www.vim.org/scripts/download_script.php?src_id=14937" -O ~/.vim/colors/twilight256.vim
echo "Adding vimrc..."
wget "https://raw.githubusercontent.com/0xLeo/dotfiles/master/.vimrc" -O ~/.vimrc
sed -i "s/i386-linux-gnu/${hwplat}-linux-gnu/g" .vimrc
echo "Setup complete."
