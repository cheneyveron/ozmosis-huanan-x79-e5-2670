#!/bin/bash

# GenAppleALC.sh : 03/30/2016 16:51 PM
# By cecekpawon
# https://github.com/cecekpawon/AppleALC/ - Extras

cd "`dirname "$0"`"
gPlistBuddyCmd="/usr/libexec/plistbuddy -c"
AppleALC="AppleALC.kext"
ALCContents="${AppleALC}/Contents"
ALCPlist="${ALCContents}/Info.plist"
ALCPlugIns="${ALCContents}/PlugIns"
ALCPinConfigs="${ALCPlugIns}/PinConfigs.kext"
ALCPinConfigsPlist="${ALCPinConfigs}/Contents/Info.plist"
gDate=$(date +"%Y-%m-%d_%H-%M-%S")
ALCZipBkp="${AppleALC}-(${gDate}).zip"

if [[ ! -d $ALCPinConfigs || ! -f $ALCPlist || ! -f $ALCPinConfigsPlist ]]; then
 echo "Place ${0##*/} to same directory as ${AppleALC}"
 exit
fi

zip -qr $ALCZipBkp $AppleALC

$gPlistBuddyCmd "Add ':Tmp' dict" $ALCPlist
$gPlistBuddyCmd "Merge ${ALCPinConfigsPlist} ':Tmp'" $ALCPlist
$gPlistBuddyCmd "Copy ':Tmp:IOKitPersonalities:HDA Hardware Config Resource' ':IOKitPersonalities:HDA Hardware Config Resource'" $ALCPlist
$gPlistBuddyCmd "Delete ':Tmp'" $ALCPlist
$gPlistBuddyCmd "Delete ':OSBundleLibraries:as.vit9696.PinConfigs'" $ALCPlist

rm -rf $ALCPlugIns

echo "Done!"