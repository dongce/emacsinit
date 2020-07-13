##binddir##for d in $( ls /mnt) ;
##binddir##do
##binddir##    mount --bind /mnt/$d /$d;
##binddir##done ;


mount /dev/sdc /mnt/personal
mount /dev/sdd /mnt/develop

cat /etc/resolv.conf | grep "nameserver" | awk '{print $2"\t"$1}' >> /etc/hosts

tmux new-session -s powershell -d
sleep 5
tmux send -t  powershell "cd /mnt/c/Windows/System32/WindowsPowerShell/v1.0/" ENTER
sleep 3
tmux send -t  powershell "./powershell.exe -NoExit -Command  Remove-Module -Name PSReadline" ENTER
sleep 3



tmux send -t  powershell  "start-process -filepath \"C:/program files/Elecom_Mouse_Driver/ElcMouseApl.exe\"" ENTER
sleep 3
tmux send -t  powershell  "start-process -filepath \"t:/usr/local/ahk/AutoHotkeyU64.exe\"" ENTER
sleep 3
tmux send -t  powershell  "start-process -filepath \"t:/usr/local/wtms/WTMS_Client_v0.3.exe\" -WorkingDirectory \"t:/usr/local/wtms/\" " ENTER

sleep 3

tmux send -t  powershell "echo DONE" ENTER


#/opt/local/bin/mu init  --my-address=di7979.kim@hanwhasystems.com --maildir=/mnt/f/PERSONAL/2020/$(date +%m)
/opt/local/bin/mu index --nocleanup --lazy-check
tmux new-session -s imapget -d
tmux send -t  imapget "cd /mnt/develop/misc/eaglemail" ENTER
tmux send -t  imapget "export TMPDIR=/tmp/" ENTER
tmux send -t  imapget "/opt/anaconda3/bin/python3 imapget.py" ENTER


tmux new-session -s sage -d
tmux send -t  sage "cd ~" ENTER
tmux send -t  sage "conda activate sage" ENTER
tmux send -t  sage "sage -n jupyter --allow-root" ENTER




##tmux send -t  powershell "net use * /del"                                                        ENTER
tmux send -t  powershell "net use \\\\10.239.23.100\\confidential /USER:di7979.kim 1q2w3e4r%" ENTER
sleep 3
tmux send -t  powershell "net use y: \\\\10.239.23.100\\confidential"                            ENTER
sleep 3
