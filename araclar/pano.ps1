# Kuyumcu Canli Fiyat Panosu - yardimci arac
# Kullanim:  powershell -ExecutionPolicy Bypass -File pano.ps1 -Islem baslat|kapat|sec|kur|hesap
param([Parameter(Mandatory=$true)][ValidateSet('baslat','kapat','sec','kur','hesap')][string]$Islem)

$ErrorActionPreference = 'Stop'
$Kok       = Split-Path -Parent $PSScriptRoot            # C:\kuyumcu
$Sayfa     = Join-Path $Kok 'index.html'
$AyarKlas  = Join-Path $Kok 'ayar'
$EkranCfg  = Join-Path $AyarKlas 'ekran.txt'
$Profil    = Join-Path $env:LOCALAPPDATA 'KuyumcuPanoProfil'   # panoya ozel tarayici profili (normal Chrome'a karismaz)
$Etiket    = 'KuyumcuPanoProfil'                                # calisan panoyu bulmak icin komut satirinda aranir

Add-Type -AssemblyName System.Windows.Forms
Add-Type @"
using System;
using System.Runtime.InteropServices;
public static class Win {
  [DllImport("user32.dll")] public static extern bool SetProcessDPIAware();
  [DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h, IntPtr after, int x, int y, int cx, int cy, uint flags);
  [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
  [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
  [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
  [DllImport("user32.dll", CharSet=CharSet.Unicode)] public static extern int GetWindowText(IntPtr h, System.Text.StringBuilder s, int n);
  public delegate bool EnumProc(IntPtr h, IntPtr l);
  [DllImport("user32.dll")] public static extern bool EnumWindows(EnumProc cb, IntPtr l);
  static IntPtr bulunan; static string aranan;
  static bool Cb(IntPtr h, IntPtr l) {
    if (!IsWindowVisible(h)) return true;
    var sb = new System.Text.StringBuilder(512); GetWindowText(h, sb, 512);
    if (sb.ToString().IndexOf(aranan, StringComparison.OrdinalIgnoreCase) >= 0) { bulunan = h; return false; }
    return true;
  }
  // Basliginda verilen metin gecen ilk gorunur pencereyi bulur (tezgah penceresini yakalamak icin)
  public static IntPtr FindByTitle(string part) { aranan = part; bulunan = IntPtr.Zero; EnumWindows(Cb, IntPtr.Zero); return bulunan; }
}
"@
[void][Win]::SetProcessDPIAware()   # ekran koordinatlari gercek piksel olsun

function Ekranlar {
  [System.Windows.Forms.Screen]::AllScreens | Sort-Object { $_.Bounds.X }, { $_.Bounds.Y }
}

function Tarayici {
  $adaylar = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
  )
  foreach ($p in $adaylar) { if (Test-Path $p) { return $p } }
  throw 'Chrome veya Edge bulunamadi. Lutfen Google Chrome kurun.'
}

function PanoSurecleri {
  Get-CimInstance Win32_Process -Filter "Name='chrome.exe' OR Name='msedge.exe'" |
    Where-Object { $_.CommandLine -and $_.CommandLine -like "*$Etiket*" }
}

function EkranSec {
  $liste = @(Ekranlar)
  Write-Host ''
  Write-Host '=== Bagli ekranlar ===' -ForegroundColor Yellow
  for ($i = 0; $i -lt $liste.Count; $i++) {
    $e = $liste[$i]; $b = $e.Bounds
    $ana = if ($e.Primary) { ' (ANA EKRAN - bilgisayarin kendi ekrani)' } else { '' }
    Write-Host ("  [{0}]  {1}x{2}  konum {3},{4}{5}" -f ($i+1), $b.Width, $b.Height, $b.X, $b.Y, $ana)
  }
  Write-Host ''
  if ($liste.Count -eq 1) {
    Write-Host 'Sadece 1 ekran gorunuyor.' -ForegroundColor Cyan
    Write-Host 'TV bagliysa Windows "Yinele/Cogalt" modunda olabilir; "Genislet" moduna gecmek gerekir.'
    $c = Read-Host 'Simdi "Genislet" moduna gecilsin mi? (E/H)'
    if ($c -match '^[Ee]') {
      Start-Process 'DisplaySwitch.exe' '/extend' -Wait
      Start-Sleep 3
      $liste = @(Ekranlar)
      if ($liste.Count -gt 1) { return EkranSec }
      Write-Host 'Hala tek ekran var. TV kablosunu kontrol edip daha sonra "Ekran Sec" kisayolunu tekrar calistirin.' -ForegroundColor Yellow
    }
    Set-Content -Path $EkranCfg -Value '1' -Encoding ASCII
    Write-Host 'Pano tek ekranda normal pencere olarak acilacak (F tusu ile tam ekran).'
    return
  }
  $varsayilan = 1
  for ($i = 0; $i -lt $liste.Count; $i++) { if (-not $liste[$i].Primary) { $varsayilan = $i + 1; break } }
  $sec = Read-Host "Pano hangi ekranda gosterilsin? [1-$($liste.Count)] (Enter = $varsayilan)"
  if (-not ($sec -match '^\d+$') -or [int]$sec -lt 1 -or [int]$sec -gt $liste.Count) { $sec = $varsayilan }
  Set-Content -Path $EkranCfg -Value $sec -Encoding ASCII
  Write-Host "Secildi: ekran $sec. Kaydedildi." -ForegroundColor Green
}

function PanoKapat {
  $s = @(PanoSurecleri)
  if ($s.Count -eq 0) { Write-Host 'Pano acik degil.'; return }
  foreach ($p in $s) { try { Stop-Process -Id $p.ProcessId -Force -ErrorAction SilentlyContinue } catch {} }
  Start-Sleep -Milliseconds 800
  Write-Host 'Pano kapatildi.' -ForegroundColor Green
}

function PanoBaslat {
  if (-not (Test-Path $Sayfa)) { throw "index.html bulunamadi: $Sayfa" }
  PanoKapat | Out-Null
  $exe = Tarayici
  $liste = @(Ekranlar)
  $idx = 1
  if (Test-Path $EkranCfg) { $t = (Get-Content $EkranCfg -Raw).Trim(); if ($t -match '^\d+$') { $idx = [int]$t } }
  if ($idx -lt 1 -or $idx -gt $liste.Count) { $idx = 1 }
  $hedef = $liste[$idx - 1]
  $b = $hedef.Bounds
  $cokluEkran = $liste.Count -gt 1
  $url = 'file:///' + ($Sayfa -replace '\\', '/')

  $args = @(
    "--user-data-dir=`"$Profil`"",
    '--no-first-run', '--no-default-browser-check', '--disable-session-crashed-bubble',
    '--noerrdialogs', '--disable-infobars', '--disable-features=Translate,TranslateUI',
    '--overscroll-history-navigation=0', '--autoplay-policy=no-user-gesture-required',
    "--window-position=$($b.X),$($b.Y)", "--window-size=$($b.Width),$($b.Height)"
  )
  if ($cokluEkran) { $args += '--start-fullscreen'; $args += "--app=`"$url`"" }   # TV: tam ekran, adres cubugu yok (kiosk degil: tezgah penceresi ayni profilde normal acilabilsin)
  else             { $args += "--app=`"$url`"" }                   # tek ekran: normal pencere

  Start-Process -FilePath $exe -ArgumentList $args | Out-Null

  # Pencereyi bulup secilen ekrana tasi (DPI farklarina karsi) ve TV'de en uste sabitle
  $hwnd = [IntPtr]::Zero
  for ($i = 0; $i -lt 40 -and $hwnd -eq [IntPtr]::Zero; $i++) {
    Start-Sleep -Milliseconds 500
    foreach ($p in @(PanoSurecleri)) {
      try { $pr = Get-Process -Id $p.ProcessId -ErrorAction SilentlyContinue; if ($pr -and $pr.MainWindowHandle -ne 0) { $hwnd = $pr.MainWindowHandle; break } } catch {}
    }
  }
  if ($hwnd -ne [IntPtr]::Zero) {
    $HWND_TOPMOST = [IntPtr](-1); $HWND_NOTOPMOST = [IntPtr](-2); $SWP_SHOWWINDOW = 0x40
    if ($cokluEkran) {
      [void][Win]::SetWindowPos($hwnd, $HWND_TOPMOST, $b.X, $b.Y, $b.Width, $b.Height, $SWP_SHOWWINDOW)
    } else {
      [void][Win]::SetWindowPos($hwnd, $HWND_NOTOPMOST, $b.X + 40, $b.Y + 40, [int]($b.Width * 0.85), [int]($b.Height * 0.85), $SWP_SHOWWINDOW)
    }
  }
  Write-Host ("Pano acildi: ekran {0} ({1}x{2}) - {3}" -f $idx, $b.Width, $b.Height, (Split-Path $exe -Leaf)) -ForegroundColor Green
}

# Tezgah hesaplayicisi: ayni tarayici profiliyle (ayarlar ortak) ayri pencerede, panonun OLMADIGI ekranda acilir
function HesapAc {
  if (-not (Test-Path $Sayfa)) { throw "index.html bulunamadi: $Sayfa" }
  $exe = Tarayici
  $liste = @(Ekranlar)
  $panoIdx = 1
  if (Test-Path $EkranCfg) { $t = (Get-Content $EkranCfg -Raw).Trim(); if ($t -match '^\d+$') { $panoIdx = [int]$t } }
  $hedef = $liste | Where-Object { $_.Primary } | Select-Object -First 1
  if ($liste.Count -gt 1 -and $panoIdx -ge 1 -and $panoIdx -le $liste.Count -and $liste[$panoIdx - 1].Primary) {
    $hedef = $liste | Where-Object { -not $_.Primary } | Select-Object -First 1
  }
  if (-not $hedef) { $hedef = $liste[0] }
  $b = $hedef.WorkingArea
  $w = [Math]::Min(1280, $b.Width - 60); $h = [Math]::Min(880, $b.Height - 60)
  $x = $b.X + [int](($b.Width - $w) / 2); $y = $b.Y + [int](($b.Height - $h) / 2)
  $url = 'file:///' + ($Sayfa -replace '\\', '/') + '?view=hesap'
  $args = @("--user-data-dir=`"$Profil`"", '--no-first-run', '--no-default-browser-check', "--window-position=$x,$y", "--window-size=$w,$h", "--app=`"$url`"")
  Start-Process -FilePath $exe -ArgumentList $args | Out-Null
  # Pano acik ise Chrome yeni pencereyi ayni surecte acar ve konum parametrelerini yok sayabilir -> pencereyi bulup tasi
  $hwnd = [IntPtr]::Zero
  for ($i = 0; $i -lt 30 -and $hwnd -eq [IntPtr]::Zero; $i++) { Start-Sleep -Milliseconds 400; $hwnd = [Win]::FindByTitle('Tezgah Hesaplay') }
  if ($hwnd -ne [IntPtr]::Zero) {
    [void][Win]::SetWindowPos($hwnd, [IntPtr](-2), $x, $y, $w, $h, 0x40)
    [void][Win]::SetForegroundWindow($hwnd)
  }
  Write-Host ("Tezgah hesaplayici acildi ({0}x{1}). Ayarlar panoyla ortaktir." -f $w, $h) -ForegroundColor Green
}

function Kur {
  New-Item -ItemType Directory -Force -Path $AyarKlas | Out-Null
  $ws = New-Object -ComObject WScript.Shell
  $baslangic = [Environment]::GetFolderPath('Startup')
  $masaustu  = [Environment]::GetFolderPath('Desktop')

  function Kisayol($yol, $hedef, $aciklama) {
    $k = $ws.CreateShortcut($yol)
    $k.TargetPath = $hedef
    $k.WorkingDirectory = $Kok
    $k.WindowStyle = 7          # kucultulmus baslat
    $k.Description = $aciklama
    $k.IconLocation = 'shell32.dll,15'
    $k.Save()
  }
  Kisayol (Join-Path $baslangic 'Kuyumcu Pano.lnk')      (Join-Path $Kok 'pano-baslat.bat') 'Bilgisayar acilinca panoyu baslatir'
  Kisayol (Join-Path $masaustu  'Panoyu Ac.lnk')         (Join-Path $Kok 'pano-baslat.bat') 'Fiyat panosunu acar'
  Kisayol (Join-Path $masaustu  'Panoyu Kapat.lnk')      (Join-Path $Kok 'pano-kapat.bat')  'Fiyat panosunu kapatir'
  Kisayol (Join-Path $masaustu  'Pano - Ekran Sec.lnk')  (Join-Path $Kok 'ekran-sec.bat')   'Panonun hangi ekranda cikacagini secer'
  Kisayol (Join-Path $masaustu  'Tezgah Hesaplayici.lnk') (Join-Path $Kok 'hesap-ac.bat')    'Gram gir, iscilikli fiyat / hurda alis / takas hesapla'
  $th = $ws.CreateShortcut((Join-Path $masaustu 'Tezgah Hesaplayici.lnk')); $th.IconLocation = 'shell32.dll,21'; $th.Save()
  $ek = $ws.CreateShortcut((Join-Path $masaustu 'Pano - Ekran Sec.lnk')); $ek.WindowStyle = 1; $ek.Save()

  # Uyku / ekran kapanmasini kapat (prizde)
  foreach ($c in @('monitor-timeout-ac 0','standby-timeout-ac 0','hibernate-timeout-ac 0')) {
    try { Start-Process powercfg -ArgumentList "/change $c" -WindowStyle Hidden -Wait } catch {}
  }
  Write-Host 'Kisayollar olusturuldu, uyku ayarlari kapatildi.' -ForegroundColor Green
}

switch ($Islem) {
  'sec'    { EkranSec }
  'kapat'  { PanoKapat }
  'baslat' { PanoBaslat }
  'kur'    { Kur }
  'hesap'  { HesapAc }
}
