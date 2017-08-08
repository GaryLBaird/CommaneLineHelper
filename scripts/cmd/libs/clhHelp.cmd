@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
CALL:ShowingHelp clhelper %2

GOTO :clhHelp-Done

:ShowingHelp
CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20," File:%~1","Options and Usage Help."
CALL:FORMATOUT 20,20," ---------------------------","------------------------------------------------------"
CALL:FORMATOUT 20,20," Options: ","Description %SELF_1% --Help"
CALL:FORMATOUT 20,20," --About","Describes the author and purpose."
CALL:FORMATOUT 20,20," --AddMailSignature","Uses your Active Directory settings to update your Microsoft"
CALL:FORMATOUT 20,20," .."," Outlook Signature."
CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --AddMailSignature"
CALL:FORMATOUT 20,20," ..  NOTE: ","This also fixes kerberos packet size errors in Windows 7 but may"
CALL:FORMATOUT 20,20," ..  NOTE: "," require a restart."
CALL:FORMATOUT 20,20," --BestColor","Sets the color of the command window."
CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --BestColor Background_Color Text_Color"
CALL:FORMATOUT 20,20," --CaseConvert","Converts text string to upper or lowercase."
CALL:FORMATOUT 20,20," ..  Usage: ","%~1 --CaseConvert [LCase/UCase] String"
CALL:FORMATOUT 20,20," ..  Results: ","Prints the string converted to uppercase or lowercase."
CALL:FORMATOUT 20,20," ..           "," Also sets the RETURN environment variable to the converted text."
CALL:FORMATOUT 20,20," --Configure","Attempts to open a configuration file in notepad or notepad plus plus."
CALL:FORMATOUT 20,20," ..","Users will be prompted if the file needs to be overwritten."
CALL:FORMATOUT 20,20," ..  Parameters: "," -Alias -Custom_Alias -MySettings -Installs"
CALL:FORMATOUT 20,20," ..  Example: "," %~1 --Configure -Custom_Alias"
CALL:FORMATOUT 20,20," --Copy","Copies a file and creates destination directory if missing."
CALL:FORMATOUT 20,20," .."," Users will be prompted if the file needs to be overwritten."
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 c:\directory\filename.name c:\destination"
CALL:FORMATOUT 20,20," --CreateAliasFile","Creates the alias file."
CALL:FORMATOUT 20,20," .."," Every time a command windows loads this alias.cmd file"
CALL:FORMATOUT 20,20," .."," will setup and configure the working environment."
CALL:FORMATOUT 20,20," .."," This is done through a registry key which will be"
CALL:FORMATOUT 20,20," .."," created or modified."
CALL:FORMATOUT 20,20," --FindKey","Recursively search a registry hive for keys."
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 --FindKey 'HKLM\Software\Hive' 'key' "
CALL:FORMATOUT 20,20," ..  Returns: "," Env:Variable 'FOUND_KEYS'"
CALL:FORMATOUT 20,20," --GitCommit","Commits changes using git.exe"
CALL:FORMATOUT 20,20," --GitForce","Cleans Source Repository for Git.exe"
CALL:FORMATOUT 20,20," --Help","Displays this help menu."
CALL:FORMATOUT 20,20," --Install","Download and install a utility."
CALL:FORMATOUT 20,20," ..  Parameters: "," [Git/Python2.7/Python3.1]"
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 --Install Git"
CALL:FORMATOUT 20,20," ..  ListOptions: "," %~1 --Install Options"
CALL:FORMATOUT 20,20," --JsonCheck","Checks file for valid json."
CALL:FORMATOUT 20,20," ..  Usage: "," '%~1 --JsonCheck file.json'","Will sleep for 10 seconds."
CALL:FORMATOUT 20,20," --Linux","Open an ssh connection to a linux machine."
CALL:FORMATOUT 20,20," ..  Usage: "," '%~1 --Linux machinename'","will run ssh user@machinename -i %USERPROFILE%\.ssh\id_rsa"
CALL:FORMATOUT 20,20," --PuTTY","Runs one of the following PuTTy commands."
CALL:FORMATOUT 20,20," ..  Parameters: "," %~1 --PuTTY [plink/pscp/psftp/putty/puttygen]"
CALL:FORMATOUT 20,20," --ReadINI","Reads a value from an '.ini' file."
CALL:FORMATOUT 20,20," ..  Parameters: ","[file.ini] [section] [key] [Environment_Variable_Name]"
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 --ReadINI 'FileName.ini' 'Section' 'Key' 'EnvVar'"
CALL:FORMATOUT 20,20," ..  Results: "," If the key was found, the value of the Key will be"
CALL:FORMATOUT 20,20," ..  "," the value of EnvVar."
REM CALL:FORMATOUT 20,20," ..  Output:"," %TEMP%\output.bat"
REM CALL:FORMATOUT 20,20," ..  "," Contains a SET __Key__=Value"
CALL:FORMATOUT 20,20," ..  Section: "," [section]"
CALL:FORMATOUT 20,20," ..  Key:Value: "," key=value"
CALL:FORMATOUT 20,20," --ReadRegValue","Another way to read the Windows registry."
CALL:FORMATOUT 20,20," ..  "," %~1 --ReadRegValue --Help"
CALL:FORMATOUT 20,20," ..Example: "," %~1 --ReadRegValue 'computername' 'HKCU\Name\Name' 'KeyName'"
CALL:FORMATOUT 20,20," ..Parameters: "," 'computername' 'HKCU\Name\Name' 'KeyName' Optional:['Filename.[bat/cmd]']"
CALL:FORMATOUT 20,20," --RegRead","Reads a registry key and then sets an environment variable to"
CALL:FORMATOUT 20,20," ..  "," 'RegKey'."
CALL:FORMATOUT 20,20," ..Example: "," %~1 --ReadReg 'HKCU\Name\Name' 'KeyName' 'NOSHOW'"
CALL:FORMATOUT 20,20," ..Parameters: "," Registry_Key Registry_Key_Name Optional:['NOSHOW']"
CALL:FORMATOUT 20,20," --RandomColor"," Randomly picks and sets the color of the command window."
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 --RandomColor Background_Color Text_Color"
CALL:FORMATOUT 20,20," --RDP","Opens remote desktop session for computername specified."
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 --RDP Servername"
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 --RDP "
CALL:FORMATOUT 20,20," ..  Default: "," If no server is specified it will attempt to connect to "
CALL:FORMATOUT 20,20," ..           "," all the servers in the __WINDOWS_SERVERS__ variable."
CALL:FORMATOUT 20,20," --SetupSSH","This is a one time setup for one or more linux servers."
CALL:FORMATOUT 20,20," ..  "," This function will create authorized ssh keys and put a copy in "
CALL:FORMATOUT 20,20," ..  "," the %userprofile%\.ssh id_rsa file and then copy that to the linux machine."
CALL:FORMATOUT 20,20," ..  Usage: "," '%~1 --SetupSSH machinename'"
CALL:FORMATOUT 20,20," ..  Results: "," After this setup you can connect to a linux machine without specifying"
CALL:FORMATOUT 20,20," ..           "," credentials."
CALL:FORMATOUT 20,20," --Sleep","Sleep for x number of seconds."
CALL:FORMATOUT 20,20," ..  Usage: "," '%~1 --Sleep 10'"
CALL:FORMATOUT 20,20," ..  Results: "," Will sleep for 10 seconds."
CALL:FORMATOUT 20,20," --WindowsExplorer","Opens the Windows Explorer."
CALL:FORMATOUT 20,20," ..  Usage: "," It will open to the directory passed on the command line."
CALL:FORMATOUT 20,20," ..  "," If no command was passed the current working directory is used."
CALL:FORMATOUT 20,20," --WMIC","Gives Examples of wmic commands."
CALL:FORMATOUT 20,20," ..  --Help "," Shows a list of functional parameters."
CALL:FORMATOUT 20,20," ..  --RUNALL "," Runs each option individually."
CALL:FORMATOUT 20,20," ..  Parameters: "," [file.ini] [section] [key] ['Your Data Here']"
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 --WMIC %computername% baseboard"
CALL:FORMATOUT 20,20," ..  Results: "," Depends on function are get or information only."
CALL:FORMATOUT 20,20," --WRITEINI"," Writes a value to an '.ini' file."
CALL:FORMATOUT 20,20," ..  Parameters: "," [file.ini] [section] [key] ['Your Data Here']"
CALL:FORMATOUT 20,20," ..  Usage: "," %~1 --WriteINI 'FileName.ini' 'Section' 'Key' 'Data'"
CALL:FORMATOUT 20,20," ..  Results: "," If the file does not exist the file will be created."
CALL:FORMATOUT 20,20," ..           "," If the [Section] you provided was not found it will be created."
CALL:FORMATOUT 20,20," ..           "," If the [Key] you provided was not found it will be created."
CALL:FORMATOUT 20,20," ..           "," The string of data will be set to the value of the key you provided."
CALL:FORMATOUT 20,20," ..  Note: "," Please do not use brackets when specifying a section."
CALL:FORMATOUT 20,20," ..  "," Malformed INI files are not supported. "
CALL:FORMATOUT 20,20," ..  Section: "," [section]"
CALL:FORMATOUT 20,20," ..  Key:Value: "," key=value"
CALL:FORMATOUT 20,20," ---------------------------"," ------------------------------------------------------"
GOTO:EOF

:FORMATOUT
CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF


:clhHelp-Done
