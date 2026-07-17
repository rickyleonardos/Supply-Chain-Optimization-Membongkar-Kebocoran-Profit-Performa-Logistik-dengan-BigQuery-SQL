# Supply Chain Optimization: Membongkar Kebocoran Profit & Performa Logistik dengan BigQuery SQL

[![BigQuery](https://img.shields.io/badge/Google%20BigQuery-SQL-blue?logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)

Proyek portofolio ini membedah data operasional retail global (**DataCo Smart Supply Chain**) di Google BigQuery untuk mencari tahu alasan utama di balik menurunnya margin keuntungan perusahaan. Fokus analisis ini mencakup dua aspek krusial: **Cost Control** (efisiensi biaya) dan **Logistics SLA** (ketepatan waktu pengiriman).

Analisis ini dirancang untuk menunjukkan kemampuan berpikir kritis (*critical thinking*), pembersihan data (*data cleaning*), serta penyusunan laporan analitis berbasis bisnis (*insight-driven reporting*) yang siap dipamerkan di industri data profesional.

---

## 📁 Struktur Folder Repositori (GitHub Folder Structure)

Untuk menjaga kerapian repositori ini, file disusun dengan struktur terorganisir berikut:

```text
dataco-supply-chain-analysis/
├── README.md                           <-- Dokumen utama portofolio (file ini)
├── LICENSE                             <-- Lisensi open-source (MIT)
├── sql/                                <-- Direktori untuk query SQL BigQuery
│   ├── 01_data_cleaning.sql            <-- Validasi & pembersihan data mentah
│   ├── 02_shipping_performance.sql     <-- Analisis keterlambatan & kebocoran profit
│   └── 03_product_risk_analysis.sql    <-- Identifikasi kategori produk berisiko tinggi
└── dashboards/                         <-- Folder untuk aset visualisasi
    └── dashboard_preview.png           <-- Tangkapan layar dashboard untuk LinkedIn
