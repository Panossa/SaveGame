@echo off
::Pull data
git pull
::Copy all of the save data into the right folder
copy /y *.sav "../SaveGames"

::Start Satis, wait for end
set start=%date:~0,2%-%date:~3,2%-%date:~8,2%@%time:~0,5%
start "" "S:\Programme\Paragon\SatisfactoryEarlyAccess\FactoryGame\Binaries\Win64\FactoryGame-Win64-Shipping.exe"
echo Waiting for game to close...

:LOOP
::>nul 2>&1
tasklist | find /i "FactoryGame-Win64-Shippin" >nul 2>&1
IF ERRORLEVEL 1 (
  :: not running any more, you paralympic
  GOTO CONTINUE
) ELSE (
  :: still running
  TIMEOUT /T 5 /Nobreak >nul
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
git commit -m %msg%
git push
echo Save game uploaded!
PAUSE
