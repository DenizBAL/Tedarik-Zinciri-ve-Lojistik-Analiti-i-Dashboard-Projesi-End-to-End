# 📊 Tedarik Zinciri ve Lojistik Analitiği Dashboard Projesi (End-to-End)

Bu proje; tedarik zinciri verimliliğini, kurumsal/bireysel müşteri kârlılıklarını ve kargo teslimat performanslarını ölçümlemek amacıyla gerçekleştirilmiş uçtan uca (end-to-end) bir veri analitiği çalışmasıdır. Depo süreçlerinden ham veri stratejisine, SQL ile veri kalitesi doğrulamalarından Power BI üzerinde çok sayfalı interaktif raporlamaya kadar tüm aşamaları içerir.

---

## 📂 Proje Mimarisi

Proje, portfolyo standartlarına ve kurumsal düzen gereksinimlerine uygun olarak şu klasör yapısıyla organize edilmiştir:

* **`Assets/`** - Görsel ögeler, lojistik logoları ve sayfa tasarımları için dökümantasyon varlıkları.
* **`SQL_Scripts/`** - Veri temizleme, mantıksal kontrol sorguları ve analitik View (Sanal Tablo) mimarileri.
* **`PowerBI_Report/`** - Yayına hazır interaktif `.pbix` raporlama dosyası.

---

## 🧠 Veri Stratejisi ve Yapay Zeka (AI) Entegrasyonu
Bu projede kullanılan işlem bazlı (transactional) satış verileri ve boyut (dimension) tablolarının temel nitelikleri, **Üretken Yapay Zeka (ChatGPT)** kullanılarak sentetik olarak üretilmiştir. Veri seti mimarisi; sipariş takibi, dağıtım kısıtları, küresel müşteri profilleri ve lojistik SLA taahhütlerini içeren gerçek bir kurumsal tedarik zinciri matrisini simüle etmektedir.

---

## 🛠️ 1. Aşama: Gelişmiş SQL Mühendisliği ve Veri Kalitesi Kontrolü
Veriler görselleştirme katmanına aktarılmadan önce, `Fact_Orders` tablosundaki tüm işlem satırları analitik doğruluğu sağlamak adına sıkı mantıksal testlerden geçirilmiştir:
1. **Zaman Dizisi Kontrolü:** Tarihsel süreçlerin mantık sırasına uygunluğu (`OrderDate` $\le$ `ShipperDate` $\le$ `ActualDeliveryDate`) kontrol edilmiştir.
2. **Boş (Null) ve Kısıt Denetimi:** Boyut tabloları ile ilişkili kritik ID alanlarındaki eksik veya hatalı eşleşmeler izole edilerek temizlenmiştir.

### Ortak Veri Dağıtım Katmanı (`Vw_Dashboard_Base`)
Power BI tarafındaki veri modelini yormamak ve rapor genelinde tek bir "doğruluk kaynağı" (single source of truth) oluşturmak için tüm boyut tablolarını birleştiren kapsamlı bir üretim view'ı (sanal tablo) kurulmuştur. Bu mimari, temel metrikleri doğrudan veri tabanı seviyesinde hesaplar:

* **Finansal Hesaplamalar:** * $\text{Toplam Maliyet} = (\text{Adet} \times \text{Ürün Maliyeti}) + \text{Kargo Maliyeti}$
    * $\text{Net Kâr} = \text{Ciro} - \text{Toplam Maliyet}$
* **SLA ve Performans Metrikleri:** Kargo firmalarının taahhüt ettiği teslim süreleri (`ContractedDeliveryDays`) baz alınarak mantıksal `CASE WHEN` koşullarıyla gecikme gün sayıları (`DaysDelayed`) ve SLA durum etiketleri (`DeliverySLAStatus`) satır bazlı işlenmiştir.

---

## 📊 2. Aşama: Power BI İnteraktif İş Zekası Raporlaması

Oluşturulan dashboard, farklı iş sorularına yanıt vermek adına stratejik olarak 3 modüler sayfaya bölünmüştür:

### 📄 1. Yönetici Özeti (Executive Summary)
C-level yöneticilerin şirketin genel finansal sağlığını saniyeler içinde analiz edebilmesi için tasarlanmıştır.
* **KPI Matrisi:** Toplam Ciro (159.57 Milyon ₺), Net Kâr (19.32 Milyon ₺) ve toplam hacim (10.000 sipariş) gibi ana metrikleri takip eder.
* **Temel İçgörü:** Rapor genelinde göze çarpan en kritik operasyonel problem; yüksek ciro büyümesine rağmen, bazı alt kırılımlardaki yüksek maliyetler sebebiyle Ortalama Kâr Marjının %-12 seviyelerine baskılanmış olmasıdır.
* **Görselleştirmeler:** Aylık Ciro ve Net Kâr trendi (Çizgi Grafik), Müşteri Segmenti ciro dağılımı (Donut Grafik) ve En Kârlı Ürün Kategorileri performansı.

### 📄 2. Lojistik ve Tedarik Zinciri Analizi (Logistics Performance)
Depo operasyon müdürlerinin ve sevkiyat sorumlularının kargo firmalarını (3PL) denetlemesi ve performans ölçümü yapması için yapılandırılmıştır.
* **Operasyonel Süreç:** Ortalama Teslimat Döngüsü (6 Gün) ile Kargonun Yolda Geçen Süresi (4.6 Gün) kıyaslanmıştır.
* **SLA İhlalleri:** Zamanında teslimat oranları incelenerek; belirli kargo firmalarının (Örn: Aras Kargo, FedEx, UPS) ve belirli çıkış depolarının (Örn: Berlin, Ankara, İstanbul) yarattığı operasyonel darboğazlar ve gecikme anomalileri izole edilmiştir.

### 📄 3. Müşteri ve Coğrafya Analizi (Customer Insights)
Pazarlama ve satış ekiplerinin yüksek değerli bölgeleri keşfetmesi ve müşteri bazlı kâr erimelerini teşhis etmesi için özelleştirilmiştir.
* **Coğrafi Dağılım:** Avrupa ve Kuzey Amerika koridorlarındaki işlem yoğunlukları Harita görseli üzerinde konumlandırılmıştır.
* **Kârlılık Keşfi (Kritik Analiz):** Müşteri türlerine göre Net Kâr durumunu incelemek için kurulan Kümelenmiş Sütun Grafik, çok önemli bir ticari gerçeği ortaya çıkarmıştır: **Kurumsal (Corporate)** segment oldukça yüksek kârlılıkla (13.2 Milyon ₺) çalışırken, **Bireysel (Retail)** segment toplamda ciddi bir net zarar içerisindedir. Bu durum, sadece yüksek seviyeli ciro grafiklerine güvenmek yerine, net kâr odaklı derinlemesine analiz yapmanın önemini kanıtlamaktadır.

---

## 💡 Analitik Bulgular (Veri Analisti Değerlendirmesi)
Bu projenin işletmeye sağladığı en büyük katma değer, Bireysel (Retail) pazardaki yapısal zarar durumunun gün yüzüne çıkarılmasıdır. Standart ciro odaklı raporlar bireysel müşteri bağlılığının güçlü olduğunu gösterirken; ürün maliyetleri ve yükselen lojistik/navlun giderlerini sürece dahil eden **Net Kâr** analizi, bu segmentteki kâr erimesini net olarak kanıtlamıştır. Bu çalışma, veri odaklı bir yaklaşımın gizli zararları nasıl tespit edebileceğini ve fiyatlandırma politikaları ile kargo sözleşmelerinin revize edilmesi süreçlerine nasıl rehberlik edebileceğini göstermektedir.

---
*Uçtan uca veri mühendisliği ve görselleştirme uygulamaları kapsamında geliştirilmiştir.*