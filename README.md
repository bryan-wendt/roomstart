# RoomStart
Script to configure folders and start a scan on a server

[My Blog](https://bryanwendt.wordpress.com)  
[TryHackMe Profile](https://tryhackme.com/p/beedubz)

Inspiration:  
&nbsp;&nbsp;&nbsp;https://twitter.com/Theonly_Hoff  
&nbsp;&nbsp;&nbsp;https://github.com/evildrummer/RoomPrepper  

## Usage
`./room_start.sh`  

Script assumes you have nmap or rustscan installed.  
Current `rustscan` command is installed via docker. Feel free to change command if needed.

Scanning command variables:  
`RUST_CMD="sudo docker run -it --rm --name rustscan rustscan/rustscan -a $IP -- -A -sC -sV"`  
`NMAP_CMD="nmap -oN $PLAT_DIR/$NAME/nmap.txt -T4 -A -sC -sV -p- $IP"`  

## Options
```  
-h|--help 		show brief help  
-p|--platform		specify a platform  
-n|--name		specify a room/box name  
-s|--scan		specify a scanning tool (nmap / rustscan)  
-i|--ip			specify an ip  ```
