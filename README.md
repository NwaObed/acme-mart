# Acme Mart Analytics Pipeline

## Project Summary

This project implements an analytics pipeline that ingests sales data from Google Drive using Airbyte, stores it in Snowflake, and transforms it with dbt using a medallion architecture. The Gold layer is modeled as a star schema to support analytics and reporting.

## Workflow Overview

1. **Data ingestion**
   - Data source: Google Drive CSV files.
   - Ingestion tool: Airbyte.
   - Destination: Snowflake landing/bronze zone.
   - Source schema in Snowflake: `ANALYTICS_WAREHOUSE.GOOGLE_DRIVE_SALES`.

2. **Bronze layer**
   - Raw ingestion data is loaded into the Bronze layer.
   - `models/bronze/google_sales_data/stg_google_sales_data__csv_sales.sql` reads from the Airbyte source table `csv_sales`.
   - Source metadata is defined in `models/bronze/_sources.yml`.

3. **Silver layer**
   - `models/silver/int_sales_cleaned.sql` cleans and validates the raw records.
   - Data quality rules include removal of null keys and negative values.
   - This layer produces a trusted intermediate dataset for dimensional modeling.

4. **Gold layer**
   - Models a star schema for analytics.
   - Dimensions:
     - `dim_product`
     - `dim_customer`
     - `dim_store`
     - `dim_payment_method`
   - Fact:
     - `fct_sales`

## dbt Project Structure

- `models/bronze/` — staging models for raw Airbyte source data.
- `models/silver/` — cleaned and validated intermediate models.
- `models/gold/` — dimensional models and fact table.
- `models/bronze/_sources.yml` — source definitions for the Snowflake ingest schema.
- `models/silver/silver.yaml` — data quality test definitions for the silver layer.
- `models/gold/gold_models.yaml` — dimension and fact model tests.

## Model Details

### Bronze

- `stg_google_sales_data__csv_sales`
  - Reads raw rows from the Airbyte-loaded source table.
  - Includes raw sales fields and Airbyte metadata.

### Silver

- `int_sales_cleaned`
  - Filters out incomplete or invalid transactions.
  - Enforces positive values for quantity, unit price, and total amount.
  - Prepares clean records for dimensional modeling.

### Gold

- `dim_product`
  - Unique product records with `product_id`, `product_name`, and `category`.

- `dim_customer`
  - Unique customer identifiers.

- `dim_store`
  - Unique store identifiers.

- `dim_payment_method`
  - Unique payment methods with a generated `payment_method_id`.

- `fct_sales`
  - Transaction-level fact table containing sales measures and foreign keys to dimensions.

## Data Quality and Testing

The project includes dbt tests for key columns and relationships:

- Not null checks
- Unique constraints
- Referential integrity via `relationships`
- Expression-based checks using `dbt_utils`

## Running the Project

1. Ensure your dbt profile is configured for Snowflake.
2. Add `dbt_utils` to `packages.yml` if it is not already configured.
3. Install dependencies:

```bash
dbt deps
```

4. Run the dbt models:

```bash
dbt run
```

5. Run tests:

```bash
dbt test
```

## Notes

- The current project is designed for a Snowflake data warehouse with ingestion handled by Airbyte.
- The medallion architecture separates raw, cleaned, and business-ready data.
- The Gold layer is designed as a star schema to support analytics queries and reporting.
