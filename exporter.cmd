:: Minecraft BE World Exporter
:: Version 2.9 - fork
::
:: Created by Tikolu - https://tikolu.net/world-exporter
:: Fork by MFn - https://github.com/MFn233/WorldExporter-Next
:: Report issues to mfn233@qq.com


:SETUP
@ECHO OFF
title Minecraft BE World Exporter tool - Version 2.9 fork
color 0f
CD %~dp0
SET heading=MCBE World Exporter Next - By MFn
SET divider==================================
:: SET email=tikolu43@gmail.com
SET email=mfn233@qq.com
:: SET url=https://tikolu.net/world-exporter/logexternal.php?
SET url=https://github.com/MFn233/WorldExporter-Next
SET issueurl=https://github.com/MFn233/WorldExporter-Next/issues
IF NOT EXIST "files\temp" GOTO FILEERROR
CD files
ECHO test>temp
SET /p writetest=<temp
IF NOT [%writetest%]==[test] GOTO FILEERROR
fc temp temp>NUL
IF [%errorlevel%]==[0] GOTO FILESYSTEMOK
ECHO Filesystem is broken or corrupted. WorldExporter cannot run.
PAUSE>NUL
EXIT
:FILESYSTEMOK
java -jar abe.jar>temp 2>&1
fc temp abe_info>NUL
IF NOT [%errorlevel%]==[0] GOTO JAVANOTINSTALLED
IF EXIST "..\minecraftWorlds" GOTO WORLDFOLDEREXISTS
CLS
ECHO Launching ADB...
adb0 kill-server>nul
adb0 start-server>nul
ECHO Getting device state...
adb0 get-state>temp
SET /p deviceState=<temp
IF [%deviceState%]==[device] GOTO BACKUP
GOTO INTRODUCTION

:FILEERROR
CLS
ECHO An error was encountered when trying to access necessary files.
ECHO Please make sure that the ZIP file is extracted before using World Exporter.
ECHO If you need help, please send an issue on %url%
START %issueurl%
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT

:JAVANOTINSTALLED
CLS
ECHO Java was not detected on your system.
ECHO Please make sure Java is installed.
ECHO You can download the latest version of Java here: https://www.java.com/
ECHO.
ECHO If you need help, please send an issue on %issueurl%
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT

:WORLDFOLDEREXISTS
CLS
ECHO The "minecraftWorlds" folder inside WorldExporter's directory must be deleted (or renamed) before exporting new worlds.
ECHO.
ECHO Press enter to delete the folder and continue.
ECHO.
ECHO Attention! You still have some time to rename the old folder before pressing Enter.
ECHO No sooner you press Enter, than your old "minecraftWorlds" folder will be deleted!!!
PAUSE>NUL
RMDIR "%~dp0\minecraftWorlds" /s /q
GOTO SETUP

:MINECRAFTNOTINSTALLED
CLS
ECHO Minecraft was not detected on your device.
ECHO.
ECHO If Minecraft is installed, this means that there is an error communicating with
ECHO your device. Please send an issue on %url%
START %issueurl%
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT

:BACKUPERROR
CLS
ECHO Something went wrong during the extraction process.
ECHO.
ECHO But don't give up yet!
ECHO This might be due to a few different reasons, so send an issue on GitHub and I will respond as soon as possible.
START %issueurl%
ECHO.
ECHO Please include this information in your issue:
IF EXIST "backup.ab" ECHO backup.ab is ok
ECHO backup size is %backupSize%
IF EXIST "backup.tar" ECHO backup.tar is ok
PAUSE>NUL
EXIT

:EMPTYBACKUP
CLS
ECHO The backup file which has been exported is blank.
ECHO Try restarting your device and computer, and then running WorldExporter again.
ECHO.
ECHO If the error persists, send an issue on Github. You can include some diagnostic information in your email,
ECHO press enter now to reveal the diagnostic information...
START %issueurl%
PAUSE>NUL
CLS
TREE backup
PAUSE>NUL
EXIT

:INTRODUCTION
CLS
ECHO Welcome to Minecraft World Exporter
ECHO ===================================
ECHO.
ECHO You can use this tool to export worlds from Minecraft Bedrock Edition on your android device
ECHO if you have set your storage type to "Application" in the settings.
ECHO.
ECHO This program was forked by MFn. If you experience any problems during the
ECHO process, please send an issue on %url%. Documentation: https://mfn233.github.io/WorldExporter-Next/
ECHO.
ECHO Whenever you're ready, press enter.
PAUSE>NUL
GOTO DEBUGGING

:DEBUGGING
CLS
ECHO %heading%
ECHO %divider%
ECHO.
ECHO USB Debugging needs to be enabled for this program to connect to your device. 
ECHO Don't worry. It does no harm to your device and can be turned off at any time.
ECHO Follow these steps:
ECHO.
ECHO 1. Go to your Android device settings.
ECHO 2. Scroll down to the bottom and click on "System" and then "About Device".
ECHO 3. Find "Build Number" and tap it a few times until you get a message saying "You are a developer".
ECHO 4. Go out of "About Device" and back into "System". A new "Developer Options" menu should now be here.
ECHO 5. Open it and scroll down to "USB DEBUGGING". Make sure that it is ENABLED.
ECHO.
ECHO 6. Connect the device to your computer with a USB cable.
ECHO 7. After connecting a popup will ask "Allow USB Debugging?". Tap on "Allow".
ECHO.
ECHO If nothing happens after pressing "Allow", you may need to install drivers for your device.
ECHO Drivers can be downloaded from:
ECHO https://github.com/MFn233/WorldExporter-Next/tree/master/AndroidDriver
adb0 wait-for-device
GOTO BACKUP

:BACKUP
adb0 shell pm path com.mojang.minecraftpe>temp
SET /p minecraftPath=<temp
IF [%minecraftPath%]==[] GOTO MINECRAFTNOTINSTALLED
ECHO.
ECHO Device connected. Please wait...
adb0 shell am force-stop com.mojang.minecraftpe
adb0 shell am start com.mojang.minecraftpe/.MainActivity>NUL
TIMEOUT /T 3 >NUL
CLS
ECHO %heading%
ECHO %divider%
ECHO.
ECHO A backup request has been sent to your device. This will get Minecraft's data and move it to your computer.
ECHO.
ECHO Please tap on "Back up my data" to begin the backup procedure. 
ECHO (better not enter a password. If your system needs you to enter a password, please keep it in your mind)
ECHO This might take a few minutes, depending on how many worlds you have.
IF EXIST "backup.ab" DEL backup.ab
IF EXIST "backup.tar" DEL backup.tar
adb0 backup -noapk com.mojang.minecraftpe>NUL
GOTO EXTRACTION

:EXTRACTION
ECHO.
ECHO Backup copied from device. You may unplug your device now.
IF NOT EXIST "backup.ab" GOTO BACKUPERROR
CALL getFileSize.cmd backup.ab>temp
SET /p backupSize=<temp
IF [%backupSize%]==[0] GOTO BACKUPERROR
IF EXIST "backup" RMDIR backup /s /q
MKDIR backup
ECHO Extracting backup file...
IF NOT EXIST "backup.ab" GOTO BACKUPERROR
ECHO If you entered a password when in the backup procedure, please enter it here and press Enter;
ECHO else, do nothing just press Enter.
ECHO.
set password=
set /p password=Enter the password: 
IF DEFINED password (
    java -jar abe.jar unpack backup.ab backup.tar %password%
) ELSE java -jar abe.jar unpack backup.ab backup.tar
IF NOT EXIST "backup.tar" GOTO BACKUPERROR
ECHO Extracting archive...
7zip x -y -obackup backup.tar>NUL
ECHO Moving "minecraftWorlds" folder to WorldExporter directory...
:: 3 Billion Devices run Tikolu World Exporter
IF NOT EXIST "backup\apps\com.mojang.minecraftpe\r\games\com.mojang" GOTO EMPTYBACKUP
CD "backup\apps\com.mojang.minecraftpe\r\games\com.mojang"
IF EXIST "%~dp0\minecraftWorlds" GOTO WORLDFOLDEREXISTS
MOVE "minecraftWorlds" "%~dp0">NUL
ECHO Cleaning up after extraction...
CD "..\..\..\..\..\.."
RMDIR backup /s /q
IF EXIST "backup.ab" DEL backup.ab
IF EXIST "backup.tar" DEL backup.tar
adb0 kill-server>nul
ECHO World Export Complete!
dir /a:d "..\minecraftWorlds" | find /c "<DIR>">temp
SET /p worlds=<temp
CURL -s "%url%log=success&worlds=%worlds%"
explorer "..\minecraftWorlds"
GOTO END

:END
CLS
ECHO %heading%
ECHO %divider%
ECHO.
ECHO The worlds have been exported!
ECHO You should now find a "minecraftWorlds" folder in the WorldExporter directory.
ECHO.
ECHO Thank you for using my tool. If it helped you today, please let me know by
ECHO emailing %email%! If you experienced any issues, errors or if
ECHO you just have a general suggestion about the program, send an issue on %issueurl%
ECHO.
ECHO WorldExporter-Next will always be a free to use project.
ECHO.
ECHO Press enter to exit.
PAUSE>NUL
EXIT
