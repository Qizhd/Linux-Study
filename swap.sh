(.*)
     export HISTFILE=~/.bash_history
     history -a	     history -a
     history -r	     history -r
-    history | sed -e 's/uemcli\([^&|;]\+\)-p[ \t]\+[^ \t]*/uemcli\1 -p ***/g' > $HIST_OUTPUT_DIR/`whoami`$HPOSTFIX	+    history | sed -e 's/uemcli\([^&|;]\+\)-p[ \t]\+[^ \t]*/uemcli\1 -p ***/g' |sed -E 's/(.*)#([0-9]+)/echo "\1Execution time:" `date -d @\2`/e' > $HIST_OUTPUT_DIR/`whoami`$HPOSTFIX
bash是在子进程执行，但是为啥在本控制台输出？
/etc/fstab



dc overview
expect



#!/usr/bin/expect

##############################################################################
# Transfer file via sftp
# Return code: 0 success, 1 invalid arguments, 2 command timeout, 3 sftp error
##############################################################################

if {$argc != 4} {
    exit 1
}

set SERVER [lindex $argv 0]
set USER [lindex $argv 1]
set PASSWD [lindex $argv 2]
set FILE [lindex $argv 3]

spawn sftp -o ServerAliveInterval=10 -o ServerAliveCountMax=1 -o ConnectTimeout=10 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR ${USER}@${SERVER}

set timeout 12
expect {
    timeout { exit 2 }
    eof { exit 3 }
    "Password:" { send "${PASSWD}\r" }
}

expect {
    timeout { exit 2 }
    eof { exit 3 }
    -re "sftp>\\s*$" { send "put ${FILE}\r" }
}

set result 0
set timeout 20
expect {
    timeout { exit 2 }
    eof { exit 3 }
    -re "Uploading.*?sftp>\\s*$" { send "bye\r" }
    -re "sftp>\\s*$" { send "bye\r"; set result 3 }
}

set timeout 12
expect eof
exit $result












