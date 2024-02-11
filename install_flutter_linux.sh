#!/bin/bash

sudo apt update

# Prepare for the Java Development Kit and Java Runtime Environment
sudo apt install default-jdk -y
sudo apt update
sudo apt install default-jre -y
sudo apt update

# Installing git (if already exist, it only update to the lastest release)
sudo apt install git -y
sudo apt update


# Prepare for the entire folder to hold the Android SDK and the Flutter
cd ~
mkdir Android
cd Android
mkdir cmdline-tools

# Download Flutter from github repository
if [ -d ~/Android/flutter ];
then
	echo "Flutter directory aldeary exists in path ~/Android/flutter...Skipped..."
else
	cd ~/Downloads
	git clone https://github.com/flutter/flutter.git -b stable
fi

# Move the flutter folder to the Android folder created before
if [ -d ~/Android/flutter ];
then
	echo "Skipped moving flutter directory to ~/Android because it's already exists...."
else
	sudo mv flutter/ ~/Android
fi

# Download the Android command tools for downloading Android SDK later
if [ -d ~/Android/cmdline-tools/tools ];
then
	echo "tools directory is already exist in ~/Android/cmdline-tools/tools...Skipped...."
else
	cd ~/Downloads
	wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip

	unzip commandlinetools-linux-9477386_latest.zip

	sudo mv cmdline-tools tools
	sudo mv tools/ ~/Android/cmdline-tools/
fi

# Configure the system path to flutter and android sdk folder
cd ~

if grep -wq "# Android SDK and Flutter things" ~/.bashrc;
then
	echo "Config PATH already exist, skipped..."

else
	echo '# Android SDK and Flutter things' >> ~/.bashrc
	echo 'export ANDROID=$HOME/Android' >> ~/.bashrc
	echo 'export PATH=$ANDROID/cmdline-tools/tools:$PATH' >> ~/.bashrc
	echo 'export PATH=$ANDROID/cmdline-tools/tools/bin:$PATH' >> ~/.bashrc
	echo 'export PATH=$ANDROID/platform-tools:$PATH' >> ~/.bashrc

	echo '# Android SDK' >> ~/.bashrc
	echo 'export ANDROID_SDK=$HOME/ANDROID' >> ~/.bashrc
	echo 'export PATH=$ANDROID_SDK:$PATH' >> ~/.bashrc

	echo '# Flutter' >> ~/.bashrc
	echo 'export FLUTTER=$ANDROID/flutter' >> ~/.bashrc
	echo 'export PATH=$FLUTTER/bin:$PATH' >> ~/.bashrc
fi

# download and install android sdk using sdkmanager
{
xterm -e sdkmanager --list

xterm -e sdkmanager "system-images;android-29;default;x86_64"
xterm -e sdkmanager "platforms;android-29"
xterm -e sdkmanager "platform-tools"
xterm -e sdkmanager "build-tools;29.0.3"
} || {
source ~/.bashrc
sdkmanager --list
sdkmanager "system-images;android-29;default;x86_64"
sdkmanager "platforms;android-29"
sdkmanager "platforms-tools"
sdkmanager "build-tools;29.0.3"
}

# accepting liceses for the android sdk
{
xterm -e sdkmanager --licenses
} || {
sdkmanager --licenses
}

# config the android sdk path for flutter
{
xterm -e flutter config --android-sdk ~/Android
xterm -e flutter doctor -v
} || {
flutter config --android-sdk ~/Android
flutter doctor -v
}

echo "Flutter installed successfully...."
echo "Run 'flutter doctor' to check or 'flutter doctor -v' to get more detail info"
echo "Run 'flutter -h' or 'flutter --help' or 'flutter help' to list all the commands available"
