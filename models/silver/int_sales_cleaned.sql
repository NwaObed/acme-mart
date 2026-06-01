{{ config(materialized='table') }}

select
    customer_id,
    product_id,
    store_id,
    transaction_id,
    quantity,
    unit_price,
    total_amount
from {{ ref('stg_google_sales_data__csv_sales') }}
where transaction_id is not null