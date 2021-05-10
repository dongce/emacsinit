##binddir##for d in $( ls /mnt) ;
##binddir##do
##binddir##    mount --bind /mnt/$d /$d;
##binddir##done ;

LOCALIP=$(ifconfig eth0 | grep "netmask" | awk '{print $2}')

systemctl start sshd

mount /dev/sdd /mnt/personal
mount /dev/sde /mnt/develop
mount -t cifs //10.239.23.100/confidential /mnt/y/ -ousername=di7979.kim,pass=1q2w3e4r%,iocharset=utf8

mkdir -p /run/httpd
chmod -R 777 /run
systemctl start httpd

cat /etc/resolv.conf | grep "nameserver" | awk '{print $2"\t"$1}' >> /etc/hosts

tmux new-session -s powershell -d
sleep 5
tmux send -t  powershell "cd /mnt/c/Windows/System32/WindowsPowerShell/v1.0/" ENTER
sleep 3
tmux send -t  powershell "./powershell.exe -NoExit -Command  Remove-Module -Name PSReadline" ENTER
sleep  10

tmux send -t  powershell "t:/usr/local/powershell/Edit-hostsfile.ps1 -RemoveHost -hostname fedora33.wsl" ENTER
tmux send -t  powershell "t:/usr/local/powershell/Edit-hostsfile.ps1 -RemoveHost -hostname wolfram.fedora33.wsl" ENTER
tmux send -t  powershell "t:/usr/local/powershell/Edit-hostsfile.ps1 -RemoveHost -hostname python.fedora33.wsl" ENTER
tmux send -t  powershell "t:/usr/local/powershell/Edit-hostsfile.ps1 -AddHost -ip ${LOCALIP} -hostnam fedora33.wsl" ENTER
tmux send -t  powershell "t:/usr/local/powershell/Edit-hostsfile.ps1 -AddHost -ip ${LOCALIP} -hostnam wolfram.fedora33.wsl" ENTER
tmux send -t  powershell "t:/usr/local/powershell/Edit-hostsfile.ps1 -AddHost -ip ${LOCALIP} -hostnam python.fedora33.wsl" ENTER



tmux send -t  powershell  "start-process -filepath \"C:/program files/Elecom_Mouse_Driver/ElcMouseApl.exe\"" ENTER
sleep 3
tmux send -t  powershell  "start-process -filepath \"t:/usr/local/ahk/AutoHotkeyU64.exe\"" ENTER
sleep 3
tmux send -t  powershell  "start-process -filepath \"t:/usr/local/wtms/WTMS_Client_v0.3.exe\" -WorkingDirectory \"t:/usr/local/wtms/\" " ENTER
sleep 3

tmux send -t  powershell  "start-process -filepath \"t:/usr/local/qdir/Q-Dir_x64.exe\" " ENTER
sleep 3

tmux send -t  powershell  "start-process -filepath \"d:/usr/local/xmanager/Xmanager.exe\" " ENTER
sleep 3

tmux send -t  powershell "echo DONE" ENTER


#/opt/local/bin/mu init  --my-address=di7979.kim@hanwhasystems.com --maildir=/mnt/personal/mail/
/opt/local/bin/mu index --nocleanup --lazy-check
tmux new-session -s imapget -d
tmux send -t  imapget "cd /mnt/develop/misc/hanwhamail" ENTER
tmux send -t  imapget "export TMPDIR=/tmp/" ENTER
tmux send -t  imapget "/opt/anaconda3/bin/python3 imapget.py" ENTER


tmux new-session -s sage -d
tmux send -t  sage "cd ~" ENTER
tmux send -t  sage "conda activate sage" ENTER
tmux send -t  sage "sage -n  jupyter  --ip '0.0.0.0'  --allow-root" ENTER


mkdir /run/samba
chmod -R 0755 /run/samba
systemctl start smb

#compiler#fuse-zip -o ro /mnt/develop/compiler/GNAT.zip /opt/GNAT
#compiler#fuse-zip -o ro /mnt/develop/compiler/poky-lsb.zip /opt/poky-lsb
#compiler#fuse-zip -o ro /mnt/develop/compiler/Buildbot.zip /home/Buildbot

##tmux send -t  powershell "net use * /del"                                                        ENTER
##too-slow##tmux send -t  powershell "net use \\\\10.239.23.100\\confidential /USER:di7979.kim 1q2w3e4r%" ENTER
##too-slow##sleep 3
##too-slow##tmux send -t  powershell "net use y: \\\\10.239.23.100\\confidential"                            ENTER
##too-slow##sleep 3

#usewindowterminal#tmux send -t  powershell "c:\\usr\\local\\iputty\\putty.exe -load OPA0 -ssh root@${LOCALIP}  -pw root" ENTER
#usewindowterminal#sleep 3

while true ; do
    JUPYTERLINK=$(jupyter notebook list | grep "http" | awk -e '{print $1}' | sed -e "s/0.0.0.0/${LOCALIP}/")
    if [ -z "$JUPYTERLINK" ]
    then
        sleep 5
    else
        break
    fi
# tmux send -t  powershell "t:\\usr\\local\\firefox\\firefox.exe ${JUPYTERLINK} " ENTER
done

tmux send -t  powershell "start ${JUPYTERLINK} " ENTER
sleep 3
tmux send -t  powershell "start http://wolfram.fedora33.wsl/language/index.html " ENTER
sleep 5
tmux send -t  powershell "net use x: \\\\fedora33.wsl\\develop"                            ENTER
sleep 5
tmux send -t  powershell "net use p: \\\\fedora33.wsl\\personal"                            ENTER
sleep 5
