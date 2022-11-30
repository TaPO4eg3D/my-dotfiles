#!/bin/sh

# session=${1:-awesome}

# case $session in
#     awesome     )
#         # Setting Russian and English keyboard layouts
#         setxkbmap -layout us,ru
#         setxkbmap -option 'grp:alt_shift_toggle'

#         exec awesome;;
#     kde         )
#         export DESKTOP_SESSION=plasma
#         exec startplasma-x11;;
#     *           ) exec $1;;
# esac

# Setting Russian and English keyboard layouts
setxkbmap -layout us,ru
setxkbmap -option 'grp:alt_shift_toggle'

# Support for NVIDIA Optimus
/usr/bin/prime-offload
awesome
# export DESKTOP_SESSION=plasma
# exec startplasma-x11
sudo /usr/bin/prime-switch
