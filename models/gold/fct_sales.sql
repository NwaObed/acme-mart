{{ config(materialized='table') }}

with source as (
    select *
    from {{ ref('int_sales_cleaned') }}
),


sales_count as (
    select
        store_id,
        sum(quantity) as total_quantity,
        sum(total_amount) as total_sales
    from source
    group by store_id
    order by total_sales desc
)


select * from sales_count