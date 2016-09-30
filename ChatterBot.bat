@echo OFF
:restart
Setlocal EnableDelayedExpansion
title Chatterbot

rem // By my convention, the chat log will be stored in C:\Users\pcischip\tmp\chatLog.txt of each computer
rem // !!! ONLY REFRESHES after you press ENTER!
rem // chat log will probably lag after too many messages are sent which is why you have to delete it
rem // which is why you have to delete it


rem // PREPARATION
set msg=""
set thePath=%USERPROFILE:~3%\tmp
if not Exist C:\%thePath% mkdir C:\%thePath%

set myLog=C:\%thePath%\chatlog.txt

rem // Preparing IP's
rem // Get own IP
ipconfig | findstr "IPv4 Address" > C:\%thePath%\myIP.txt
set myIPtxt=C:\%thePath%\myIP.txt
for /f "tokens=2 delims=:" %%a in (%myIPtxt%) do @set myIP=%%a
for /f "tokens=* delims= " %%a in ("%myIP%") do @set myIP=%%a
del %myIPtxt%
title Chatterbot: %myIP%

rem // display your IP
echo Your IP: %myIP%

rem // Get partner's IP



set /p yourIP="Your Partner's IP: "
set yourLog=\\%yourIP%\%thePath%\chatlog.txt

:username
set /p name="Username: "


:menu
rem // Options
echo Welcome to Chatterbot, %name%^^! Type an option and press Enter.
echo 1: Delete chat log
echo 2: Start messaging
echo 3: Restart
if Exist C:\%thePath%\isOpen.txt del C:\%thePath%\isOpen.txt
set /p opt="> "
cls


rem // 1. Delete my chat log
if %opt%==1 (
	if Exist %myLog% (
		del %myLog%
		echo Deleting %myLog%
		echo.
		goto menu
	)

	echo %myLog% already deleted
	echo.
	goto menu
)

rem // 2. Start Messaging

if %opt%==2 (
	rem // MAIN PROGRAM
	cls

	rem // CONNECT WITH OTHER PERSON
	echo Open to Chat > C:\%thePath%\isOpen.txt


	echo Connecting to your chattermate...
:waiting
	if not Exist \\%yourIP%\%thePath%\isOpen.txt (
		cls
		echo Waiting for your chattermate...
		ping %yourIP% -n 5 > nul
		goto waiting
	)


	echo Start Chatting!
rem MAIN LOOP

goto refresh
:chat
	if not exist %yourLog% copy NUL %yourLog% > NUL
	set /p msg="> "
	echo %name%: !msg! >> %myLog%
	copy %myLog% %yourLog%	
	

:refresh
	rem // REFRESH
	cls
	if exist %myLog% (
		copy %yourLog% %myLog% > nul
		type %myLog%
	)

	
	choice /n /c RQ /t 3 /d R /m "Press Q to chat. Press R to refresh."
	if %errorlevel%==1 goto refresh
	if %errorlevel%==2 ( 
		echo. 
		goto chat
	)

)

if %opt%==3 (
	goto restart
)

goto menu