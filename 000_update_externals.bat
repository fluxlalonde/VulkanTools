set OLDDIR=%CD%

cd "C:\Program Files (x86)\Microsoft Visual Studio 14.0"
call "Common7\Tools\VsDevCmd.bat"

@set PATH=C:\Program Files\CMake\bin;%PATH%

cd %OLDDIR%
call ".\update_external_sources.bat" --all

REM look at build_windows_targets.bat

@pause
