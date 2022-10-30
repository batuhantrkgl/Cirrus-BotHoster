#!/bin/bash

function tg_sendText() {
curl -s "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
-d "parse_mode=html" \
-d text="${1}" \
-d chat_id=$CHAT_ID \
-d "disable_web_page_preview=true"
}

function tg_sendFile() {
curl -F chat_id=$CHAT_ID -F document=@${1} -F parse_mode=markdown https://api.telegram.org/bot$BOT_TOKEN/sendDocument
}

BUILD_START=$(date +"%s");

mkdir -p ~/.config/rclone
echo "$rclone_config" > ~/.config/rclone/rclone.conf
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "$id_rsa" > ~/.ssh/id_rsa
echo "$id_rsa_pub" > ~/.ssh/id_rsa.pub
chmod 400 ~/.ssh/id_rsa
git config --global user.email "$user_email"
git config --global user.name "$user_name"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
echo "$known_hosts" > ~/.ssh/known_hosts
echo "$user_credentials" > ~/.git-credentials && git config --global credential.helper store


tg_sendText "Cloning repo"
git clone https://batuhantrkgl:"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"@github.com/batuhantrkgl/eray-bot.git
tg_sendText "Opening"
# Normal build steps
cd eray-bot
npm i 
cd src && node .

#tg_sendText "Uploading new ccache to gdrive"
#cd /tmp
#tar --use-compress-program="pigz -k -1 " -cf corvus_ccache.tar.gz ccache
#rclone copy corvus_ccache.tar.gz aosp: -P

