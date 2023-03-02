### Requirements:
# xclip

### Installations
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

### Configs
bash_dir=~/.bash
cp -r .bash ~

# TODO: make a function that wraps this grep -v -q command
# these scripts (little tools) should be added to PATH
if [ -d ~/.bash/scripts ]; then
    toadd="PATH=\${PATH}:~/.bash/scripts"
    grep -v -q "$toadd" ~/.bashrc && echo "# Add my common scripts to the PATH so I don't have spend time sourcing them" >> ~/.bashrc
    grep -v -q "$toadd" ~/.bashrc && echo $toadd >> ~/.bashrc
fi

# bash configs
for bash in {aliases,history_cfg,shopt,prompt}; do
	grep -v -q $bash_dir/.bash_$bash ~/.bashrc && echo "[ -f $bash_dir/bash_$bash ] && . $bash_dir/bash_$bash" >> ~/.bashrc
done

# requirement: fzf package
if [ -f $bash_dir/.fzf.bash ]; then
	grep -v -q $bash_dir/.fzf.bash ~/.bashrc && echo "[ -f $bash_dir/.fzf.bash ] && source $bash_dir/.fzf.bash" >> ~/.bashrc
fi

git_completion_command="[ -f ~/.git-completion.bash ] && . ~/.git-completion.bash"
grep -v -q git-completion.bash ~/.bashrc && echo $git_completion_command >> ~/.bashrc

# configs
cp -r .config/* ~

# nvim config
if [ `which nvim` ]; then
    mkdir -p ~/.config
    cp -r .config/nvim ~/.config
fi

# .local executables such as youtube-dl
mkdir -p ~/.local/bin
path_string="PATH=\${PATH}:\$HOME/.local/bin"
grep -v -q ":\$HOME/.local/bin" ~/.bashrc && echo $path_string >> ~/.bashrc

# other configs
cp .gitconfig ~
cp .inputrc ~
cp .gdbinit ~

# ranger config
#if [ `which ranger` ]; then
	# see https://github.com/alexanderjeurissen/ranger_devicons
	#git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
	#echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf
#fi
