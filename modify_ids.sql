ALTER TABLE mock_data_raw
DROP COLUMN id;

ALTER TABLE mock_data_raw
ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE mock_data_raw
DROP COLUMN sale_customer_id;
ALTER TABLE mock_data_raw
ADD COLUMN sale_customer_id SERIAL;

ALTER TABLE mock_data_raw
DROP COLUMN sale_seller_id;
ALTER TABLE mock_data_raw
ADD COLUMN sale_seller_id SERIAL;

ALTER TABLE mock_data_raw
DROP COLUMN sale_product_id;
ALTER TABLE mock_data_raw
ADD COLUMN sale_product_id SERIAL;
