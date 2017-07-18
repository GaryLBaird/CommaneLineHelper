@ECHO OFF
REM Capture Args to be used by functions below.
SET SELF_0=%0
SET SELF_1=%~dp0
SET ARG_1=%1
SET ARG_2=%2
SET ARG_3=%3
SET ARG_4=%4
SET ARG_5=%5
SET ARG_6=%6
SET ARG_7=%7
SET ARG_8=%8
SET ARG_9=%9
IF DEFINED ARG_1 SET ARGS=%ARG_1%
IF DEFINED ARG_2 SET ARGS=%ARGS%,%ARG_2%
IF DEFINED ARG_3 SET ARGS=%ARGS%,%ARG_3%
IF DEFINED ARG_4 SET ARGS=%ARGS%,%ARG_4%
IF DEFINED ARG_5 SET ARGS=%ARGS%,%ARG_5%
IF DEFINED ARG_6 SET ARGS=%ARGS%,%ARG_6%
IF DEFINED ARG_7 SET ARGS=%ARGS%,%ARG_7%
IF DEFINED ARG_8 SET ARGS=%ARGS%,%ARG_8%
IF DEFINED ARG_9 SET ARGS=%ARGS%,%ARG_9%
FOR /F "delims=- tokens=1,2,3*" %%A in ("%ARG_1%") do (
  SET ARG_1=%%A
)

REM Command Line Helper needs to know a few things.
REM The MySettingsINI path is used to hold specific variables you use in your environment.
IF NOT DEFINED IsAdmin CALL:check_Permissions
IF NOT DEFINED IsInstalled (
  CALL:IsInstalled NOSHOW
)
CALL:Settings
IF DEFINED IsInstalled (
  ECHO %IsInstalled%
) ELSE (
  ECHO You should run "setup.bat --Install"
)
IF NOT DEFINED Settings CALL:Settings
CALL:LookupUserSettings
CALL:LookupRemoteConnections

REM This is where the functions are called, but only if an argument has been passed.

IF NOT DEFINED ARGS (
  SET ARGS=--Help
)
ECHO CALL:%ARGS%
CALL:%ARGS%
REM If no arguments were passed it will automatically show the help screen.

REM IF NOT DEFINED ARGS (
REM ECHO CALL:--Help 
REM CALL:--Help
REM )

REM All Done time to clean up any variables and finish.
GOTO :DONE

REM Everything below this line will only be called if a function above has been passed on the command line.

REM Formatout is an internal utility to format text.
REM Small Text Formatter Code Begin

:check_Permissions
    CALL:FORMATOUT 50,50,"Administrative permissions required.","Detecting permissions..."
    net session >nul 2>&1
    if %errorLevel% == 0 (
        CALL:FORMATOUT 50,50,"Success:","Administrative permissions confirmed."
        SET IsAdmin=True
    ) else (
        CALL:FORMATOUT 50,50,"Failed:","Please start a new command window with administrative permissions."
        SET /P _USER_=Press Enter Continue:
        SET ARGS=GoToDone
    )
GOTO:EOF

:GoToDone
SET ARGS=Done
GOTO:EOF

:ReadINI
SET __INI_FILE__=%~1
SET __SEARCH_KEY__=%~2
SET __FIND_KEY__=%~3
SET _INI_RETURN_FILE_=%TEMP%\_INI_RETURN_FILE_.return
SET __INI_VAR_TO_SET__=%~4
SET __ECHO__=%~5
IF DEFINED __ECHO__ ECHO File:%~1 Section:%~2 Key:%~3 ReturnVar:"%~4"
IF EXIST "%_INI_RETURN_FILE_%" DEL /Q "%_INI_RETURN_FILE_%"
IF EXIST "%__INI_FILE__%" (
    FOR /F "delims=* usebackq" %%I in (%__INI_FILE__%) do (
        IF DEFINED _DEBUG_ CALL:DateTime "%~0 I1=%%I"
         FOR /F "tokens=1,2,3 delims==" %%A in ("%%I") do (
            IF DEFINED _DEBUG_ CALL:DateTime "%~0 A1=%%A"
             IF DEFINED _DEBUG_ CALL:DateTime "%~0 B1=%%B"
             IF /I ""=="%%B" (
                IF /I NOT "%%A"=="[%__SEARCH_KEY__%]" (
                    SET __SEARCH_KEY_FOUND__=
                    IF DEFINED _DEBUG_ CALL:DateTime "%~0 SET __SEARCH_KEY_FOUND__^="
                 )
                IF /I "%%A"=="[%__SEARCH_KEY__%]" (
                    SET __SEARCH_KEY_FOUND__=%__SEARCH_KEY__%
                    ECHO.%__SEARCH_KEY__%>"%_INI_RETURN_FILE_%"
                    IF DEFINED _DEBUG_ CALL:DateTime "%~0 SET __SEARCH_KEY_FOUND__^=%__SEARCH_KEY__%"
                 )
            )
        )
        IF EXIST "%_INI_RETURN_FILE_%" (
            IF DEFINED _DEBUG_ CALL:DateTime "%~0 I2=%%I"
             FOR /F "tokens=1,2,3 delims==" %%A in ("%%I") do (
                IF DEFINED _DEBUG_ CALL:DateTime "%~0 A2=%%A"
                 IF DEFINED _DEBUG_ CALL:DateTime "%~0 B2=%%B"
                 IF "%__FIND_KEY__%"=="%%A" SET %__INI_VAR_TO_SET__%=%%B
            )
        )
    )
) ELSE (
    IF DEFINED _DEBUG_ CALL:DateTime "%~0 Could Not Find File:%__INI_FILE__%"
 )
REM Cleanup
SET __INI_FILE__=
SET __SEARCH_KEY__=
SET __FIND_KEY__=
SET __SEARCH_KEY_FOUND__=
SET __INI_VAR_TO_SET__=
IF EXIST "%_INI_RETURN_FILE_%" DEL /Q "%_INI_RETURN_FILE_%"
GOTO:EOF

:--Sleep
CALL:Sleep %~1
GOTO:EOF

:IsInstalled
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","CommandLineHelper","CommandLineHelper",%~1
ENDLOCAL && SET "IsInstalled=%CommandLineHelper%" && SET "CommandLineHelper=%CommandLineHelper%" && SET "_CLHelperDir_=%CommandLineHelper%\Scripts"
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","AlternateAlias","AlternateAlias",%~1
ENDLOCAL && SET "AlternateAlias=%AlternateAlias%"
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:--ReadReg "HKCU\Software\Microsoft\Command Processor","AutoRun","AutoRun",%~1
ENDLOCAL && SET "AutoRunAlias=%AutoRun%"

IF EXIST "%CommandLineHelper%\scripts\cmd\libs" (
    SET CLHLibs=%CommandLineHelper%\scripts\cmd\libs
)
IF EXIST "C:\dev\sandbox\CommandLineHelper\scripts\cmd\libs" (
  SET CLHLibs=C:\dev\sandbox\CommandLineHelper\scripts\cmd\libs
)
IF EXIST "%CD%\scripts\cmd\libs" (
  SET CLHLibs=%CD%\scripts\cmd\libs
)
GOTO:EOF

:Settings
REM The Command Line Helper needs to know where it's installed and where the VB scripts are.
IF NOT EXIST "C:\Windows\System32\cscript.exe" (
  IF NOT DEFINED _CSCRIPT_PATH_ SET /P _CSCRIPT_PATH_=Please provide the path to cscript.
) ELSE (
  SET _CSCRIPT_PATH_=C:\Windows\System32\cscript.exe
)
REM READWRITEINI PATH
IF NOT DEFINED _READWRITEINI_ (
  IF NOT EXIST "%SELF_1%\scripts\vbs\readwriteini.vbs" (
    SET /P _READWRITEINI_=Please provide the path to the readwriteini.vbs.
  ) ELSE (
    SET _READWRITEINI_=%SELF_1%\scripts\vbs\readwriteini.vbs
  )
)
REM READWRITEINI can only handle up to 7000 lines of text. After that it will truncate everything.
CALL:INI_Config
SET _MySettings_=%IsInstalled%\scripts\clhelper.ini
CALL:ReadINI "%_MySettings_%" "Local" "CLHelper_Dir" "FOUND"
IF NOT DEFINED FOUND (
  CALL:--WriteINI "%_MySettings_%" "Local" "CLHelper_Dir" "%IsInstalled%"
)
SET FOUND=
SET Settings=Set
GOTO:EOF

:LookupRubyScripts
CALL:ReadINI "%_MySettings_%" "Ruby" "ScriptsDirectory" "__RubyScripts__"
CALL:ReadINI "%_MySettings_%" "Ruby" "LinuxTools" "__Linux_Tools__"
CALL:CheckRuby
GOTO:EOF

:LookupUserSettings
CALL:ReadINI "%_MySettings_%" "%UserName%" "FirstName" "_FirstName_"
CALL:ReadINI "%_MySettings_%" "%UserName%" "LastName" "_LastName_"
CALL:ReadINI "%_MySettings_%" "%UserName%" "Temporary_Password" "_Temporary_Password_"
CALL:ReadINI "%_MySettings_%" "%UserName%" "PAS" "_PAS_"
CALL:ReadINI "%_MySettings_%" "%UserName%" "My_Dev_Env_Dir" "_My_Dev_Env_Dir_"
CALL:ReadINI "%_MySettings_%" "%UserName%" "MY_SCRIPTS_Dir" "_MY_SCRIPTS_Dir_"
CALL:ReadINI "%_MySettings_%" "%UserName%" "MyUserName" "_MyUserName_"
CALL:ReadINI "%_MySettings_%" "%UserName%" "MyPassword" "_MyPassword_"
CALL:ReadINI "%_MySettings_%","%UserName%","MyDomainOrWorkgroup","_MyDomainOrWorkgroup_"
GOTO:EOF

:LookupRemoteConnections
CALL:ReadINI "%_MySettings_%" "RemoteConnections" "LinuxServers" "__LINUX_SERVERS__"
CALL:ReadINI "%_MySettings_%" "RemoteConnections" "WindowsServers" "__WINDOWS_SERVERS__"
CALL:ReadINI "%_MySettings_%" "RemoteConnections" "TargetServers" "__TARGET__"
CALL:ReadINI "%_MySettings_%" "RemoteConnections" "GoServer" "__GOSERVER__"
CALL:ReadINI "%_MySettings_%" "RemoteConnections" "RemoteScriptsSharedFolder" "__GOSERVER__"
GOTO:EOF

:DebugGet
CALL:ReadINI "%_MySettings_%" "DEBUG" "debug" "_DEBUG_"
GOTO:EOF

:MakeTaskSub
CALL:FORMATOUT 50,12,"%~1:%~2","%TIME%"
GOTO:EOF

:--SetupUserIniSettings
SET UserSettingsVARLIST=FirstName,LastName,MyDomainOrWorkgroup,My_Dev_Env_Dir,MY_Scripts_Dir,MyUserName,MyPassword
FOR /D %%A IN (%UserSettingsVARLIST%) DO (
  SET DEFAULT=
  IF "%%A"=="My_Dev_Env_Dir" (
    SET DEFAULT=c:\dev
  )
  IF "%%A"=="MY_Scripts_Dir" (
    SET DEFAULT=c:\dev\scripts
  )
  CALL:WriteSetting "%USERNAME%","%%A","!DEFAULT!"
)
SET UserSettingsVARLIST=FirstName,LastName,MyDomainOrWorkgroup,My_Dev_Env_Dir,MY_Scripts_Dir,MyUserName,MyPassword
FOR /D %%A IN (LinuxServers,WindowsServers,TargetServers) DO (
  CALL:FORMATOUT 30,50,"File:","%_MySettings_%"
  CALL:FORMATOUT 30,50,"%%A:","servername,servername2"
  CALL:WriteSetting "RemoteConnections","%%A"
)
GOTO :Done
GOTO:EOF

:WriteSetting
SETLOCAL ENABLEDELAYEDEXPANSION
SET "WriteSection=%~1"
SET "WriteKey=%~2"
SET "DefaultValue=%~3"
SET "_KeepCurrent_="
SET "_TEMPNAME_="
CALL:ReadINI "%_MySettings_%" "!WriteSection!" "!WriteKey!" "_TEMPNAME_"
IF /I NOT "!_TEMPNAME_!"=="" (
  CALL:FORMATOUT 30,50,"Keep Current Settings Y/N:","!_TEMPNAME_!"
  SET /P _KeepCurrent_=
)
IF /I "!_KeepCurrent_!" GEQ "N" GOTO :EndWriteSettings
:StartWriteSettings
CALL:FORMATOUT 50,30,"Please Enter your !WriteKey!:",""
IF DEFINED DefaultValue CALL:FORMATOUT 50,30,"Recommended:","!DefaultValue!"
SET /P _WriteKey_=
IF "!_WriteKey_!"=="" CALL:StartWriteSettings
CALL:--WriteINI "!_MySettings_!","!WriteSection!","!WriteKey!","!_WriteKey_!"
:EndWriteSettings
ENDLOCAL && SET "_%~2_=%_WriteKey_%"
GOTO:EOF

:--RegAdd
SETLOCAL ENABLEDELAYEDEXPANSION
REG ADD "%~1" /v "%~2" /t %~3 /d "%~4" %~5
ENDLOCAL
GOTO:EOF

:--ReadINI
CALL:ReadINI "%~1","%~2","%~3","%~4","%~5","%~6"
GOTO:EOF

:--ReadReg
CALL:ReadReg "%~1","%~2","%~3",%~4 
GOTO:EOF

:ReadReg
SETLOCAL ENABLEDELAYEDEXPANSION
set KEY_NAME=%~1
set VALUE_NAME=%~2
set VAR_NAME=%~3
SET NOSHOW=%~4
FOR /F "tokens=1,2,3*" %%A IN ('REG QUERY "%KEY_NAME%" /v %VALUE_NAME% ') DO (
  IF /I "%%B" GEQ "REG" (
    SET Type=%%B
  )
  SET ValueValue=%%C
)
IF NOT DEFINED NOSHOW (
  IF DEFINED ValueValue (
    CALL:FORMATOUT 50,50," ---------------------------------------------------"," ---------------------------------------------------"
    CALL:FORMATOUT 50,50," Key:","Value:"
    CALL:FORMATOUT 50,50," ----"," ------"
    CALL:FORMATOUT 50,50," Name","%KEY_NAME%"
    CALL:FORMATOUT 50,50," REG_Type","%Type%"
    CALL:FORMATOUT 50,50," %VALUE_NAME%","%ValueValue%"
    CALL:FORMATOUT 50,50," ENV:%~3","%ValueValue%"
    CALL:FORMATOUT 50,50," ---------------------------------------------------"," ---------------------------------------------------"
  ) ELSE (
    CALL:FORMATOUT 50,50," ---------------------------------------------------"," ---------------------------------------------------"
    CALL:FORMATOUT 50,50," Result:","Key and Name:"
    CALL:FORMATOUT 50,50," -------"," -------------"
    CALL:FORMATOUT 50,50," Key Not Found!","'%KEY_NAME%' '%VALUE_NAME%'"
  )
)
ENDLOCAL && SET "%~3=%ValueValue%"
GOTO:EOF

:--FindKey
ECHO %~0
SETLOCAL ENABLEDELAYEDEXPANSION
set KEY_NAME=%~1
set VALUE_NAME=%~2
SET NOSHOW=%~3
SET FOUND_KEY=Begin
FOR /F "skip=2 tokens=1*" %%A IN ('REG QUERY "%KEY_NAME%" /S ') DO (
  IF "!FOUND_KEY!"=="Begin" (
    SET "FOUND_KEY=%%A"
  ) ELSE (
    SET "FOUND_KEY=!FOUND_KEY!,%%A"
  )
)
ECHO FOUND_KEYS:"!FOUND_KEY!"
ENDLOCAL && SET FOUND_KEYS=%FOUND_KEY%
GOTO:EOF

REM sleep for x number of seconds

:Sleep
ping -n %1 127.0.0.1 > NUL 2>&1
GOTO:EOF

:FORMATOUT
SETLOCAL ENABLEDELAYEDEXPANSION
  SET __Left__=%~1
  SET __RIGHT__=%~2
  SET "__TEXT__=%~3"
  SET "__OTHER__=%~4 %~5 %~6"
  %CLHLibs%\FORMATOUT.cmd "!__Left__!" "!__RIGHT__!" "!__TEXT__!" "!__OTHER__!"
ENDLOCAL
GOTO:EOF

:--LibsList
cls
CALL %CLHLibs%\LibsList.cmd
GOTO:EOF

REM Small Text Formatter Code End
REM Creates the alias file used when ever a command prompt window loads.

:--CreateAliasFile
SETLOCAL ENABLEDELAYEDEXPANSION
CALL:FORMATOUT 12,12,"Please pick a directory for your alias file.",""
CALL:FORMATOUT 12,12,"We recommend something simple with no spaces.","Like: c:\dev\scripts"
SET /P _AliasFile_=[c:\development\scripts]
IF NOT DEFINED _AliasFile_ SET _AliasFile_=C:\development\scripts
IF NOT EXIST "!_AliasFile_!" MKDIR !_AliasFile_!
REM Disabled command for testing. REG ADD "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d !_AliasFile_!\alias.cmd /f
IF NOT EXIST "!_AliasFile_!\alias.cmd" ECHO.>!_AliasFile_!\alias.cmd
ENDLOCAL && SET AliasFile=%_AliasFile_%\alias.cmd
CALL:FORMATOUT 12,12,"%~1","Created File:%AliasFile%.alias.cmd"
GOTO:EOF

:--Install
CALL:Install_%~1
GOTO:EOF

:--JsonCheck
SETLOCAL ENABLEDELAYEDEXPANSION
:StartJsonCheck
FOR /F "delims== tokens=*" %%A IN ('gem list jsonlint ^| findstr "jsonlint"') DO (
  IF NOT "%%A"=="" (
    SET JsonCheck=%%A
  )
)
ENDLOCAL && SET "JsonCheck=%JsonCheck%"
IF NOT DEFINED JsonCheck gem install jsonlint && goto :StartJsonCheck
IF DEFINED JsonCheck (
  CALL:FORMATOUT 20,20,"Checking File:","%~n1%~x1"
  CALL:FORMATOUT 20,20,"Size:","%~z1"
  CALL:FORMATOUT 20,20,"Date:","%~t1"
  FOR /F "delims== tokens=*" %%A IN ('Ruby.exe "%CommandLineHelper%\scripts\ruby\JsonSyntaxCheck.rb" "%~1"') DO (
    IF NOT "%%A"=="" (
      CALL:FORMATOUT 20,20,"Results:","%%A"
    )
  )
)
SET JsonCheck=
GOTO:EOF

:Install_OpenSSH
SETLOCAL ENABLEDELAYEDEXPANSION
SET _OpenSSH32bit_=http://downloads.sourceforge.net/gnuwin32/openssl-0.9.8h-1-setup.exe
CALL:FORMATOUT 100,50," --------------------------------------------------------------------------------------------------------",""
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" SET _AMD64_=True
IF DEFINED _AMD64_ CALL:FORMATOUT 40,30,"Install 64-bit version","Y/N"
IF NOT DEFINED _AMD64_ CALL:FORMATOUT 40,30,"Install 32-bit version:","Y/N"
SET /P _DOINSTALLGIT_=Do you wish to install OpenSSH?
CALL:FORMATOUT 100,50," --------------------------------------------------------------------------------------------------------",""
IF DEFINED _AMD64_ CALL:FORMATOUT 100,50,"%_OpenSSH32bit_%",""
IF NOT DEFINED _AMD64_ CALL:FORMATOUT 100,50,"%_OpenSSH32bit_%",""
IF DEFINED _AMD64_ (
  SET _DOWNLOAD_=%_OpenSSH32bit_%
) ELSE (
  SET _DOWNLOAD_=%_OpenSSH32bit_%
)
IF /I "%_DOINSTALLGIT_%"=="Y" CALL:Download "%_DOWNLOAD_%","%_CLHelperDir_%\Downloads\Installs"
%_CLHelperDir_%\Downloads\Installs\openssl-0.9.8h-1-setup.exe /NORESTART /VERYSILENT
CALL:FORMATOUT 20,20," ReturnCode:","%ERRORLEVEL%"
ENDLOCAL
GOTO:EOF

:Install_Git
SETLOCAL ENABLEDELAYEDEXPANSION
REM Eventually we need to look up the versions but for now this is not supported.
SET _GIT32bit_=https://github.com/git-for-windows/git/releases/download/v2.13.2.windows.1/Git-2.13.2-32-bit.exe
SET _GIT64bit_=https://github.com/git-for-windows/git/releases/download/v2.13.2.windows.1/Git-2.13.2-64-bit.exe
CALL:FORMATOUT 100,50," --------------------------------------------------------------------------------------------------------",""
IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" SET _AMD64_=True
IF DEFINED _AMD64_ CALL:FORMATOUT 40,30,"Install 64-bit version","Y/N"
IF NOT DEFINED _AMD64_ CALL:FORMATOUT 40,30,"Install 32-bit version:","Y/N"
SET /P _DOINSTALLGIT_=Do you wish to install Git?
CALL:FORMATOUT 100,50," --------------------------------------------------------------------------------------------------------",""
IF DEFINED _AMD64_ CALL:FORMATOUT 100,50,"%_GIT64bit_%",""
IF NOT DEFINED _AMD64_ CALL:FORMATOUT 100,50,"%_GIT32bit_%",""
IF DEFINED _AMD64_ (
  SET _DOWNLOAD_=%_GIT64bit_%
) ELSE (
  SET _DOWNLOAD_=%_GIT32bit_%
)
IF /I "%_DOINSTALLGIT_%"=="Y" CALL:Download "%_DOWNLOAD_%","%_CLHelperDir_%\Downloads\Installs"
ENDLOCAL
GOTO:EOF

:GetConfig
echo %~0
GOTO:EOF

:Download
SETLOCAL ENABLEDELAYEDEXPANSION
CALL:FORMATOUT 40,30," %~0",""
CALL:FORMATOUT 40,30," %~1 '%~2'",""
IF NOT EXIST "%~2" (
  MKDIR %~2
)
SET _STRINGREPLACE_=%~2\%~nx1
SET _STRINGREPLACE_=%_STRINGREPLACE_:\=/%
ECHO powershell -executionPolicy bypass -file "%_CLHelperDir_%\powershell\downloadfile.ps1" "%~1" "%~nx1" "%~2"
powershell -executionPolicy bypass -file "%_CLHelperDir_%\powershell\downloadfile.ps1" "%~1" "%~nx1" "%~2"
IF NOT EXIST "%~2\%~nx1" (
  CALL:FORMATOUT 40,30," Download Failure:","%~0"
) ELSE (
  CALL:FORMATOUT 40,30," Successfully Downloaded:%~1","%~2\%~nx1"
)
GOTO :DoneDownload
ENDLOCAL
:DoneDownload
GOTO:EOF

REM GitForce forces a removes all local changes and then pulls in new clean repo.

:--GitForce
SETLOCAL ENABLEDELAYEDEXPANSION
  git reset HEAD --hard
  git clean -f
  git pull origin master
ENDLOCAL
GOTO:EOF

REM GitCommit pulls down latest and then commits your changes.

:--GitCommit
SETLOCAL ENABLEDELAYEDEXPANSION
  git pull
  git add *
  SET /P __MESSAGE__=Enter a message here.
  git commit -m "%__MESSAGE__%"
  git push
GOTO:EOF

:--Copy
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:-Copy "%~1","%~2"
ENDLOCAL
GOTO:EOF

:-Copy
SETLOCAL ENABLEDELAYEDEXPANSION
  CALL:FORMATOUT 30,50," Running:%~0","%~nx1"
  SET _File_=%~1
  SET _LOCATION_=%~2
  SET _EXISTS_=%~nx1
  IF Exist "!_LOCATION_!\!_EXISTS_!" (
    SET /P __OVERWRITE__=     Y/N
  )
  IF NOT EXIST "!_LOCATION_!" (
    CALL:FORMATOUT 30,50," Make Directory:","!_LOCATION_!"
    MKDIR !_LOCATION_!
    CALL:FORMATOUT 30,50," Make Directory Results:","%ERRORLEVEL%"
  )
  IF EXIST "!_File_!" (
    IF DEFINED __OVERWRITE__ (
      CALL:FORMATOUT 30,50," OVERWRITE:","!__OVERWRITE__!"
    )
    IF NOT "!__OVERWRITE__!"=="N" (
      CALL:FORMATOUT 30,50," Copying File:","!_EXISTS_!"
      COPY /Y !_File_! !_LOCATION_!
      CALL:FORMATOUT 30,50," File Copy Results:","%ERRORLEVEL%"
    )
  ) ELSE (
    CALL:FORMATOUT 30,50," File Not Found:","!_File_!"
  )

  IF EXIST "!_LOCATION_!\!_EXISTS_!" (
    CALL:FORMATOUT 30,50," Results:!_EXISTS_!","Was successfully copied."
  ) ELSE (
    CALL:FORMATOUT 30,50," Results:!_EXISTS_!","Was not successfully copied."
  )
ENDLOCAL
GOTO:EOF

:XCopy
:xcopystart
  SETLOCAL ENABLEDELAYEDEXPANSION
  SET _SOURCE_=%~1
  SET _DESTINATION_=%~2
  IF "%_SOURCE_%"=="" (
    CALL:FORMATOUT 50,50," Please provide a source folder."
    SET /P _SOURCE_=%~1
    IF NOT DEFINED _SOURCE_ GOTO :xcopyfinished
    CALL:FORMATOUT 50,50," Please provide a Destination folder."
    SET /P _DESTINATION_=%~2
    IF NOT DEFINED _SOURCE_ GOTO :xcopyfinished
  )
  CALL:FORMATOUT 50,50," Running:%~0","%~1"
  IF EXIST "%~1" (
    ECHO Would you like to overwrite !_File_! Y/N?
    SET /P __OVERWRITE__=
  )
  IF /I NOT "!__OVERWRITE__!"=="N" ( 
    C:\Windows\System32\xcopy.exe /E /V /I /Y "!_SOURCE_!" "!_DESTINATION_!"
    IF EXIST "%~1" (
      CALL:FORMATOUT 50,50," Results:!_DESTINATION_!","Was successfully copied."
    ) ELSE (
      CALL:FORMATOUT 50,50," Results:!_DESTINATION_!","Was not copied. %ERRORLEVEL%"
    )
  ) ELSE (
    CALL:FORMATOUT 50,50," Results:!_DESTINATION_!","Was not copied."
  )
ENDLOCAL
:xcopyfinished
GOTO:EOF

:--KILLCOMMAND
SET __SPEC__=%~1
IF DEFINED __SPEC__ SET __SPEC__=%~1.%_MyDomainOrWorkgroup_% - Remote Desktop Connection
IF NOT DEFINED __SPEC__ SET __SPEC__=*.%_MyDomainOrWorkgroup_% - Remote Desktop Connection
TASKKILL /FI "WINDOWTITLE eq %__SPEC__%"
GOTO:EOF

:--KILL
SET __SPEC__=%~1
IF DEFINED __SPEC__ TASKKILL /FI "WINDOWTITLE eq %__SPEC__%"
GOTO:EOF

:--KILLPROCESS
SET __SPEC__=%~1
IF DEFINED __SPEC__ TASKKILL /FI "WINDOWTITLE eq %__SPEC__%"
GOTO:EOF

:--RDP
SET __RDP__=%~1
IF DEFINED __RDP__ (
  SET _WINDOWS_SERVERS_=%__RDP__%
) ELSE (
  SET _WINDOWS_SERVERS_=%__WINDOWS_SERVERS__%
)  
cmdkey /list >%TEMP%\lst.txt
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /D %%A IN (%_WINDOWS_SERVERS_%) DO (
  CALL:FORMATOUT 100,50," --------------------------------------------------------------------------------------------------------",""
  CALL:FORMATOUT 20,30," Connecting to:","%%A.%_MyDomainOrWorkgroup_%"
  SET _FOUND_=
  FOR /F "tokens=*" %%G IN ('type %TEMP%\lst.txt ^| findstr ".*%%A.%_MyDomainOrWorkgroup_%.*"') DO (
    ECHO Checking key for:"%%G"
    FOR /F "delims== tokens=1,*" %%H IN ("%%G") DO (
      ECHO Found entry for %%I
      SET _FOUND_=%%A.%_MyDomainOrWorkgroup_%
    )
  )
  IF /I NOT "!_FOUND_!"=="%%A.%_MyDomainOrWorkgroup_%" (
    CALL:FORMATOUT 20,30," Creating cmdkey record:","%%A.%_MyDomainOrWorkgroup_%"
    IF NOT DEFINED _DEBUG_ cmdkey /generic:%%A.%_MyDomainOrWorkgroup_% /user:%_MyUserName_% /pass:%_MyPassword_%
    IF NOT DEFINED _DEBUG_ cmdkey /add:%%A.%_MyDomainOrWorkgroup_% /user:%_MyUserName_% /pass:%_MyPassword_%
  )
  IF NOT DEFINED _DEBUG_ START %windir%\system32\mstsc.exe /v:%%A.%_MyDomainOrWorkgroup_% /W:1024 /H:768 /admin
  CALL:FORMATOUT 100,50," --------------------------------------------------------------------------------------------------------",""
)
ENDLOCAL
del /Q "%TEMP%\lst.txt"
GOTO:EOF

:--SSH_GO
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /D %%A IN (%__GOSERVER__%) DO (
  ECHO._________________________________________________________________________________
  ECHO Connecting to Linux Server: %%A.%_MyDomainOrWorkgroup_%
  IF NOT DEFINED _DEBUG_ START ssh gary@%%A.%_MyDomainOrWorkgroup_% -i %userprofile%\.ssh\id_rsa
  ECHO._________________________________________________________________________________
)
ENDLOCAL
GOTO:EOF

:Linux
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /D %%A IN (%__LINUX_SERVERS__%) DO (
  ECHO._________________________________________________________________________________
  ECHO Connecting to Linux Server: %%A.%_MyDomainOrWorkgroup_%
  IF NOT DEFINED _DEBUG_ START ssh %_MyUserName_%@%%A.%_MyDomainOrWorkgroup_% -i %userprofile%\.ssh\id_rsa
  ECHO._________________________________________________________________________________
)
ENDLOCAL
GOTO:EOF

:--rcmdkey
cmdkey /list >%TEMP%\lst.txt
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /D %%A IN (%__WINDOWS_SERVERS__%) DO (
  ECHO._________________________________________________________________________________
  ECHO Checking for entry: %%A.%_MyDomainOrWorkgroup_%
  SET _FOUND_=
  FOR /F "tokens=*" %%G IN ('type %TEMP%\lst.txt ^| findstr ".*%%A.%_MyDomainOrWorkgroup_%.*"') DO (
    ECHO Checking key for:"%%G"
    FOR /F "delims== tokens=1,*" %%H IN ("%%G") DO (
      ECHO Found entry for %%I
      IF NOT DEFINED _DEBUG_ call cmdkey /delete:%%I
    )
  )
  IF /I NOT "!_FOUND_!"=="" (
    ECHO Removed:%%A.%_MyDomainOrWorkgroup_%
  ) ELSE (
    ECHO Nothing to do for:%%A.%_MyDomainOrWorkgroup_%
  )
  ECHO._________________________________________________________________________________
)
del /Q "%TEMP%\lst.txt"
ENDLOCAL
cmdkey /list >%TEMP%\lst.txt
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /D %%A IN (%__WINDOWS_SERVERS__%) DO (
  ECHO._________________________________________________________________________________
  ECHO Checking for entry: %%A.%_MyDomainOrWorkgroup_%
  SET _FOUND_=
  FOR /F "tokens=*" %%G IN ('type %TEMP%\lst.txt ^| findstr ".*%%A@%_MyDomainOrWorkgroup_%.*"') DO (
    ECHO Checking key for:"%%G"
    FOR /F "delims== tokens=1,*" %%H IN ("%%G") DO (
      ECHO Found entry for %%I
      IF NOT DEFINED _DEBUG_ call cmdkey /delete:%%I
    )
  )
  IF /I NOT "!_FOUND_!"=="" (
    ECHO Removed:%%A.%_MyDomainOrWorkgroup_%
  ) ELSE (
    ECHO Nothing to do for:%%A.%_MyDomainOrWorkgroup_%
  )
  ECHO._________________________________________________________________________________
)
del /Q "%TEMP%\lst.txt"
ENDLOCAL
cmdkey /list >%TEMP%\lst.txt
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /D %%A IN (%__WINDOWS_SERVERS__%) DO (
  ECHO._________________________________________________________________________________
  ECHO Checking for entry: %%A.%_MyDomainOrWorkgroup_%
  SET _FOUND_=
  FOR /F "tokens=*" %%G IN ('type %TEMP%\lst.txt ^| findstr ".*%_MyDomainOrWorkgroup_%.*"') DO (
    ECHO Checking key for:"%%G"
    FOR /F "delims== tokens=1,*" %%H IN ("%%G") DO (
      ECHO Found entry for %%I
      IF NOT DEFINED _DEBUG_ call cmdkey /delete:%%I
    )
  )
  IF /I NOT "!_FOUND_!"=="" (
    ECHO Removed:%%A.%_MyDomainOrWorkgroup_%
  ) ELSE (
    ECHO Nothing to do for:%%A.%_MyDomainOrWorkgroup_%
  )
  ECHO._________________________________________________________________________________
)
del /Q "%TEMP%\lst.txt"
ENDLOCAL
GOTO:EOF

:--BestColor
CALL %CLHLibs%\bestColor.cmd %~1 %~2
GOTO:EOF

:--RandomColor
CALL %CLHLibs%\randomColor.cmd %~1 %~2
GOTO:EOF

REM --WindowsExplorer opens an instance of file system explorer.
REM   Supports 1 directory argument. If no arguments passed the directory
REM   where the command was run will be used.

:--WindowsExplorer
SETLOCAL ENABLEDELAYEDEXPANSION
  IF "%~1"=="" (
    SET _DIR_=%CD%
  ) ELSE (
    SET _DIR_=%~1
  )
  "C:\Windows\explorer.exe" "!_DIR_!"
ENDLOCAL
GOTO:EOF

:INI_Config
SET READ_INI_VALUE="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -r
SET WRITE_INI_VALUE="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -w
SET READ_INI_SECTION="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -rs
SET WRITE_INI_SECTION="%_CSCRIPT_PATH_%" //B "%_READWRITEINI_%" -ws
GOTO:EOF

:--WRITEINI
IF NOT EXIST "%~1" (
  ECHO [%~2] >"%~1"
  ECHO.>>"%~1"
)
%WRITE_INI_VALUE% %~1 %~2 %~3 %~4
CALL:--SLEEP 2
GOTO:EOF

:INI_Func
REM """Reads and writes to ini files. If found section key and value will SET key as varriable."""
SET _INI_RETURN_=
SETLOCAL ENABLEDELAYEDEXPANSION
SET _INI_FILE_=%~1
IF DEFINED _DEBUG_ CALL:DateTime "_INI_FILE_=!_INI_FILE_!"
 SET _INI_RETURN_FILE_=!TEMP!\INI_RETURN_!RANDOM!.log
IF DEFINED _DEBUG_ CALL:DateTime "_INI_RETURN_FILE_=!_INI_RETURN_FILE_!"
 SET _INI_COMMAND_=%~2
IF DEFINED _DEBUG_ CALL:DateTime "_INI_COMMAND_=!_INI_COMMAND_!"
 SET _INI_SECTION_=%~3
IF DEFINED _DEBUG_ CALL:DateTime "_INI_SECTION_=!_INI_SECTION_!"
 SET _INI_KEY_=%~4
IF DEFINED _DEBUG_ CALL:DateTime "_INI_KEY_=!_INI_KEY_!"
 SET _INI_VALUE_=%~5
IF DEFINED _DEBUG_ CALL:DateTime "_INI_VALUE_=!_INI_VALUE_!"
 IF DEFINED _INI_VALUE_ (
    SET _INI_VALUE_=!_INI_VALUE_:_comma_=,!
    SET _INI_VALUE_=!_INI_VALUE_:_backslash_=\!
    SET _INI_VALUE_=!_INI_VALUE_:_and_=^&!
)
SET _RETURN_VALUE=%~6
IF DEFINED _DEBUG_ CALL:DateTime "_RETURN_VALUE=!_RETURN_VALUE!"
 IF DEFINED _INI_COMMAND_ (
    IF DEFINED _DEBUG_ CALL:DateTime "_INI_COMMAND_ hit"
    IF DEFINED _INI_SECTION_ (
    IF DEFINED _DEBUG_ CALL:DateTime "_INI_SECTION_ hit"
        IF DEFINED _INI_KEY_ (
            IF DEFINED _DEBUG_ CALL:DateTime "_INI_KEY_ hit"
            IF /I "!_INI_COMMAND_!"=="-r" (
                    %READ_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" >"%_INI_RETURN_FILE_%"
                    IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
            )
            IF DEFINED _INI_VALUE_ (
                IF DEFINED _DEBUG_ CALL:DateTime "_INI_VALUE_ hit"
                IF /I "!_INI_COMMAND_!"=="-w" (
                    IF DEFINED _DEBUG_ (
                        CALL:DateTime "_INI_COMMAND_ == !_INI_COMMAND_!"
                        CALL:DateTime "%WRITE_INI_VALUE% '%_INI_FILE_%' '!_INI_SECTION_!' '!_INI_KEY_!' '!_INI_VALUE_!'"
                        %WRITE_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" "!_INI_VALUE_!"
                    ) ELSE (
                        %WRITE_INI_VALUE% "%_INI_FILE_%" "!_INI_SECTION_!" "!_INI_KEY_!" "!_INI_VALUE_!" >"%_INI_RETURN_FILE_%"
                    )
                    IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
                )
            )
        )
        IF /I "!_INI_COMMAND_!"=="-rs" (
            %READ_INI_SECTION% "%_INI_FILE_%" "!_INI_SECTION_!" >"%_INI_RETURN_FILE_%"
            IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
        )
        IF /I "!_INI_COMMAND_!"=="-ws" (
            %WRITE_INI_SECTION% "%_INI_FILE_%" "!_INI_SECTION_!" >"%_INI_RETURN_FILE_%"
            IF %ERRORLEVEL% GEQ 1 CALL:SETExitCode_Func %ERRORLEVEL%
        )
    )
)
IF EXIST "!_INI_RETURN_FILE_!" (
    FOR /F %%A IN ('TYPE "!_INI_RETURN_FILE_!"') DO SET _INI_RETURN_=%%A
    DEL "!_INI_RETURN_FILE_!" /Q
)
ENDLOCAL&& SET _INI_RETURN_=%_INI_RETURN_%
IF DEFINED _INI_RETURN_ (
    IF /I "%~2"=="-rs" (
        FOR /F "eol=; tokens=1*" %%A IN ("%_INI_RETURN_%") DO (
            SET INI_RETURN=%_INI_RETURN_%
        )
    ) ELSE (
        FOR /F "tokens=1*" %%A IN ('ECHO "%_INI_RETURN_%" ^| findstr /r "="') DO (
            SET %_INI_RETURN_%
            )
        )
    )
)
GOTO:EOF

:--ls
IF NOT DEFINED CommandLineHelper CALL:IsInstalled
IF NOT DEFINED CommandLineHelper (
  IF EXIST "c:\CommandLineHelper\bin\OpenSSH\bin\ls.exe" SET CommandLineHelper=C:\CommandLineHelper
)
IF DEFINED CommandLineHelper (
  SETLOCAL ENABLEDELAYEDEXPANSION
  SET _PARAMS_=%~1
  IF /I "!_PARAMS_!" GEQ "Help" (
    "%CommandLineHelper%\bin\OpenSSH\bin\ls.exe" --help
  ) ELSE (
    "%CommandLineHelper%\bin\OpenSSH\bin\ls.exe" --color=auto !_PARAMS_!
  )
  ENDLOCAL
) ELSE (
  dir /b
)
GOTO:EOF

:--Help
REM SETLOCAL ENABLEDELAYEDEXPANSION
  IF /I "%ARGS%" GEQ "--Help" (
    CLS
    CALL %CLHLibs%\clhHelp.cmd %SELF_0%
  ) ELSE (
  
  goto :EndHelp
  )
REM ENDLOCAL
:EndHelp
GOTO:EOF

REM Author Information Below

:--About
REM SETLOCAL ENABLEDELAYEDEXPANSION
  IF /I "%ARGS%" GEQ "--About" (
    CLS
    CALL %CLHLibs%\about.cmd %SELF_0%
  ) ELSE (
  
  goto :EndAbout
  )
REM ENDLOCAL
:EndAbout
GOTO:EOF

:DONE

REM Clears Any Default Variables that might have been set while running this batch file.

SET _DEBUG_=
SET _MyPassword_=
SET _CLEAN_=
SET ARGS=
SET __RUNONCEONLY__=
GOTO :Finished

:Finished
