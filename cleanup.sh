#MAC HOUSEKEEPING AND MORE
#Version 1.0.0
#Author: Matia Zanella
#https://github.com/akamura
#Copyright (c) 2021
#
#
#MIT License
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

#!/bin/bash



#==================================================
#ENABLE SOME ENVIRONMENT CUSTOMISATIONS
#==================================================
defaults write com.apple.Dock autohide -bool TRUE; killall Dock
defaults write com.apple.dock autohide-time-modifier -int 1;killall Dock
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.dock launchanim -bool false
killall Dock
killall Finder



#==================================================
#INSTALL SOME USEFUL APPS
#==================================================
cd ~/Downloads/
curl -O https://freemacsoft.net/downloads/AppCleaner_3.6.zip
unzip AppCleaner_3.6.zip
mv AppCleaner.app /Applications/
rm -f ~/Downloads/AppCleaner_3.6.zip



#==================================================
#EXECUTE SYSTEM UPDATE
#==================================================
echo -n "Do you want to LIST Mac Updates? Yes [Y] - No [N]"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
softwareupdate -l
fi


echo -n "Do you want to EXECUTE the Mac Updates? Yes [Y] - No [N]"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
softwareupdate -i -a
fi



#==================================================
#CLEAN THE WHOLE JUNK
#==================================================
sudo periodic daily
sudo periodic weekly
sudo periodic montly

#Clean user cache (Preserve Directory Structure - Clean just the files)
echo "Cleaning user cache file from ~/Library/Caches"
sudo find ~/Library/Caches/ 2>/dev/null  -maxdepth 100 -type f -exec rm -f {} \;
echo "SUCCESS >>> cleaned user cache file from ~/Library/Caches"

#Clean system caches  (Preserve Directory Structure - Clean just the files)
echo "Cleaning system caches"
sudo find /Library/Caches/ 2>/dev/null -maxdepth 100 -type f -exec rm -f {} \;
echo "SUCCESS >>> cleaned system caches"

#Clean user logs
echo "Cleaning user log file from ~/Library/logs"
sudo find ~/Library/Logs/ 2>/dev/null -maxdepth 100 -type f -exec rm -f {} \;
echo "SUCCESS >>> cleaned user log file from ~/Library/logs"

#Clean system logs
echo "Cleaning system logs from /Library/logs"
sudo find /Library/logs/ 2>/dev/null -maxdepth 100 -type f -exec rm -f {} \;
echo "SUCCESS >>> cleaned system logs from /Library/logs"
echo "Cleaning system logs from /var/log"
sudo find /var/log/ 2>/dev/null -maxdepth 100 -type f -exec rm -f {} \;
echo "SUCCESS >>> cleaned system logs from /var/log"
echo "Cleaning from /private/var/folders"
sudo find /private/var/folders/ 2>/dev/null -maxdepth 100 -type f -exec rm -f {} \;
echo "SUCCESS >>> cleaned /private/var/folders"

#Cleaning Application Caches
echo "Cleaning application caches"
for x in $(ls ~/Library/Containers/)
do
sudo find ~/Library/Containers/$x/Data/Library/Caches/ 2>/dev/null -maxdepth 100 -type f -exec rm -f {} \;
done
echo "SUCCESS >>> cleaned application caches ~/Library/Containers/"

killall Dock
killall Finder

echo "Also consider removing these files"
sudo find /Users 2>/dev/null -type f -size +1G -execs ls -lh {} \;



#==================================================
#NETWORK STUFF
#==================================================
rm -f /etc/nsmb.conf
cat > /etc/nsmb.conf <<- "EOF"
[default]
signing_required=no
port445=no_netbios
protocol_vers_map=6
validate_neg_off=yes
smb_neg=smb3_only
EOF


sudo killall -HUP mDNSResponder
dscacheutil -flushcache
echo "SUCCESS >>> DNS cache cleared"
