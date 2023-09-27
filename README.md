#dotfiles

#VIM configuration

#prerequisits
yarnpkg

```bash
#rm -rf ~/.vim
cp -r .vim/ ~/
vim -c PluginInstall
cd ~/.vim/bundle/coc.nvim && yarn install && cd -
```


# Thinkpad configuration (https://wiki.archlinux.org/title/Mouse_acceleration)
## TrackPoing:
# List
xinput list | grep -i trackpoint
xinput list-props 15 # TRACKPOINT_ID
# Trackpoint acceleration:
xinput --set-prop 'TPPS/2 IBM TrackPoint' "libinput Accel Speed" 1
#Permanent settings:
sudo vim /etc/X11/xorg.conf.d/99-libinput-custom-config.conf
```
Section "InputClass"
  Identifier "TrackPoint"
  MatchDriver "libinput"
  MatchProduct "TPPS/2 IBM TrackPoint"
  Option "AccelSpeed" "1"
EndSection
```
#slim login themes:
https://github.com/adi1090x/slim_themes.git
