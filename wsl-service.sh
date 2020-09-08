##binddir##for d in $( ls /mnt) ;
##binddir##do
##binddir##    mount --bind /mnt/$d /$d;
##binddir##done ;


for i in $(pstree -np -s $$ | grep -o -E '[0-9]+'); do
    if [[ -e "/run/WSL/${i}_interop" ]]; then
        export WSL_INTEROP=/run/WSL/${i}_interop
    fi
done

wsl.exe -d sdc-drive
wsl.exe -d sdd-drive

systemctl start sshd


mount /dev/sdc /mnt/personal
mount /dev/sdd /mnt/develop
mount -t cifs //10.239.23.100/confidential /mnt/y/ -ousername=di7979.kim,pass=1q2w3e4r%,iocharset=utf8


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
tmux send -t  sage "sage -n  jupyter  --ip '0.0.0.0'  --allow-root" ENTER




##tmux send -t  powershell "net use * /del"                                                        ENTER
##too-slow##tmux send -t  powershell "net use \\\\10.239.23.100\\confidential /USER:di7979.kim 1q2w3e4r%" ENTER
##too-slow##sleep 3
##too-slow##tmux send -t  powershell "net use y: \\\\10.239.23.100\\confidential"                            ENTER
##too-slow##sleep 3

LOCALIP=$(ifconfig eth0 | grep "netmask" | awk '{print $2}')
#usewindowterminal#tmux send -t  powershell "c:\\usr\\local\\iputty\\putty.exe -load OPA0 -ssh root@${LOCALIP}  -pw root" ENTER
#usewindowterminal#sleep 3

JUPYTERLINK=$(jupyter notebook list | grep "http" | awk -e '{print $1}' | sed -e "s/0.0.0.0/${LOCALIP}/")
tmux send -t  powershell "t:\\usr\\local\\firefox\\firefox.exe ${JUPYTERLINK} " ENTER
