@ECHO OFF 
:choice
echo Welcome to Power-Search install!
echo By installing and continuing, you agree that the author of Power-Search is NOT responsible for any searches you make with Power-Search, any damages caused during or after instalation to your or any other machine, or any damages caused with Power-Search.
echo By editing this script or any part of Power-Search, you agree that you are resonsible for anything done with the edited version.

set /P c=Are you sure you want to continue[Y/n]?
if /I "%c%" EQU "Y" goto :install
if /I "%c%" EQU "n" goto :no-install
goto :choice


:install 
echo Downloading...
curl -o Power-Search.ps1 https://power-search.netlify.app/Power-Search.ps1
curl -o Power-Search.bat https://power-search.netlify.app/Power-Search.bat
curl -o powser.bat https://power-search.netlify.app/powser.bat
mkdir "C:\Power-Search" 
copy Power-Search.ps1 "C:\Power-Search" 
copy Power-Search.bat "C:\Power-Search" 
copy powser.bat "C:\Power-Search"
del Power-Search.ps1
del Power-Search.bat
del powser.bat
echo Power-Search script copied to C:\Power-Search
echo "Would you like to add Power-Search to PATH?"
:choice2
set /p "q=Add Power-Search to PATH? [Y/n]:"
if /I "%q%" EQU "Y" goto :path-install
if /I "%q%" EQU "n" goto :finish-install
goto :choice2

:path-install
echo Downloading add to PATH script...
curl -o Add-To-PATH.ps1 https://power-search.netlify.app/Add-To-PATH.ps1
echo Running script...
powershell -file Add-To-PATH.ps1
del Add-To-PATH.ps1
echo Finished!
echo If you haven't gotten any errors, congratulations! Power-Search should be installed.
echo "To use it, just do <Power-Search [Search]>! If you get an error about scripts being disabled on your system, run <powershell Set-ExecutionPolicy Unrestricted> as administrator. If you prefer, the <powser [Search]>" command also will run the script, allowing for an easier command to remember and one that can be typed without a pesky dash."
cmd /c pause
exit

:finish-install
echo Very fair choice, setx can be weird. No matter, if you haven't encountered any errors yet, you're finished! Power-Search should be installed.
echo "To use Power-Search, just do <C:/Power-Search/Power-Search [Search]>. Since it's not added to PATH it's a bit finicky, but it should be useable. If you get an error about scripts being disabled on your system, run <powershell Set-ExecutionPolicy Unrestricted> as administrator. Thanks for installing :D"
cmd /c pause
exit

:no-install
echo Understandable! Have a wonderful day :D 
cmd /c pause
exit
