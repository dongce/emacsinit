##binddir##for d in $( ls /mnt) ;
##binddir##do
##binddir##    mount --bind /mnt/$d /$d;
##binddir##done ;


tmux new-session -s powershell -d
sleep 5
tmux send -t  powershell "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -NoExit -Command  Remove-Module -Name PSReadline" ENTER

##tmux send -t  powershell "(New-Object -ComObject WScript.Network).RemoveNetworkDrive(\"Y:\")" ENTER
##
##tmux send -t  powershell "(New-Object -ComObject WScript.Network).MapNetworkDrive(\"Y:\", \"\\\\10.239.12.100\\confidential\" , False, \"di7979.kim\", \"godid2013!@#\")" ENTER

##tmux send -t  powershell "net use * /del"                                                        ENTER
tmux send -t  powershell "net use \\\\10.239.23.100\\confidential /USER:di7979.kim 1q2w3e4r%" ENTER
tmux send -t  powershell "net use y: \\\\10.239.23.100\\confidential"                            ENTER


tmux send -t  powershell  "start-process -filepath \"C:/program files/Elecom_Mouse_Driver/ElcMouseApl.exe\"" ENTER
tmux send -t  powershell  "start-process -filepath \"t:/usr/local/ahk/AutoHotkeyU64.exe\"" ENTER
tmux send -t  powershell  "start-process -filepath \"t:/usr/local/wtms/WTMS_Client_v0.3.exe\" -WorkingDirectory \"t:/usr/local/wtms/\" " ENTER


tmux send -t  powershell "echo DONE" ENTER


#/opt/local/bin/mu init  --my-address=di7979.kim@hanwhasystems.com --maildir=/mnt/f/PERSONAL/2020/$(date +%m)
/opt/local/bin/mu index --nocleanup --lazy-check
tmux new-session -s imapget -d
tmux send -t  imapget "cd /mnt/t/misc/eaglemail" ENTER
tmux send -t  imapget "/opt/anaconda3/bin/python3 imapget.py" ENTER
