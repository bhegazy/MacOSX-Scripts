#!/bin/bash
# A script to install/Download AndroidSDK,JavaJDK, Unity3d and Xcode automatically from the command line given a dmg file.



#Check for sudo
if [[ "$(/usr/bin/whoami)" != "root" ]]; then printf '\nMust be run as root! use sudo\n\n'; exit 1; fi

declare sudo=/usr/bin/sudo


# check assumptions and change if Needed
unityhome=/Applications/Unity
xcodehome=/Applications/Xcode.app


#Download URLS
UNITY3D_URL="http://netstorage.unity3d.com/unity/unity-4.5.3.dmg"
XCODE_URL="http://netstorage.unity3d.com/unity/xcode_5.1.1.dmg"
JAVAJDK_URL="http://download.oracle.com/otn-pub/java/jdk/7u67-b01/jdk-7u67-macosx-x64.dmg"
ANDROID_URL="https://dl.google.com/android/adt/adt-bundle-mac-x86_64-20140702.zip"


#Installing Android SDK

cd
echo "Downloading $ANDROID_URL"
curl -C - -O -L $ANDROID_URL
file=`echo $ANDROID_URL | sed -e 's/.*\/\([^\/]*\)/\1/' `
echo $file
/usr/bin/unzip -qq $file
folder=`echo "${file%.*}"`
mv ~/$folder ~/AndroidSDK
rm -rf $file


#Installing Java JDK

cd
echo "Downloading $JAVAJDK_URL"
curl -C - -O -L $JAVAJDK_URL
file=`echo $JAVAJDK_URL | sed -e 's/.*\/\([^\/]*\)/\1/' `
echo $file
tempfoo=`basename $0`
TMPFILE=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1
hdiutil verify $file
hdiutil mount -readonly -nobrowse -plist $file > $TMPFILE
vol=`grep Volumes $TMPFILE  | sed -e 's/.*>\(.*\)<\/.*/\1/'`
pkg=`ls -1 "$vol"/*.pkg`
printf '\n\e[1mInstalling JAVA JDK. Please Wait...\e[m\n'
sudo installer -pkg "$pkg" -target /
hdiutil unmount "$vol"


#Installing Unity

if [[ -d "$unityhome" ]]; then
 	   echo "ERROR: $unityhome already present"
  	
  	  elif [[ "$unityhome" ]]; then
  		cd
  		echo "Downloading $UNITY3D_URL"
  	  	curl -C - -O -L $UNITY3D_URL
  	  	file=`echo $UNITY3D_URL | sed -e 's/.*\/\([^\/]*\)/\1/' `
  		echo $file
    	tempfoo=`basename $0`
		TMPFILE=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1
		hdiutil verify $file
		hdiutil mount -readonly -nobrowse -plist $file > $TMPFILE
		vol=`grep Volumes $TMPFILE  | sed -e 's/.*>\(.*\)<\/.*/\1/'`
		pkg=`ls -1 "$vol"/*.pkg`
		printf '\n\e[1mInstalling Unity3D. Please Wait...\e[m\n'
		sudo installer -pkg "$pkg" -target /
		hdiutil unmount "$vol"

fi

#Installing Xcode

if [[ -d "$xcodehome" ]]; then
 	echo "ERROR: $xcodehome already present"
	
	elif [[ "$xcodehome" ]]; then
		cd
  		echo "Downloading $XCODE_URL"
  	  	curl -C - -O -L $XCODE_URL
  	  	file=`echo $XCODE_URL | sed -e 's/.*\/\([^\/]*\)/\1/' `
  		echo $file
		tempfoo=`basename $0`
		TMPFILE=`mktemp /tmp/${tempfoo}.XXXXXX` || exit 1
		hdiutil verify $file
		hdiutil mount -readonly -nobrowse -plist $file > $TMPFILE
		vol=`grep Volumes $TMPFILE  | sed -e 's/.*>\(.*\)<\/.*/\1/'`
		app=`ls -1 "$vol" | grep Xcode`
		printf '\n\e[1mInstalling Xcode. Please Wait...\e[m\n'
		$sudo /bin/cp -R "$vol"/"$app" /Applications
		hdiutil unmount "$vol"
fi
