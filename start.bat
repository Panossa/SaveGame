@echo off
::Pull data
git init
git clone https://github.com/bsavage81/blockbench-plugins.git

::Start Satis, wait for end
START "" "S:\Programme\Paragon\SatisfactoryEarlyAccess\FactoryGame\Binaries\Win64\FactoryGame-Win64-Shipping.exe"
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
::Push data
del /f /q /s blockbench-plugins
del /f /q /s .git
git init
git clone https://github.com/bsavage81/blockbench-plugins.git
echo Save game uploaded!
PAUSE
