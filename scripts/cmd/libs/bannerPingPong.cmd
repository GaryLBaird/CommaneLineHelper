@ECHO OFF
SET FORMATOUT=%~p0\formatout.cmd
%1 %2
GOTO :Done
:bannerPingPong varref -- moves text in varref one step left or right and updates title
::                     -- varref [in,out] - variable name with banner text, format: "Banner Text------"
:$created 20060101 :$changed 20080219
:$source http://www.dostips.com
SETLOCAL ENABLEDELAYEDEXPANSION
set s=!%~1: =-!
if "!s:~-1!" NEQ "-" if "!s:~-1!" NEQ "+" set s=!s!--------
set d=!s:~-1!
if "!s:~0,1!" NEQ "-" set d=+
if "!s:~-2,1!" NEQ "-" set d=-
if "!d!"=="+" (set s=-!s:~0,-2!+) ELSE (set s=!s:~1,-1!--)
TITLE !s!
( ENDLOCAL & REM RETURN VALUES
    IF "%~1" NEQ "" SET %~1=%s%
)
GOTO :Done

:FORMATOUT
  CALL %FORMATOUT% %~1 %~2 "%~3" "%~4%~5%~6"
GOTO:EOF

:Done