for d in $( ls /mnt) ;
do
    mount --bind /mnt/$d /$d;
done ;


tmux new-session -s powershell -d
tmux send -t  powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe" ENTER
tmux send -t  powershell "Remove-Module -Name PSReadline" ENTER

tmux new-session -s imapget -d
tmux send -t  imapget "cd /mnt/t/misc/eaglemail" ENTER
tmux send -t  imapget "/opt/python38/bin/python3 imapget.py" ENTER