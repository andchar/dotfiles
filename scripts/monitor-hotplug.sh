#!/bin/bash
: '''
##################### README ################################################

#### 1. ADD udev rule to run the script when monitor is connected ###########

####### !!! Change username /home/USERNAME/.Xauthority !!! ##################
####### run this command as regular user to keep XAUTHORITY environment variable
sudo -E tee /etc/udev/rules.d/93-monitor-hotplug.rules > /dev/null <<EOF
ACTION=="change", SUBSYSTEM=="drm",ENV{DISPLAY}=":0", ENV{XAUTHORITY}="${XAUTHORITY}", RUN+="/usr/bin/sh -c '/opt/scripts/monitor-hotplug.sh'"
EOF

#### 2. Move this script to the /opt/scripts/monitor-hotplug.sh ############

change SECOND_MONITOR variable to your external monitor

#### 3. Move this script to the /opt/scripts/monitor-hotplug.sh ############

sudo cp ~/dotfiles/scripts/monitor-hotplug.sh /opt/scripts/

#### 4. Reload udev rules ##################################################

sudo udevadm control --reload

#### Commands for debugging: ###############################################
# Monitor add/remove/change events for monitors:
udevadm monitor -u -s drm
'''

# Log file
LOGFILE="/var/log/monitor-setup.log"

LEFT_MONITOR="DP2-9"

# Detect if the second monitor is connected

# sleep 1
SECOND_MONITOR=$(xrandr | grep "$LEFT_MONITOR connected")
echo "$(printenv ACTION)" >> $LOGFILE
echo "$(printenv DISPLAY)" >> $LOGFILE

if [[ -n "$SECOND_MONITOR" ]]; then
  # If the second monitor is connected, enable it
  xrandr --output $LEFT_MONITOR --auto --primary --left-of eDP1 >> $LOGFILE 2>&1
else
  # If the second monitor is not connected, disable it
  xrandr --output $LEFT_MONITOR --off >> $LOGFILE 2>&1
fi

echo "$(xrandr --listmonitors)" >> $LOGFILE
