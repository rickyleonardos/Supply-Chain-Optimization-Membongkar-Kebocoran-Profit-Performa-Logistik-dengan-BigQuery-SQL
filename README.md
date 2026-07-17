# Supply Chain Optimization: Membongkar Kebocoran Profit & Performa Logistik dengan BigQuery SQL

[![BigQuery](https://img.shields.io/badge/Google%20BigQuery-SQL-blue?logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)

Proyek portofolio ini membedah data operasional retail global (**DataCo Smart Supply Chain**) di Google BigQuery untuk mencari tahu alasan utama di balik menurunnya margin keuntungan perusahaan. Fokus analisis ini mencakup dua aspek krusial: **Cost Control** (efisiensi biaya) dan **Logistics SLA** (ketepatan waktu pengiriman).

Analisis ini dirancang untuk menunjukkan kemampuan berpikir kritis (*critical thinking*), pembersihan data (*data cleaning*), serta penyusunan laporan analitis berbasis bisnis (*insight-driven reporting*) yang siap dipamerkan di industri data profesional.

---

## Studi Kasus Bisnis (Business Case)

1. Latar Belakang & Masalah (Problem Statement)
   
> Perusahaan mengalami penurunan margin laba bersih akibat tingginya biaya tidak terduga (losses) dalam pengiriman barang. Manajemen mencurigai adanya inefisiensi pada penentuan kontrak ekspedisi pihak ketiga (3PL) serta tingkat kepuasan pelanggan yang menurun akibat keterlambatan pengiriman (SLA Breach).

2. Tujuan Analisis (Objective)
   
   * Melakukan validasi dan pembersihan data transaksi yang eror sebelum dianalisis.
   * Mengevaluasi kinerja setiap metode pengiriman (Shipping Mode) terhadap ketepatan waktu.
   * Mengukur dampak finansial (financial leakage) dari masalah logistik dan pembatalan pesanan.
   * Mengidentifikasi kategori produk (Category Name) yang paling berisiko tinggi menyumbang kerugian perusahaan.
  
---

## Langkah Analisis & Kode SQL (Google BigQuery)

Langkah 1: Pembersihan & Validasi Data

> Sebelum melakukan analisis mendalam, data divalidasi terlebih dahulu untuk memastikan tidak ada anomali (seperti total penjualan bernilai nol atau negatif) serta merapikan format teks.

```
-- Pembersihan , Standarisasi, dan Validasi data mentah
with cleaned_data as (
  select 
    trim(Market) as market,
    trim(`Order Region`) as order_region,
    trim(`Category Name`) as category_name,
    trim(`Shipping Mode`) as shipping_mode,
    coalesce(total_orders, 0) as total_orders,
    coalesce(avg_days_variance, 0.0) as avg_days_variance,
    coalesce(late_delivery_rate_pct, 0.0) as late_delivery_rate,
    coalesce(cancellation_rate_pct, 0.0) as cancellation_rate,
    coalesce(total_sales, 0.0) as total_sales,
    coalesce(total_profit, 0.0) as total_profit,
-- Mengubah nilai loss menjadi absolut positif untuk memudahkan analisis biaya 
    abs(coalesce(total_losses, 0.0)) as total_losses
  from
    `portfolio-supply-chain.supply_chain_analysis.raw_supply_chain`
  where 
    total_sales > 0 -- Validasi: menghapus data transaksi kosong/anomali
)
  select * from cleaned_data;
```

Langkah 2: Analisis Kinerja Pengiriman vs Kebocoran Profit

> Query ini digunakan untuk membandingkan performa antar jenis pengiriman dan melihat korelasi antara keterlambatan dengan hilangnya profit perusahaan.

```
-- Evaluasi Performa Pengiriman dan Kebocoran Finansial  (Finansial Leakage)
with shipping_perfomance as (
  select
    `Shipping Mode` as shipping_mode,
    sum(total_orders) as total_orders,
    round(avg(late_delivery_rate_pct),2) as avg_late_delivery_rate_pct,
    round(avg(avg_days_variance), 2) as avg_delay_days,
    round(avg(total_sales), 2) as gross_sales,
    round(avg(total_profit), 2) as net_profit,
    round(sum(abs(total_losses)), 2) as total_financial_losses,
    -- Rasio kebocoran keuangan dibandingkan total penjualan
    round((sum(abs(total_losses)) / sum(total_sales)) * 100, 2) as loss_to_sales_ratio_pct
  from
    `portfolio-supply-chain.supply_chain_analysis.raw_supply_chain`
  group by
    1
)
select
  shipping_mode,
  total_orders,
  avg_late_delivery_rate_pct,
  avg_delay_days,
  gross_sales,
  total_financial_losses,
  loss_to_sales_ratio_pct
from
  shipping_perfomance
order by
  avg_late_delivery_rate_pct desc;
```

Langkah 3: Analisis Risiko Kategori Produk

> Mengidentifikasi 5 kategori produk teratas yang menyumbang kerugian (financial loss) terbesar akibat operasional logistik yang buruk.

```
-- Top 5 kategori Produk Beresiko Tinggi dengan Kebocoran Profit Terbesar
select
  `Category Name` as category_name,
  sum(total_orders) as total_orders,
  round(sum(total_sales), 2) as total_sales,
  round(sum(total_profit), 2) as total_profit,
  round(sum(abs(total_losses)), 2) as financial_losses,
  round((sum(abs(total_losses)) / sum(total_sales)) * 100, 2) as loss_to_sales_pct
from
  `portfolio-supply-chain.supply_chain_analysis.raw_supply_chain`
group by
  1
order by
  financial_losses desc
limit
  5;
```

---

## Temuan Utama (Key Insights)

Berdasarkan hasil eksekusi query di Google BigQuery, diperoleh temuan penting berikut:  

1. Paradoks Kurir Premium (SLA Jebol):
   * Opsi pengiriman First Class yang berbiaya mahal justru mencatat rekor keterlambatan terburuk mencapai 95,80% dengan rata-rata delay 1 hari.
   * Sebaliknya, layanan murah Standard Class operasionalnya jauh lebih terkendali dengan tingkat keterlambatan 38,50% dan deviasi waktu mendekati nol (0,01 hari).
2. Kebocoran Profit Konstan:
   * Di semua jenis kurir, perusahaan konsisten kehilangan sekitar 10% hingga 10,8% dari total omzet akibat masalah operasional pengiriman. Layanan Second Class menjadi penyumbang persentase kerugian tertinggi (10,85%).
3. Kategori Produk Rentan (High-Risk):
   * Kategori produk Fishing memimpin kebocoran biaya terbesar senilai $728.570,95, disusul oleh Cleats ($452.594,21), dan Camping & Hiking ($443.082,23).

---

## Rekomendasi Strategis (Strategic Recommendation)

Sebagai Data Analyst, rekomendasi bisnis yang saya ajukan kepada manajemen adalah:  
1. Audit dan Evaluasi Vendor Logistik (3PL): Segera tinjau kembali kontrak kerja sama dengan pihak ketiga penyedia kurir First Class dan Second Class. Angka keterlambatan di atas 75% sudah melanggar komitmen janji layanan (SLA Breach), sehingga perlu diterapkan klausul pinalti finansial.
2. Rombak Opsi Pengiriman Premium: Tangguhkan sementara garansi waktu instan pada opsi First Class. Lebih baik alihkan volume pengiriman ke Standard Class yang terbukti jauh lebih stabil guna menekan klaim pengembalian dana dari pelanggan.
3. Jalur Khusus (Priority Lane) Produk Hobi: Berikan perhatian ekstra pada proses fulfillment dan packing untuk kategori produk Fishing dan Cleats di area gudang agar memperkecil peluang pembatalan pesanan akibat penanganan yang terlalu lama.

---

## Skills Demonstrated

* **Data Cleaning & Validation:** Melakukan standardisasi teks menggunakan `TRIM`, menangani nilai kosong dengan `COALESCE`, serta mengonversi nilai kerugian menjadi absolut (`ABS`) untuk memastikan laporan keuangan 100% valid sebelum dianalisis.
* **Advanced SQL Framework:** Mahir menulis query yang bersih dan efisien dengan memanfaatkan *Common Table Expressions* (CTEs), fungsi agregasi (`SUM`, `AVG`), pembulatan desimal (`ROUND`), serta pengelompokan data yang kompleks (`GROUP BY`).
* **Business Acumen & Cost Control:** Mampu menerjemahkan data mentah operasional logistik menjadi metrik finansial strategis yang dipahami oleh manajemen, salah satunya metrik *Loss to Sales Ratio* untuk mendeteksi kebocoran profit.
* **Logistics SLA Analytics:** Mampu melakukan audit performa ketepatan waktu pengiriman kurir dan mendeteksi anomali/paradoks antara janji layanan logistik premium dengan fakta di lapangan.

---

## Tools Used

* **Google BigQuery (SQL Engine):** Berperan sebagai *Cloud Data Warehouse* utama untuk menyimpan, membersihkan, mengagregasi, dan memproses dataset operasional berskala besar dengan performa tinggi.





