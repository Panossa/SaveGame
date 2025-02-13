@echo off
::Pull data
git pull
::Copy all of the save data into the right folder
copy /y *.sav "../SaveGames"

::Grab Satis Path
set /P satispath=Which version? Normal(n) or experimental(e)? 
IF %satispath% == n (
	set satispath="com.epicgames.launcher://apps/CrabEA?action=launch"
) ELSE (
	IF %satispath% == e (
		set satispath="com.epicgames.launcher://apps/CrabTest?action=launch"
	) ELSE (
		echo WTF, just put in "n" or "e".
	)
)
::Timestamp for the start
set start=%date:~0,2%-%date:~3,2%-%date:~8,2%@%time:~0,5%
::Start Satis, wait for end
start "" %satispath%
echo Waiting for the game to start (10 seconds)
TIMEOUT /T 10 /Nobreak >nul
echo Waiting for game to close...

:LOOP
::>nul 2>&1
tasklist | find /i "FactoryGame-Win64-Shippin" >nul 2>&1
IF ERRORLEVEL 1 (
  :: not running any more, you paralympic
  GOTO CONTINUE
) ELSE (
  :: still running
  TIMEOUT /T 10 /Nobreak >nul
  GOTO LOOP
)

:CONTINUE
::copy new save file(s)
set msg=%start% till %date:~0,2%-%date:~3,2%-%date:~8,2%@%time:~0,5%
cd "../SaveGames"
copy /y *.sav "../satissaves"
cd "../satissaves"
::Push data
git add *.sav
git add *.bat
git commit -m "%msg%"
git push
echo Save game uploaded!
PAUSE