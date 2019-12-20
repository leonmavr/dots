## This setup
Based around Arch, i3-gaps window manager, termite terminal emulator running Bash and Polybar.

## Usage
This repository contains dotfiles for various setups.  
The top level contains files that can be used in any setup and the subdirectories contain specific ones.  

To use them, simply copy them in your system, assuming that this repository is the home directory.  
Vim plugins and configs can be installed by their own installler script.

## Things I want my setup to include
- [x] Set i3 config (key bindings etc.)
- [x] Good vim configuration with syntax checking, auto-complete etc.
- [x] Window options - gap distance, key bindings etc.
- [x] Appearance - terminal fonts, system fonts, etc.
- [x] conky (system info display) on wallpaper - partially done
- [x] window composition manager options (comption)
- [x] Better .bashrc
- [x] Better terminal options (termite config)
- [x] Status bar (polybar) - TODO: add current song
- [x] Program launcher (rofi)
- [ ] ~~Ranger file manager options - add key bindings and work with sxiv~~
- [x] Photo viewer (sxiv) - also add hotkeys
- [x] Music player (mpd) options and control music from status line
- [x] cava music visualiser
- [ ] configure mutt for gmail
- [x] redshift (night light) options
- [x] lock screen



## Application screenshots

| Application | Output | Relevant repo files | Dependancies
| ------------- | ------------- | -------------| ------------- |
| conky (system monitor) | ![alt text](https://raw.githubusercontent.com/0xLeo/assets/master/dotfiles/arch-i3-gaps/conky_04-07-19.png)  | <ul><li>https://github.com/0xLeo/dotfiles/tree/master/arch-i3-gaps/.config/conky</li><li>https://github.com/0xLeo/dotfiles/tree/master/arch-i3-gaps/.lua/scripts</li></ul> | <ul><li>conky</lu><li>lua</li><li>conky-lua</li><li>jq</li><li>remind</li><li>Font Awesome</li></ul> |
| vim  | ![alt text](https://raw.githubusercontent.com/0xLeo/assets/master/dotfiles/arch-i3-gaps/vim_22-05-19.png)  | <ul><li>https://github.com/0xLeo/dotfiles/blob/master/.vimrc</li><li>https://github.com/0xLeo/dotfiles/blob/master/vim_setup.sh</li></ul>| Explained in installer script | 
| polybar (status bar)  | ![alt text](https://raw.githubusercontent.com/0xLeo/assets/master/dotfiles/arch-i3-gaps/polybar.png)  | https://github.com/0xLeo/dotfiles/tree/master/arch-i3-gaps/.config/polybar| <ul><li>font awesome</li><li>ttf-material-design-icons</li><li>jq</li><li>rofi</li><li>yad</li><li>remind</li></ul> | 
| cava (music visualiser)  | ![alt text](https://raw.githubusercontent.com/0xLeo/assets/master/dotfiles/arch-i3-gaps/cava_04-07-19.png)  | https://github.com/0xLeo/dotfiles/tree/master/arch-i3-gaps/.config/cava | <ul><li>[cava](https://github.com/karlstav/cava)</li></ul> | 
| compton (window compositor) | ![alt text](https://raw.githubusercontent.com/0xLeo/assets/master/dotfiles/arch-i3-gaps/compton_04-07-19.png)  | <ul><li>(opacity only) https://github.com/0xLeo/dotfiles/blob/master/arch-i3-gaps/.compton</li><li>(blur) https://github.com/0xLeo/dotfiles/tree/master/arch-i3-gaps/.config/compton</li></ul> | <ul><li>(if you want blur) [tyrone144's fork](https://github.com/tryone144/compton)</li></ul> | 
| i3-gaps (window manager) | TODO  | ![alt text](https://github.com/0xLeo/dotfiles/blob/arch-i3-gaps/.config/i3/config) | <ul><li>wpa_supplicant (pacman)</li><li>wireless_tools (pacman)</li><li>networkmanager (pacman)</li><li>network-manager-applet (pacman)</li><li>gnome-keyring (pacman)</li><li>gnome-keyring (pacman)</li><li>xev</li><li>other optional startup programs; see my config</li></ul> | 


## System maintanance tips/ issues
* `light` and `acpilight` conflict, meaning that they use the same rules file. For example, if `light` is installed and you try to install `acpilight` the following error is shown. If you have both of them, they also break the update (`pacman -Syu`).
```
acpilight: /usr/lib/udev/rules.d/90-backlight.rules exists in filesystem (owned by light)
```
* I like to use keyboard keys to change my brightness, but `light` needs admin rights and password. To remove the need for password, use visudo and add the following line:
```
# visudo
yourusername ALL=(ALL) NOPASSWD: /usr/bin/light
```
* Run `pacman -Sc` once in a while to remove old cached versions of installed packages.
* Slow wifi
If this is grepped:
```
$ dmesg | grep firmw
[    5.099057] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
```
or this iw command outputs something like this:
```
$ iw reg get
global
country 00: DFS-UNSET
```
Then you need to set your regdb, for example as:
```
$ sudo iw reg set DE
```
Finally, restart the wifi.
