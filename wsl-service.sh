##binddir##for d in $( ls /mnt) ;
##binddir##do
##binddir##    mount --bind /mnt/$d /$d;
##binddir##done ;

LOCALIP=$(ifconfig eth0 | grep "netmask" | awk '{print $2}')

systemctl start sshd

mount /dev/sdd /mnt/personal
mount /dev/sde /mnt/develop
mount --bind /mnt/c/Users/di7979.kim/Downloads /root/Downloads
mount -t cifs //10.239.23.100/confidential /mnt/y/ -ousername=di7979.kim,pass=1q2w3e4r%,iocharset=utf8

mkdir -p /run/httpd
chmod -R 777 /run
systemctl start httpd

cat /etc/resolv.conf | grep "nameserver" | awk '{print $2"\t"$1}' >> /etc/hosts

######################## imapget ####################
#/opt/local/bin/mu init  --my-address=di7979.kim@hanwhasystems.com --maildir=/mnt/personal/mail/
/opt/local/bin/mu index --nocleanup --lazy-check
tmux new-session -s imapget -d
tmux send -t  imapget "cd /mnt/develop/misc/hanwhamail" ENTER
tmux send -t  imapget "export TMPDIR=/tmp/" ENTER
tmux send -t  imapget "/opt/anaconda3/bin/python3 imapget.py" ENTER


######################## sage ####################

tmux new-session -s sage -d
tmux send -t  sage "cd ~" ENTER
tmux send -t  sage "conda activate sage" ENTER
tmux send -t  sage "sage -n  jupyter  --ip '0.0.0.0'  --allow-root" ENTER


mkdir /run/samba
chmod -R 0755 /run/samba
systemctl start smb


while true ; do
    JUPYTERLINK=$(jupyter notebook list | grep "http" | awk -e '{print $1}' | sed -e "s/0.0.0.0/${LOCALIP}/")
    if [ -z "$JUPYTERLINK" ]
    then
        sleep 5
    else
        break
    fi
done



tmux new-session -s powershell -d
sleep 5
tmux send -t  powershell "cd /mnt/c/Windows/System32/WindowsPowerShell/v1.0/" ENTER
sleep 5
tmux send -t  powershell "./powershell.exe \"v:/site-wsl/pwsh-init.ps1 ${LOCALIP} ${JUPYTERLINK}\" " ENTER
