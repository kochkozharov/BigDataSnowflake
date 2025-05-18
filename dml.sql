INSERT INTO dim_country (country_name)
SELECT DISTINCT country
FROM (
  SELECT customer_country AS country FROM mock_data_raw
  UNION
  SELECT seller_country       FROM mock_data_raw
  UNION
  SELECT store_country        FROM mock_data_raw
  UNION
  SELECT supplier_country     FROM mock_data_raw
) t
WHERE country IS NOT NULL;


INSERT INTO dim_date (the_date, year, quarter, month, day, weekday)
SELECT DISTINCT
  d AS the_date,
  EXTRACT(YEAR    FROM d) AS year,
  CEIL(EXTRACT(MONTH FROM d) / 3.0)::INT  AS quarter,
  EXTRACT(MONTH   FROM d) AS month,
  EXTRACT(DAY     FROM d) AS day,
  TO_CHAR(d, 'Day')      AS weekday
FROM (
  SELECT CAST(sale_date AS DATE) AS d
  FROM mock_data_raw
  WHERE sale_date IS NOT NULL
) t;


INSERT INTO dim_customer (customer_id, first_name, last_name, age, email, postal_code, country_id)
SELECT
  sale_customer_id,
  customer_first_name,
  customer_last_name,
  customer_age,
  customer_email,
  customer_postal_code,
  c.country_id
FROM (
  SELECT DISTINCT
    sale_customer_id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_postal_code,
    customer_country
  FROM mock_data_raw
  WHERE sale_customer_id IS NOT NULL
) raw
JOIN dim_country c
  ON raw.customer_country = c.country_name;


-- 4. dim_seller
INSERT INTO dim_seller (seller_id, first_name, last_name, email, postal_code, country_id)
SELECT
  sale_seller_id,
  seller_first_name,
  seller_last_name,
  seller_email,
  seller_postal_code,
  c.country_id
FROM (
  SELECT DISTINCT
    sale_seller_id,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_postal_code,
    seller_country
  FROM mock_data_raw
  WHERE sale_seller_id IS NOT NULL
) raw
JOIN dim_country c
  ON raw.seller_country = c.country_name;


INSERT INTO dim_store (name, location, city, state, country_id, phone, email)
SELECT DISTINCT
  store_name,
  store_location,
  store_city,
  store_state,
  c.country_id,
  store_phone,
  store_email
FROM mock_data_raw raw
JOIN dim_country c
  ON raw.store_country = c.country_name
WHERE store_email IS NOT NULL;


INSERT INTO dim_supplier (name, contact_person, email, phone, address, city, country_id)
SELECT DISTINCT
  supplier_name,
  supplier_contact,
  supplier_email,
  supplier_phone,
  supplier_address,
  supplier_city,
  c.country_id
FROM mock_data_raw raw
JOIN dim_country c
  ON raw.supplier_country = c.country_name
WHERE supplier_name IS NOT NULL;


INSERT INTO dim_pet (pet_type, pet_name, pet_breed, pet_category)
SELECT DISTINCT
  customer_pet_type,
  customer_pet_name,
  customer_pet_breed,
  pet_category
FROM mock_data_raw
WHERE customer_pet_type IS NOT NULL;


INSERT INTO dim_product_category (category_name)
SELECT DISTINCT product_category
FROM mock_data_raw
WHERE product_category IS NOT NULL;

INSERT INTO dim_brand (brand_name)
SELECT DISTINCT product_brand
FROM mock_data_raw
WHERE product_brand IS NOT NULL;

INSERT INTO dim_material (material_name)
SELECT DISTINCT product_material
FROM mock_data_raw
WHERE product_material IS NOT NULL;


INSERT INTO dim_product (
    product_id, name, category_id, brand_id, material_id,
    color, size, weight, release_date, expiry_date,
    description, rating, reviews_count
)
SELECT DISTINCT
  sale_product_id,
  product_name,
  pc.product_category_id,
  b.brand_id,
  m.material_id,
  product_color,
  product_size,
  product_weight,
  CAST(product_release_date AS DATE),
  CAST(product_expiry_date AS DATE),
  product_description,
  product_rating,
  product_reviews
FROM mock_data_raw raw
LEFT JOIN dim_product_category pc ON raw.product_category = pc.category_name
LEFT JOIN dim_brand             b  ON raw.product_brand    = b.brand_name
LEFT JOIN dim_material          m  ON raw.product_material = m.material_name
WHERE sale_product_id IS NOT NULL;


INSERT INTO fact_sales (
    date_id,
    customer_id,
    seller_id,
    store_id,
    supplier_id,
    pet_id,
    product_id,
    sale_quantity,
    sale_total_price
)
SELECT
  d.date_id,
  raw.sale_customer_id,
  raw.sale_seller_id,
  s.store_id,
  sp.supplier_id,
  p.pet_id,
  raw.sale_product_id,
  raw.sale_quantity,
  raw.sale_total_price
FROM mock_data_raw raw

  JOIN dim_date     d  ON CAST(raw.sale_date AS DATE) = d.the_date

  JOIN dim_customer c  ON raw.sale_customer_id = c.customer_id
  JOIN dim_seller   sl ON raw.sale_seller_id   = sl.seller_id
  JOIN dim_product  pr ON raw.sale_product_id  = pr.product_id

  JOIN dim_store    s  ON raw.store_email      = s.email

  JOIN dim_supplier sp ON raw.supplier_email   = sp.email

  JOIN dim_pet      p
    ON raw.customer_pet_type  = p.pet_type
   AND raw.customer_pet_name  = p.pet_name
   AND raw.customer_pet_breed = p.pet_breed
   AND raw.pet_category       = p.pet_category

WHERE
  raw.sale_date          IS NOT NULL
  AND raw.sale_customer_id IS NOT NULL
  AND raw.sale_seller_id   IS NOT NULL
  AND raw.sale_product_id  IS NOT NULL
  AND raw.store_email      IS NOT NULL;
