# Kuyumcu Canlı Fiyat Panosu — Kurulum Kılavuzu

Dükkanda **bilgisayar var mı yok mu** bilmiyorsanız USB'ye bu klasörün tamamını atın; iki senaryo için de gereken her şey içinde.

```
kuyumcu\
├─ index.html          ← panonun kendisi (tek dosya)
├─ kur.bat             ← SENARYO A: bilgisayara kurulum (çift tıkla)
├─ pano-baslat.bat     ← panoyu açar (kur.bat bunları C:\kuyumcu'ya kopyalar)
├─ pano-kapat.bat      ← panoyu kapatır
├─ ekran-sec.bat       ← pano hangi ekranda çıksın (TV / monitör)
├─ araclar\pano.ps1    ← yardımcı script
└─ KURULUM.md          ← bu dosya
```

---

## SENARYO A — Dükkanda Windows bilgisayar var (TV'ye HDMI ile bağlı)

### Kurulum (2 dakika)
1. TV'yi bilgisayara HDMI ile bağlayın. **Win + P** → **Genişlet** seçin (TV ikinci ekran olsun, "Yinele" değil).
2. USB'deki `kuyumcu` klasörünü açın, **`kur.bat`** dosyasına çift tıklayın.
3. Açılan pencere ekranları listeler → TV'nin numarasını yazıp Enter (genelde 2; Enter'a basınca ana ekran olmayan otomatik seçilir).
4. Pano TV'de tam ekran açılır. Bilgisayarın kendi ekranı serbesttir — istediğiniz programı kullanın, pano TV'de kalır.
5. Panoda fareyi oynatınca çıkan **⚙** simgesine tıklayıp dükkan adı ve komisyonları girin → **Kaydet**.

Kurulum sonrası:
- Bilgisayar her açıldığında pano **kendiliğinden** TV'de açılır.
- Masaüstünde 3 kısayol olur: **Panoyu Aç**, **Panoyu Kapat**, **Pano – Ekran Seç**.
- Uyku ve ekran kapanma otomatik kapatılır.
- Chrome yoksa Edge ile açılır (ikisi de yoksa Chrome kurun).

### Sık karşılaşılan durumlar
| Durum | Çözüm |
|---|---|
| Pano yanlış ekranda açıldı | Masaüstü → **Pano – Ekran Seç** |
| TV sonradan bağlandı, tek ekran görünüyor | Win+P → Genişlet, sonra **Pano – Ekran Seç** |
| Pano kapandı / kayboldu | Masaüstü → **Panoyu Aç** |
| Fiyatlar güncellenmiyor (kırmızı nokta) | İnternet bağlantısını kontrol edin; bağlantı gelince kendiliğinden düzelir |
| Komisyonu başka şubeye taşımak | ⚙ → **Dışa aktar** (dosya iner) → diğer cihazda ⚙ → **İçe aktar** → Kaydet |

Ayarlar tarayıcıda (`C:\Users\...\AppData\Local\KuyumcuPanoProfil`) saklanır; `index.html` güncellenince ayarlar kaybolmaz.

---

## SENARYO B — Bilgisayar yok (Akıllı TV / Android TV box)

Panonun bir web adresinde yayınlanması gerekir. Ücretsiz ve hesapsız yol: **Netlify Drop**.

### 1) Yayınlama (telefondan/laptoptan, bir kez)
1. Boş bir klasör oluşturun, içine **sadece `index.html`** dosyasını koyun.
2. Tarayıcıda **https://app.netlify.com/drop** adresini açın.
3. Klasörü sayfadaki kutuya **sürükleyip bırakın**.
4. Birkaç saniye sonra `https://xxxx-xxxx.netlify.app` gibi bir adres verir. **Bu adresi not edin.**
   - Adresin kalıcı olması için ücretsiz Netlify hesabı açıp siteyi hesaba almanız (Claim) önerilir; aksi halde 24 saat sonra silinebilir.
   - Hesap açınca "Site settings → Change site name" ile `kafkaskuyumcu.netlify.app` gibi okunaklı bir ad verebilirsiniz.
5. `index.html` ileride güncellenirse: Netlify'da site sayfası → **Deploys** → yeni klasörü tekrar sürükle-bırak.

Alternatif: GitHub hesabınız varsa **GitHub Pages** (repo → Settings → Pages) aynı işi görür.

### 2) TV tarafı
**Android TV / Google TV (Philips, TCL, Xiaomi, Mi Box, TV box vb.)**
1. Google Play'den **Fully Kiosk Browser** (ücretsiz) kurun. (Yoksa "TV Bro" tarayıcısı da olur.)
2. Fully Kiosk → Settings → **Start URL**: yayınladığınız adresi girin.
3. Settings → **Autostart on boot**: açık. **Keep screen on**: açık.
4. Uygulamayı açın; pano tam ekran gelir. TV kumandasıyla ⚙'e gidip ayarları girin, Kaydet.
5. TV'nin uyku/otomatik kapanma ayarını kapatın.

**Samsung (Tizen) / LG (webOS)**
- Yerleşik tarayıcıda adresi açın, tam ekran yapın. Otomatik açılış zayıf olduğu için bu TV'lerde arkasına **ucuz bir Android TV box** (Xiaomi TV Box, ~2–3 bin TL) takıp yukarıdaki adımları uygulamak daha güvenilirdir.

Ayarlar TV'nin tarayıcısında saklanır; uygulama verileri silinirse yeniden girmek gerekir (⚙ → Dışa aktar ile yedek alın).

---

## Her iki senaryoda ortak
- **İnternet şart.** Kablolu (Ethernet) bağlantı Wi-Fi'dan daha stabildir.
- Veri kaynağı: Harem Altın canlı akışı; kesilirse otomatik yedek kaynağa (truncgil, ~1 dk gecikmeli) geçer ve sarı uyarı gösterir.
- Klavye kısayolları: **F** tam ekran, **→** vitrin modunda sonraki sayfa, **Esc** ayarları kapat.
- Aynı adresi `?view=vitrin` ekiyle açarsanız ayarı değiştirmeden vitrin görünümü gelir (iki TV'de farklı mod için).
