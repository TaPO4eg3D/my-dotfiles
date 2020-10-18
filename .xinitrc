#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

twm &
xclock -geometry 50x50-1+1 &
xterm -geometry 80x50+494+51 &
xterm -geometry 80x20+494-0 &

# Setting Russian and English keyboard layouts
setxkbmap -layout us,ru
setxkbmap -option 'grp:alt_shift_toggle'

# Manage my home two monitors + TV setup
XRANDR_OUTPUT=`xrandr --listactivemonitors`

if [[ $XRANDR_OUTPUT =~ "HDMI-0" ]] &&
   [[ $XRANDR_OUTPUT =~ "DVI-D-0" ]] &&
   [[ $XRANDR_OUTPUT =~ "DP-1" ]]; then
  echo "Setting up two monitors + TV..."
  xrandr --output HDMI-0 --primary --auto
  xrandr --output DVI-D-0 --right-of HDMI-0 --auto
  xrandr --output DP-1 --same-as HDMI-0 --auto
fi

if [[ $XRANDR_OUTPUT =~ "HDMI2" ]] &&
   [[ $XRANDR_OUTPUT =~ "HDMI3" ]]; then
  echo "Setting up just two monitors..."
  xrandr --output HDMI2 --primary --auto
  xrandr --output HDMI3 --right-of HDMI2 --auto
fi

# Launcing compositor for transparancy
picom &
# Launching notifaction manager
dunst &

# Setting up a background
bgchange &

exec dwm
