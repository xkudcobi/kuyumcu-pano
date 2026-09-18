@echo off
title Pano - Ekran Sec
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0araclar\pano.ps1" -Islem sec
echo.
echo Panoyu yeni ekranda acmak icin baslatiliyor...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0araclar\pano.ps1" -Islem baslat
pause
