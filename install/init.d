#!/bin/sh

### BEGIN INIT INFO
# Provides:          god
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog 
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: start god process monitoring
# Description:       Start god process monitoring
### END INIT INFO

#
# God init.d (startup) script 
#
# save this file as /etc/init.d/god
# make it executable:
#    chmod +x /etc/init.d/god
# Tell the os to run the script at startup:
#    sudo /usr/sbin/update-rc.d -f god defaults
#
# Also consider adding this line (kills god weekly) to your crontab (sudo crontab -e):
#
#    # deicide is painless
#    0 1 * * 0 god quit; sleep 1; killall god; sleep 1; killall -9 god; sleep 1; /etc/init.d/god start
# 

RETVAL=0
god_location="/usr/local/rvm/bin/bootup_god"
god_conf="/home/pi/god.conf"
god_pid_file="/var/run/god/god.pid" ; mkdir -p `dirname $god_pid_file`
god_log_file="/var/log/god/god.log" ; mkdir -p `dirname $god_log_file`

# Uncomment the line below to log output of this script to a file
#exec > /var/log/god/initlog 2>&1 # Log output to initlog

case "$1" in
  start)
    $god_location -c "$god_conf" -P "$god_pid_file" -l "$god_log_file"
    #usr/local/bin/god -c "$god_conf" -P "$god_pid_file" -l "$god_log_file"
    RETVAL=$?
    echo "God started"
    ;;
  stop)
    (kill `cat $god_pid_file` 2>&1) >/dev/null
    #kill `cat $god_pid_file`
    RETVAL=$?
    echo "God stopped"
    ;;
  restart)
    (kill `cat $god_pid_file` 2>&1) >/dev/null
    #kill `cat $god_pid_file`
    $god_location -c "$god_conf" -P "$god_pid_file" -l "$god_log_file"
    #usr/local/bin/god -c "$god_conf" -P "$god_pid_file" -l "$god_log_file"
    RETVAL=$?
    echo "God restarted"
    ;;
  status)
    RETVAL=$?
    ;;
  *)
    echo "Usage: god {start|stop|restart|status}"
    exit 1
    ;;
esac

exit $RETVAL

