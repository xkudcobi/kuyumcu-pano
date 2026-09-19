# Kuyumcu Canlı Fiyat Panosu — Kurulum Kılavuzu

Dükkanda **bilgisayar var mı yok mu** bilmiyorsanız USB'ye bu klasörün tamamını atın; iki senaryo için de gereken her şey içinde.

```
kuyumcu\
├─ index.html          ← panonun kendisi (tek dosya)
├─ kur.bat             ← SENARYO A: bilgisayara kurulum (çift tıkla)
├─ pano-baslat.bat     ← panoyu açar (kur.bat bunları C:\kuyumcu'ya kopyalar)
├─ pano-kapat.bat      ← panoyu kapatır
├─ ekran-sec.bat       ← pano hangi ekranda çıksın (TV / monitör)
├─ hesap-ac.bat        ← Tezgah Hesaplayıcı'yı tezgah bilgisayarının ekranında açar
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
6. Aynı panelde **Ürün Listesi · Komisyon & İşçilik** bölümünden takılarınızı (bilezik, alyans, 14 ayar…) ayar + işçilik ile tanımlayın; işaretlediğiniz ürünler panoda gram/adet fiyatıyla görünür.
7. Tezgahta fiyat vermek için masaüstündeki **Tezgah Hesaplayıcı** kısayolunu açın (pano TV'de kalır, hesaplayıcı bilgisayar ekranında açılır; ayarlar ortaktır).

Kurulum sonrası:
- Bilgisayar her açıldığında pano **kendiliğinden** TV'de açılır.
- Masaüstünde 4 kısayol olur: **Panoyu Aç**, **Panoyu Kapat**, **Pano – Ekran Seç**, **Tezgah Hesaplayıcı**.
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

## İşçilik ve Tezgah Hesaplayıcı

### İşçilik nasıl hesaplanır?
Kuyumculukta takı fiyatı **has altın** (24 ayar) gram fiyatından türetilir. Saflık **milyem** (binde) ile ölçülür:
22 ayar = 916‰, 18 ayar = 750‰, 14 ayar = 585‰, 8 ayar = 333‰.

| Adım | Formül |
|---|---|
| Malzeme | Gram × Has Satış × Saflık‰ / 1000 |
| İşçilik (3 yöntemden biri) | **Milyem üzerine:** Gram × Has × İşçilik‰ / 1000 (916 + 20 = "936'dan satış") · **Gram başına TL** · **Malzemenin yüzdesi** |
| Parça işçiliği / taş | Adet başına sabit TL (taşlı yüzük, külçe vb.) |
| KDV (isteğe bağlı) | Sadece işçilik + taş üzerine (has ve sarrafiye KDV'den muaftır) |
| Alış (hurda) | Gram × Has Alış × Hurda Milyemi / 1000 (22 ayar için 900–905‰ yaygındır) |

Her ürün için bu değerleri ⚙ → **Ürün Listesi** bölümünde ürün kartına girersiniz. Hazır şablonlar (22 ayar bilezik, alyans, 14/18 ayar takı, taşlı yüzük, gram külçe…) örnek değerlerle gelir — **kendi işçiliğinize göre düzeltin.** Standart gramaj 0 ise panoda **gram fiyatı**, gramaj girilirse **adet fiyatı** gösterilir.

İşçilik hesabının baz aldığı has fiyatı ⚙ → **İşçilik Hesap Ayarları**'ndan seçilir: ham piyasa has'ı ya da panodaki komisyonlu has. İnternet yokken **Has fiyatını elle gir** açılarak çalışılabilir.

### Tezgah Hesaplayıcı (🧮 simge veya **H** tuşu)
Sekmeler:
- **Satış Hesabı** — ürün seç, gram gir (hızlı gram düğmeleri var), adet/indirim; malzeme, işçilik, taş, KDV dökümüyle toplam, gram fiyatı, satış milyemi ve hurda geri-alım karşılığı. "Serbest hesap" ile ayar/işçiliği anlık girebilirsiniz. Enter → satışa ekle.
- **Alış · Hurda & Sarrafiye** — ayar seç, gram gir → hurda ödemesi; ya da çeyrek/yarım/tam alışı adetle.
- **İşlem Özeti & Takas** — satış kalemleri eksi müşterinin verdiği altın = **müşteri öder / müşteriye ödenir**. **Teklif / Fiş yazdır** ile dükkan adı, saat, has fiyatı ve kalemleri içeren teklif çıktısı alınır (fatura yerine geçmez).
- **Milyem Cetveli & Ters Hesap** — anlık has ile her milyemin ₺/gr karşılığı; bir takının fiyatı + gramından **kaç milyem / kaç TL işçilik** olduğunu çözer (rakip fiyatı analizi için).

Tezgah bilgisayarında ayrı pencere: **hesap-ac.bat** (kurulumda masaüstü kısayolu oluşur). Aynı tarayıcı profilini kullandığı için pano ve hesaplayıcı **aynı ayarları** paylaşır; birinde Kaydet'e basılınca diğeri anında güncellenir. Elle açmak için adres: `index.html?view=hesap`.

> Not: Bu sürümde pano `--kiosk` yerine `--start-fullscreen` ile açılır (görünüm aynı: adres çubuğu yok, tam ekran). Sebep: kiosk modu tüm tarayıcıyı kilitlediği için tezgah penceresi ayrı açılamıyordu.

---

## Her iki senaryoda ortak
- **İnternet şart.** Kablolu (Ethernet) bağlantı Wi-Fi'dan daha stabildir.
- Veri kaynağı: Harem Altın canlı akışı; kesilirse otomatik yedek kaynağa (truncgil, ~1 dk gecikmeli) geçer ve sarı uyarı gösterir.
- Klavye kısayolları: **F** tam ekran, **H** tezgah hesaplayıcı, **→** vitrin modunda sonraki sayfa, **Esc** ayarları/hesaplayıcıyı kapat.
- Aynı adresi `?view=vitrin` ekiyle açarsanız ayarı değiştirmeden vitrin görünümü gelir (iki TV'de farklı mod için).
