@ECHO OFF
:: Alias is run every time you open a command window
:: About this alias file. The begin and end statements are used for automation. You can 
::  remove them, but doing so will result in breaking the upgrade features in the future. 
:: Special Note(s):
:: 1. Don't use the command "cls" in your alias file.
:: 2. Don't use "ECHO" in your alias file because it add un-necessary text to a "For %%A IN ('something') do %%A" each loop.

::::  SETTINGS BEGIN ::::
:: Set Default Variables Begin ::
SET _CLHScripts_=c:\CommaneLineHelper\Scripts
SET _READWRITEINI_=%_CLHScripts_%\vbs\readwriteini.vbs
SET CLHelper=%_CLHScripts_%\CLHelper.bat
:: Set Default Variables End ::

:: Create Default Directories Begin ::
IF NOT EXIST "%_CLHScripts_%\vbs\" (
  MKDIR %_CLHScripts_%\vbs\
)
IF NOT EXIST "%_CLHScripts_%\logs\" (
  MKDIR %_CLHScripts_%\logs\
)
:: Create Default Directories End ::

:: Doskey Commands Begin ::

:: Add Temporary Path Assignments Begin ::
DOSKEY add_python26=set PATH=%PATH%;"C:\Python26\"
DOSKEY add_python33=set PATH=%PATH%;"C:\Python33\"
:: Add Temporary Path Assignments End ::

:: Regular Expression Pattern Search Begin ::
DOSKEY FindString=cscript.exe //Nologo //T:15 %_CLHScripts_%\vbs\vbs\txtComp.vbs --PatternMatch $1 $2
:: Regular Expression Pattern Search End ::

:: Aliases for Shutdown Commands Begin ::
DOSKEY logout=Shutdown -l
DOSKEY logoff=Shutdown -l
DOSKEY restart=Shutdown -g -t 30 -c "Because %_USERNAME_% said to restart." -f
DOSKEY forceoff=Shutdown /p
DOSKEY shutoff=Shutdown -s -t 30 -c "Because %_USERNAME_% said to shutdown."
DOSKEY Hibernate=Shutdown -h
DOSKEY rshutdown=Shutdown -i
DOSKEY abort=Shutdown -a
DOSKEY lock=rundll32.exe user32.dll, LockWorkStation
:: Aliases for Shutdown Commands End ::

:: Aliases for Microsoft Office Products Begin ::
DOSKEY word="c:\Program Files\Microsoft Office\Office15\winword.exe" $*
DOSKEY mspub="c:\Program Files\Microsoft Office\Office15\mspub.exe" $*
DOSKEY outlook="c:\Program Files\Microsoft Office\Office15\outlook.exe" $*
DOSKEY ppt="c:\Program Files\Microsoft Office\Office15\powerpnt.exe" $*
DOSKEY excel="c:\Program Files\Microsoft Office\Office15\excel.exe" $*
DOSKEY excell="c:\Program Files\Microsoft Office\Office15\excel.exe" $*
DOSKEY xls="c:\Program Files\Microsoft Office\Office15\excel.exe" $*
DOSKEY xlsx="c:\Program Files\Microsoft Office\Office15\excel.exe" $*
:: Aliases for Microsoft Office Products End ::

:: Custom Alias Keys Begin ::
DOSKEY np="C:\Program Files (x86)\Notepad++\notepad++.exe" $*
DOSKEY CLHelper=%CLHelper% $*
DOSKEY GitForce=%CLHelper% --GitForce $*
DOSKEY GitCommit=%CLHelper% --GitCommit $*
DOSKEY explorer=%CLHelper% --WindowsExplorer $*
:: Custom Alias Keys Begin ::

:: Doskey Commands End ::

GOTO :DONE

:: Logic Functions Begin ::
:: Logic Functions End ::

:DONE
:: Run Functions Begin ::
:: Run Functions End ::
::::  SETTINGS END ::::