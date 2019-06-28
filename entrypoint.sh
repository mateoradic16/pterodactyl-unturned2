#!/bin/bash
sleep 2

cd /home/container

mkdir /home/container/steam
cd steam
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
cd /home/container

# Update Unturned Server
./steam/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update 1110390 +quit
echo "Downloading RocketMod..."
curl -o Rocket.zip "https://ci.rocketmod.net/job/Rocket.Unturned/lastSuccessfulBuild/artifact/Rocket.Unturned/bin/Release/Rocket.zip"
unzip -o -q Rocket.zip
mv /home/container/Scripts/Linux/RocketLauncher.exe /home/container/
mv /home/container/Scripts/Linux/* /home/container/Scripts
rm -rf /home/container/Scripts/Linux
rm -rf /home/container/Scripts/Windows

cd /home/container

# Feature removed from panel?
#if [ -z "${ALLOC_0__PORT}" ] || [ "$((ALLOC_0__PORT-1))" != "${SERVER_PORT}" ]; then
#    echo "Please add port $((SERVER_PORT+1)) to the server as an additional allocation, or you will be unable to connect."
#    sleep 10
#    exit 1
#fi

# Unturned Workaround
ulimit -n 2048
export LD_LIBRARY_PATH=$HOME/lib:$LD_LIBRARY_PATH

# Replace Startup Variables
MODIFIED_STARTUP=$(eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g'))
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
cd /home/container

export MONO_IOMAP=all

#CONFIG
STEAMCMD_HOME="/home/container/steam"
UNTURNED_HOME="/home/container/"

#COLORS
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLLOW='\033[0;33m'
NC='\033[0m'

#Steam checks
STEAMCMD_API=$STEAMCMD_HOME/linux64/steamclient.so
UNTURNED_API=$UNTURNED_HOME/lib
mkdir $UNTURNED_API
printf "Steam: "
if [ -f $STEAMCMD_API ]; then
	if diff $STEAMCMD_API $UNTURNED_API >/dev/null ; then
		printf "${GREEN}UP TO DATE${NC}\n\n"
	else
		cp $STEAMCMD_API $UNTURNED_API
		printf "${YELLLOW}UPDATING${NC}\n\n"
	fi
else
	printf "${RED}NOT FOUND${NC}\n\n"
fi

cd $UNTURNED_HOME

if [ -f RocketLauncher.exe ]; then
	ulimit -n 2048
	export LD_LIBRARY_PATH=$UNTURNED_HOME/lib:$LD_LIBRARY_PATH
	${MODIFIED_STARTUP}
else
	echo "RocketLauncher not found."
fi


echo "If there was an error above when trying to stop your server, it can usually be ignored."