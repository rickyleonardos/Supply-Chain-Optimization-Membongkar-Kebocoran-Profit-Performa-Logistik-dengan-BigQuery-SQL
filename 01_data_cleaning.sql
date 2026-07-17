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
