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




