@echo off
setlocal

@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"

set "QT5_DIR=C:\Qt\5.12.2\msvc2017_64"
set "PATH=%PATH%;%QT5_DIR%\bin"

rem Configure the application in the current directory
cmake ^
    -G"NMake Makefiles" ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_PREFIX=out ^
    %~dp0\..\.. || exit /b

rem Build and install the application
nmake || exit /b
nmake install || exit /b

rem Run windeployqt on tom-ui
echo "running windeployqt..."
windeployqt ^
    --verbose 0 ^
    --no-compiler-runtime ^
    --no-angle ^
    --no-opengl-sw ^
    out\bin\tom-ui.exe || exit /b

echo "-- Building tom..."
go get -u github.com/jansorg/tom
go build -o out\bin\tom.exe github.com/jansorg/tom

echo "-- Building installer..."

rem Find the path to InnoSetup from the registry
set rkey="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Inno Setup 5_is1"
for /f "skip=2 tokens=1,2*" %%i in ('reg query %rkey% /v InstallLocation /reg:32') DO (
    set iscc="%%kiscc.exe"
)

rem Make sure that the ISCC compiler exists
if not exist %iscc% (
    echo "Unable to find the InnoSetup compiler"
    exit /b
)

rem Build the installer
echo "-- Calling %iscc%..."
%iscc% ^
    /Q ^
    /DPREFIX="%cd%\out" ^
    setup.iss || exit /b