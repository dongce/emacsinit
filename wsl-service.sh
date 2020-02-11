for d in $( ls /mnt) ;
do
    mount --bind /mnt/$d /$d;
done ;


tmux new-session -s powershell -d
sleep 5
tmux send -t  powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoExit -Command  Remove-Module -Name PSReadline" ENTER
tmux send -t  powershell "echo DONE" ENTER


/opt/local/bin/mu index -v --nocolor --maildir /mnt/f/PERSONAL/2020/$(date +%m)
tmux new-session -s imapget -d
tmux send -t  imapget "cd /mnt/t/misc/eaglemail" ENTER
tmux send -t  imapget "/opt/anaconda3/bin/python3 imapget.py" ENTER
