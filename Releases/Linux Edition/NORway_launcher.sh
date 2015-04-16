#!/bin/bash

# default serial port : (to find your teensy serial port, plug or unplug-replug it, then run "dmesg" command. Last lines should give you your ttyACM* port)
default_teensy_port="/dev/ttyACM0"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$script_dir"

pause ()
{
echo "Press [Enter] to continue... "
read -p "$*"
}

warning_norwayfile ()
{
clear
echo
echo
echo
echo
echo
echo
echo
echo
echo -e "\033[31m                               ---- ERROR ----"
echo
echo "                 NORway.py file not found or not executable."
echo
echo "                             Program will close."
echo
echo -e "                             -------------------\033[32m"
echo
echo
echo
echo
echo
echo
echo
echo
echo
pause
exit
}

auto_teensy_port()
{
echo
echo "Starting Teensy USB serial port auto-detection (experimental)":
res=1
for port in /dev/ttyACM*
  do
	./NORway.py $port &>/dev/null
	if [ $? == 0 ]
	  then
		res=0; teensy_port=$port; break;
	fi
  done
if [ $res == 0 ]
	  then
		echo -e "Teensy found on port \033[37m"$teensy_port"\033[32m"
		echo
		echo "Note: If it is not the port you expected, you can change it manually"
		echo "choosing \"S\" option at next screen."
		echo
		pause
		commandes
	  else
	    echo -e "\033[31mWARNING: Teensy not detected or a problem occurred!\033[32m"
		echo
		echo -e "So, default \033[37m"$default_teensy_port"\033[32m port will be used."
		teensy_port="$default_teensy_port"
		while true; do
			read -p "Do you want to set it manually now (y/n)? " yn
			case $yn in
				y|Y ) header; teensy_port;;
				n|N ) commandes;;
				* ) echo "Please answer y(yes) or n(no).";;
			esac
		done
fi
}

teensy_port()
{
echo
echo "You'll have to define your Teensy USB serial port."
echo "Note that you can find which is your port by running \"dmesg\" command just after"
echo "you connected the Teensy. Assuming your Teensy is correctly programmed with the"
echo "right hex files and python + python serial installed."
echo
while true; do
	read -p "Do you want to try auto-detection (y/n)? " yn
	case $yn in
		y|Y ) header; auto_teensy_port;;
		n|N ) break;;
		* ) echo "Please answer y(yes) or n(no).";;
	esac
done
echo
echo -e "List of existing port(s): \033[37m"
ls -d /dev/ttyACM* 2>/dev/null
if [ $? != 0 ]
  then 
	echo "(none)"
fi
echo -e "\033[32m"
echo -e "Teensy USB serial port actually set to: \033[37m"$teensy_port"\033[32m"
if [ ! -k "$teensy_port" ] 
  then 
	echo -e "\033[33mWarning: this port does not seem to exist!\033[32m"
fi
while true; do
    read -p "Change it (y/n)? " yn
    case $yn in
        y|Y ) 	read -p "Enter new serial port: " teensy_port
				echo -e "Teensy serial port now set to: \033[37m"$teensy_port"\033[32m" 
				if [ ! -k "$teensy_port" ] 
				  then 
					echo -e "\033[33mWarning: this port does not seem to exist!\033[32m"
				  else
					pause
					break
				fi;;
        n|N ) break;;
        * ) echo "Please answer y(yes) or n(no).";;
    esac
done
commandes
}

select-file ()
{
echo -e "\033[37m-------------------------------------------------------------------------------"
echo "Available files in `pwd` :"
echo -e "\033[36m"
ls *.bin *.BIN 2>/dev/null
echo -e "\033[37m-------------------------------------------------------------------------------"
echo -e "\033[32m"
count=`ls -1 *.bin *.BIN 2>/dev/null | wc -l`
if [ $count = 0 ]
then 
echo "No *.bin or *.BIN file available. Aborted."
fi 
while true; do
 read -p "Select a file (ex: \"mydump.bin\") : " fn
 file_name="`pwd`/$fn"
 if [ -f "$file_name" ]
  then
	 if [ $(stat -c%s "$file_name") -eq 16777216 ]
	  then
	     break
	  else
		 while true; do
			echo -e "\033[31mWrong file size. Is $(stat -c%s "$file_name") bytes, must be 16777216 Bytes (16384 KB).\033[32m"
			read -p "Try again (y/n)? " yn
			case $yn in
				y|Y ) break;;
				n|N ) commandes;;
				* ) echo "Please answer y(yes) or n(no).";;
			esac
		 done
	  fi
  else
 	 while true; do
		echo -e "\033[31mFile does not exist.\033[32m"
		read -p "Try again (y/n)? " yn
		case $yn in
			y|Y ) break;;
			n|N ) commandes;;
			* ) echo "Please answer y(yes) or n(no).";;
		esac
	 done
  fi
done
echo
echo -e "NOR will be written using file \033[37m$file_name\033[32m"
echo
}

dump_settings ()
{
while true; do
	read -p "Dump quantity : " nbr_dump
	if ([ $nbr_dump -gt 0 ] && [ $nbr_dump -lt 10 ]) 2>/dev/null
	  then
	    break
	  else
	    echo "Quantity must be an integer between 1 minimum to 9 maximum. Try again."
	fi
done
echo
while true; do 
 while true; do
	read -p "Save dump file(s) as (ex: \"mydump\", without file extention) : " fn
	case "$fn" in
		*[!A-Za-z0-9_-]*) echo "Invalid input. Only A-Z,a-z,0-9,_,- allowed. Try again.";;
		"") true;;
		*) break;;
	esac
 done
 file_name="`pwd`/$fn"
 var=0
 chk_exist=0
  while [ $var != $nbr_dump ]; do
	var=`expr $var + 1`
	set_dumpfilename
	if [ -f "$dump_file_name" ] 
	 then
	  echo -e "File \033[37m"$dump_file_name"\033[32m already exists!"
	  chk_exist=1
	fi
  done
  if [ $chk_exist == 1 ] 
	then  
      while true; do
		read -p "Do you want to overwrite file(s) (y/n)? " yn
		case $yn in
			y|Y|n|N ) break;;
			* ) echo "Please answer y(yes) or n(no).";;
		esac
	  done
	  case $yn in
		  y|Y ) break;;
		  n|N ) true;;
	  esac
	else
	  break
  fi
done
echo
echo -e "x"$nbr_dump" dump(s) will be done and saved as:"
var=0
while [ $var != $nbr_dump ]; do
  var=`expr $var + 1`
  set_dumpfilename
  echo -e "\033[37m"$dump_file_name"\033[32m"
done
echo
}

set_dumpfilename ()
{
if [ $nbr_dump == 1 ]
  then
	dump_file_name=""$file_name".bin"
  else
	dump_file_name=""$file_name"_"$var".bin"
fi
}

confirmation_cmd ()
{
while true; do
    read -p "Do you really wish to start \"$(echo $cmd | tr [:lower:] [:upper:])\" command (y/n)? " yn
    case $yn in
        y|Y ) break;;
        n|N ) commandes;;
        * ) echo "Please answer y(yes) or n(no).";;
    esac
done
echo
}

error ()
{
echo -e "\033[31mAn error occurred. Verify your installation."
echo -e "\033[32m"
pause
commandes
}

header ()
{
clear
echo -e "\033[33m*******************************************************************************"
echo "                   NORway Launcher \"LE\" v1.00, by littlebalup"
echo "*******************************************************************************"
echo -e "\033[32m"
}

commandes ()
{
header
echo -e "Teensy USB serial port: \033[37m"$teensy_port"\033[32m"
echo
echo "Commands list:"
echo " 1) INFO (set tristate, display NOR information)"
echo " 2) DUMP (dump NOR content)"
echo " 3) WRITE (flash NOR, buffered programming mode)"
echo " 4) VWRITE (flash and verify NOR, buffered programming mode)"
echo " 5) WRITEWORD (flash NOR, word programming mode)"
echo " 6) VWRITEWORD (flash and verify NOR, word programming mode)"
echo " 7) WRITEWORDUBM (flash NOR, word programming/unlock bypass mode)"
echo " 8) VWRITEWORDUBM (flash and verify NOR, word programming/unlock bypass mode)"
echo " 9) VERIFY (verify NOR content against a dump file)"
echo " E) ERASECHIP (erase entire NOR content)"
echo " R) RELEASE (release tristate, so the PS3 can boot)"
echo " S) Set Teensy USB serial port"
echo " Q) Quit"
echo
while true; do
	read -p "Select a command: " n
	case $n in
		1) cmd="info"; cmd_type="simple"; scrypt_start;;
		2) cmd="dump"; cmd_type="dump"; scrypt_start;;
		3) cmd="write"; cmd_type="write"; scrypt_start;;
		4) cmd="vwrite"; cmd_type="write"; scrypt_start;;
		5) cmd="writeword"; cmd_type="write"; scrypt_start;;
		6) cmd="vwriteword"; cmd_type="write"; scrypt_start;;
		7) cmd="writewordubm"; cmd_type="write"; scrypt_start;;
		8) cmd="vwritewordubm"; cmd_type="write"; scrypt_start;;
		9) cmd="verify"; cmd_type="write"; scrypt_start;;
		e|E) cmd="erasechip"; cmd_type="simple"; scrypt_start;;
		r|R) cmd="release"; cmd_type="simple"; scrypt_start;;
		s|S) header; teensy_port;;
		q|Q) exit;;
		*) echo "Invalide command, select again.";;
	esac
done
exit
}

scrypt_start ()
{
echo
case $cmd_type in
	"dump") dump_settings;;
	"write") select-file;;
esac
confirmation_cmd
if [ "$cmd_type" == "dump" ]
  then
	var=0
	while [ $var != $nbr_dump ]; do
	  var=`expr $var + 1`
	  set_dumpfilename
	  run
	done
	if [ $nbr_dump -gt 1 ]
	  then
		while true; do
		  read -p "Perform a binary comparison of dumps (y/n)? " yn
		  case $yn in
			y|Y ) 	break;;
			n|N ) break;;
			* ) echo "Please answer y(yes) or n(no).";;
		  esac
		done
		echo
		echo -------------------------------------------------------------------------------
		loop=0; errorresult=0; errorfile=0;	errorcode=0
		echo "NORway launcher, file compare log dated : "$(date +%x)" at "$(date +%X)"" >compare_log.txt; echo >>compare_log.txt
		while true; do
		if [ $loop == $nbr_dump ]
		  then
		    break
		  else
		    loop=`expr $loop + 1`
			VAR=`expr $nbr_dump - \( $nbr_dump - $loop \)`
			while true; do
			if [ $VAR == $nbr_dump ]
		      then
				break
			  else
				VAR=`expr $VAR + 1`
				echo "Please wait..."
				cmp -l "$file_name"_"$loop".bin "$file_name"_"$VAR".bin | mawk 'function oct2dec(oct, dec) {for (i = 1; i <= length(oct); i++) {dec *= 8; dec += substr(oct, i, 1)}; return dec} {printf "%08X %02X %02X\n", $1, oct2dec($2), oct2dec($3)}' >>compare_log.txt;
				errorlevel=${PIPESTATUS[0]}
				case $errorlevel in
					0) echo -e "\033[37m"$file_name"_"$loop"bin\033[32m same as \033[37m"$file_name"_"$VAR".bin\033[32m";;
					1) echo -e "\033[37m"$file_name"_"$loop".bin\033[33m different from \033[37m"$file_name"_"$VAR".bin\033[32m"; errorresult=$errorlevel;;
					2) errorfile=$errorlevel;;
			    esac
			fi
			done
		fi
		done
		echo >>compare_log.txt; echo "END" >>compare_log.txt
		errorcode=""$errorfile""$errorresult""
		echo "Done."
		echo -------------------------------------------------------------------------------
		echo
		case $errorcode in
			00) echo "Dumps are identical. Details in file compare_log.txt.";;
			01) echo -e "\033[33mAttention : one or more dumps are different. Details in file compare_log.txt.\033[32m";;
			2*) echo -e "\033[31mError : one or more files not found.\033[32m";;
		esac
		echo
	fi
  else
      dump_file_name="$file_name"
	  run
fi
pause
clear
commandes
}

run ()
{
echo
echo "Starting :"
echo "./NORway.py "$teensy_port" "$cmd" "$dump_file_name""
echo
echo -e "\033[37m-------------------------------------------------------------------------------"
case $cmd_type in
	"simple") ./NORway.py "$teensy_port" "$cmd";;
	*) ./NORway.py "$teensy_port" "$cmd" "$dump_file_name";;
esac
errorlevel=$?
echo "-------------------------------------------------------------------------------"
echo -e "\033[32m"
if [ $errorlevel != 0 ]
  then
	error
fi
}

#Console Title
title="NORway Launcher"
echo -e '\033]2;'$title'\007'
echo -e "\033[32m"
clear

echo "                                                             Linux Edition V1.0"
echo -e "\033[33m           _   _  ____  _____"
echo -e "          | \ | |/ __ \|  __ \                            \033[36m       .--.     \033[33m"
echo -e "          |  \| | |  | | |__) |_      ____ _ _   _        \033[36m      |\033[37mo\033[36m\033[33m_\033[37mo\033[36m |    \033[33m"
echo -e "          | . \` | |  | |  _  /\ \_/\_/ / _\` | | | |       \033[36m      |\033[33m\_/\033[36m |    \033[33m"
echo -e "          | |\  | |__| | | \ \ \      / (_| | |_| |       \033[36m     /\033[37m/   \ \033[36m\   \033[33m"
echo -e "          |_| \_|\____/|_|  \_\ \_/\_/ \__,_|\__, |       \033[36m    (\033[37m|     |\033[36m )  \033[33m"
echo -e "                 _                        _   __/ |          /'\_   _/'\  "
echo -e "                | |                      | | |___/           \___)\033[36m-\033[33m(___/  "
echo "                | | __ _ _   _ _ __   ___| |__   ___ _ __ "
echo "                | |/ _\` | | | | '_ \ / __| '_ \ / _ \ '__| "
echo "                | | (_| | |_| | | | | (__| | | |  __/ | "
echo "                |_|\__,_|\__,_|_| |_|\___|_| |_|\___|_| "
echo
echo  -e "\033[32m-------------------------------------------------------------------------------"
echo " For the execution of NORway by Judges (www.github.com/hjudges/NORway)."
echo " Installation Note:"
echo "    - Place this program into the same folder as NORway.py file"
echo "    - Execute"
echo  -e "\033[31m ATTENTION : The use of this program is at your own risk."
echo " The author can not be held responsible for the consequences of its use."
echo  -e "\033[32m-------------------------------------------------------------------------------"
pause
if [ ! -x "NORway.py" ]
  then
	warning_norwayfile
fi
header
auto_teensy_port
exit
