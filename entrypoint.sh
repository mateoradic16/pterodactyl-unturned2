#!/bin/bash
sleep 2

cd /home/container

mkdir steam && cd steam
curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

chown -R root:root /mnt
cd ../

# Update Unturned Server
./steam/steamcmd.sh +login anonymous +force_install_dir /home/container +app_update 1110390 +quit
echo "Downloading RocketMod..."
curl -o Rocket.zip "https://ci.rocketmod.net/job/Rocket.Unturned/lastSuccessfulBuild/artifact/Rocket.Unturned/bin/Release/Rocket.zip"
unzip -o -q Rocket.zip
cd Scripts/Linux
mv RocketLauncher.exe /home/container/
mv * /home/container/Scripts
cd /home/container/Scripts
rm -rf Linux
rm -rf Windows

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
${MODIFIED_STARTUP}
echo "If there was an error above when trying to stop your server, it can usually be ignored."