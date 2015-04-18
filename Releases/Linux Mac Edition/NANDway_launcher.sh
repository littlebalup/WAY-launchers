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

warning_nandwayfile ()
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
echo "                 NANDway.py file not found or not executable."
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
	./NANDway.py $port 0 &>/dev/null
	if [ $? == 0 ]
	  then
		res=0; teensy_port=$port; break;
	fi
  done
if [ $res == 1 ]
  then
    for port in /dev/tty.usbmodem*
	  do
		./NANDway.py $port 0 &>/dev/null
		if [ $? == 0 ]
		  then
			res=0; teensy_port=$port; break;
		fi
  done
fi  
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
if [ $cmd_type == "diffwrite" ]
  then
    ls *.bin *.BIN *.txt *.TXT 2>/dev/null
  else
    ls *.bin *.BIN 2>/dev/null
fi
echo -e "\033[37m-------------------------------------------------------------------------------"
echo -e "\033[32m"
count=`ls -1 *.bin *.BIN 2>/dev/null | wc -l`
if [ $count = 0 ]
then 
echo "No *.bin or *.BIN file available. Aborted."
fi 
while true; do
 read -p "Select a dump file (ex: \"mydump.bin\") : " fn
 file_name="`pwd`/$fn"
 if [ -f "$file_name" ]
  then
	 if [ $(ls -nl "$file_name" | awk '{print $5}') -eq 138412032 ]
	  then
	     break
	  else
		 while true; do
			echo -e "\033[31mWrong file size. Is $(stat -c%s "$file_name") bytes, must be 138412032 Bytes (135168 KB).\033[32m"
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
if [ $cmd_type == "diffwrite" ]
  then
	while true; do
	  read -p "Select a diff. file (ex: \"DifferenceFileFlash.txt\") : " fn
	  diff_file_name="`pwd`/$fn"
	  if [ -f "$diff_file_name" ]
		then
		  break
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
fi
echo
case $cmd in
	"ps3badblocks" ) echo -e "Bad blocks will be searched in file \033[37m$file_name\033[32m";;
	*"diff"* ) echo -e "NAND will be written with dump file  \033[37m$file_name\033[32m"; echo -e "and using differential file  \033[37m$diff_file_name\033[32m";;
			*) echo -e "NAND will be written with dump file  \033[37m$file_name\033[32m";;
esac
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
echo "                  NANDway Launcher \"LME\" v1.01, by littlebalup"
echo "*******************************************************************************"
echo -e "\033[32m"
}

commandes ()
{
header
echo -e "Teensy USB serial port: \033[37m"$teensy_port"\033[32m"
echo
echo "Commands list:"
echo " 1) INFO (display NAND information)"
echo " 2) DUMP (dump NAND content)"
echo " 3) WRITE (flash NAND)"
echo " 4) VWRITE (flash and verify NAND)"
echo " 5) DIFFWRITE (differential flash NAND)"
echo " 6) VDIFFWRITE (differential flash and verify NAND)"
echo " 7) PS3BADBLOCKS (identify bad blocks in a NAND dump file)"
echo " S) Set Teensy USB serial port"
echo " Q) Quit"
echo
file_name=""
dump_file_name=""
diff_file_name=""
while true; do
	read -p "Select a command: " n
	case $n in
		1) cmd="info"; cmd_type="simple"; scrypt_start;;
		2) cmd="dump"; cmd_type="dump"; scrypt_start;;
		3) cmd="write"; cmd_type="write"; scrypt_start;;
		4) cmd="vwrite"; cmd_type="write"; scrypt_start;;
		5) cmd="diffwrite"; cmd_type="diffwrite"; scrypt_start;;
		6) cmd="vdiffwrite"; cmd_type="diffwrite"; scrypt_start;;
		7) cmd="ps3badblocks"; cmd_type="ps3bb"; scrypt_start;;
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
	*"write") select-file;;
	"ps3bb" ) select-file;;
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
	echo
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
		echo "NANDway launcher, file compare log dated : "$(date +%x)" at "$(date +%X)"" >compare_log.txt; echo >>compare_log.txt
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
				cmp -l "$file_name"_"$loop".bin "$file_name"_"$VAR".bin | awk 'function oct2dec(oct, dec) {for (i = 1; i <= length(oct); i++) {dec *= 8; dec += substr(oct, i, 1)}; return dec} {printf "%08X %02X %02X\n", $1, oct2dec($2), oct2dec($3)}' >>compare_log.txt;
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
echo
pause
clear
commandes
}

run ()
{
echo
echo "Starting :"
case $cmd_type in
	"ps3bb") echo "./NANDway.py "$cmd" "$dump_file_name"";;
	*) echo "./NANDway.py "$teensy_port" 0 "$cmd" "$dump_file_name" "$diff_file_name"";;
esac
echo
echo -e "\033[37m-------------------------------------------------------------------------------"
case $cmd_type in
	"simple") ./NANDway.py "$teensy_port" 0 "$cmd";;
	"diffwrite") ./NANDway.py "$teensy_port" "$cmd" 0 "$dump_file_name" "$diff_file_name";;
	"ps3bb") ./NANDway.py "$cmd" "$dump_file_name";;
	*) ./NANDway.py "$teensy_port" "$cmd" 0 "$dump_file_name";;
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
title="NANDway Launcher"
echo -e '\033]2;'$title'\007'
echo -e "\033[32m"
clear

echo "                                                     Linux & Mac Edition v1.01"
echo -e "\033[33m                _   _          _   _ _____"
echo -e "               | \ | |   /\   | \ | |  __ \                      \033[36m     .--.     \033[33m"
echo -e "               |  \| |  /  \  |  \| | |  | |_      ____ _ _   _  \033[36m    |\033[37mo\033[36m\033[33m_\033[37mo\033[36m |    \033[33m"
echo -e "               | . \` | / /\ \ | . \` | |  | \ \_/\_/ / _\` | | | |  \033[36m   |\033[33m\_/\033[36m |    \033[33m"
echo -e "               | |\  |/ ____ \| |\  | |__| |\      / (_| | |_| |  \033[36m  /\033[37m/   \ \033[36m\   \033[33m"
echo -e "\033[37m          .:'\033[33m  |_| \_/_/    \_\_| \_|_____/  \_/\_/ \__,_|\__, | \033[36m  (\033[37m|     |\033[36m )  \033[33m"
echo -e "\033[37m      __ :'__\033[33m           _                        _         __/ |  /'\_   _/'\  "
echo -e "\033[37m   .'\`  \`-'  \`\`.  \033[33m     | |                      | |       |___/   \___)\033[36m-\033[33m(___/  "
echo -e "\033[37m  :          .-'  \033[33m     | | __ _ _   _ _ __   ___| |__   ___ _ __"
echo -e "\033[37m  :         :    \033[33m      | |/ _\` | | | | '_ \ / __| '_ \ / _ \ '__|"
echo -e "\033[37m   :         \`-;  \033[33m     | | (_| | |_| | | | | (__| | | |  __/ |"
echo -e "\033[37m    \`.__.-.__.'  \033[33m      |_|\__,_|\__,_|_| |_|\___|_| |_|\___|_|"
echo
echo  -e "\033[32m-------------------------------------------------------------------------------"
echo " For the execution of NANDway (SBE) by Judges (www.github.com/hjudges/NORway)."
echo " Installation Note:"
echo "    - Place this program into the same folder as NANDway.py file"
echo "    - Execute"
echo  -e "\033[31m ATTENTION : The use of this program is at your own risk."
echo " The author can not be held responsible for the consequences of its use."
echo  -e "\033[32m-------------------------------------------------------------------------------"
pause
if [ ! -x "NANDway.py" ]
  then
	warning_nandwayfile
fi
header
auto_teensy_port
exit
