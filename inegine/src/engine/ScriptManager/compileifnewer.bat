@echo off

if not exist %1 goto FileNotFound
if not exist %2 goto Compile

fc %1 %2 
if %ERRORLEVEL%==0 GOTO NoCopy

echo Files are not the same.  Copying %1 over %2
goto Compile

:NoCopy
echo Files are the same.  Did nothing
goto END

:FileNotFound
echo %1 not found.
goto END

:Compile
echo Compiling files
copy %1 %2 /y
coco %1
goto END

:END
echo Done.

