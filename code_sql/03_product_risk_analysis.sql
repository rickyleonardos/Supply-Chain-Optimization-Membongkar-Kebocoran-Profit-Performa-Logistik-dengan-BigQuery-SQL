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
  