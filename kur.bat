@echo off
title Kuyumcu Canli Fiyat Panosu - Kurulum
setlocal
set "HEDEF=C:\kuyumcu"
set "KAYNAK=%~dp0"

echo.
echo  ==========================================================
echo   KUYUMCU CANLI FIYAT PANOSU - KURULUM
echo  ==========================================================
echo.
echo   Pano su klasore kurulacak:  %HEDEF%
echo.

if not exist "%KAYNAK%index.html" (
  echo  HATA: index.html bu klasorde bulunamadi. kur.bat dosyasi index.html ile ayni klasorde olmali.
  pause & exit /b 1
)

echo  [1/4] Dosyalar kopyalaniyor...
if not exist "%HEDEF%" mkdir "%HEDEF%" 2>nul
if not exist "%HEDEF%" (
  set "HEDEF=%LOCALAPPDATA%\kuyumcu"
  echo        C:\kuyumcu olusturulamadi, %LOCALAPPDATA%\kuyumcu kullanilacak.
  mkdir "%HEDEF%" 2>nul
)
if not exist "%HEDEF%\araclar" mkdir "%HEDEF%\araclar"
if not exist "%HEDEF%\ayar" mkdir "%HEDEF%\ayar"
copy /y "%KAYNAK%index.html"        "%HEDEF%\" >nul
copy /y "%KAYNAK%pano-baslat.bat"   "%HEDEF%\" >nul
copy /y "%KAYNAK%pano-kapat.bat"    "%HEDEF%\" >nul
copy /y "%KAYNAK%ekran-sec.bat"     "%HEDEF%\" >nul
copy /y "%KAYNAK%hesap-ac.bat"      "%HEDEF%\" >nul
copy /y "%KAYNAK%araclar\pano.ps1"  "%HEDEF%\araclar\" >nul
if exist "%KAYNAK%KURULUM.md" copy /y "%KAYNAK%KURULUM.md" "%HEDEF%\" >nul
echo        Tamam.

echo  [2/4] Kisayollar ve guc ayarlari...
powershell -NoProfile -ExecutionPolicy Bypass -File "%HEDEF%\araclar\pano.ps1" -Islem kur
if errorlevel 1 ( echo  HATA: kisayollar olusturulamadi. & pause & exit /b 1 )

echo  [3/4] Ekran secimi...
echo        TV bagliysa Windows'un "Genislet" modunda olmasi gerekir (Win+P ^> Genislet).
powershell -NoProfile -ExecutionPolicy Bypass -File "%HEDEF%\araclar\pano.ps1" -Islem sec

echo  [4/4] Pano baslatiliyor...
powershell -NoProfile -ExecutionPolicy Bypass -File "%HEDEF%\araclar\pano.ps1" -Islem baslat

echo.
echo  ==========================================================
echo   KURULUM TAMAMLANDI
echo  ==========================================================
echo   - Bilgisayar her acildiginda pano kendiliginden acilir.
echo   - Masaustu kisayollari:  "Panoyu Ac", "Panoyu Kapat", "Pano - Ekran Sec",
echo     "Tezgah Hesaplayici" (gram gir, iscilikli fiyat / hurda alis / takas)
echo   - Ilk acilista panoda  (ayarlar) simgesinden dukkan adi ve
echo     komisyonlari girin, "Kaydet" deyin. Ayarlar bu bilgisayarda kalir.
echo   - Internet baglantisi sart (Harem Altin canli veri).
echo.
pause
endlocal
