Minecraft Pocket Edition gives the user a choice of where their worlds should be kept. "External" and "Application".

"External" saves worlds in the device storage where the user can easily transfer them to another device. "Application" stores the worlds internally in Minecraft’s private folder to which only Minecraft has access.

Many people believe that rooting your device is the only method of exporting worlds saved under "Application". However, this is not true!

You can use this program to export worlds from Minecraft Pocket Edition if your "Storage Type" is set to "Application" in Minecraft Settings. The whole process is very simple and can be finished in under five minutes. Your device does NOT need to be rooted!

----

# REQUIREMENTS

To use WorldExporter, you will need:

* A computer running **Windows**

* **Java** installed on the Computer

* A **USB Cable** to connect to your phone / tablet

* About **five minutes** and some **patience**

# FUNCTIONS

The program utilizes ADB’s backup feature which allows for copying an application’s data even without root privileges. However, the exported backup file is encrypted so Android Backup Extractor is used to extract its contents into a tar archive. 7zip is then used to unarchive the tar file, and finally, the minecraftWorlds folder is moved to the WorldExporter’s directory where it can be easily accessed by the user.

The only user interaction required is the enabling of USB Debugging in Android settings. Instructions for doing this are included in the program.

The code for the program is open-source and is available on **GitHub**.
