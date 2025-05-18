CREATE TABLE dim_country (
    country_id     SERIAL    PRIMARY KEY,
    country_name   VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE dim_date (
    date_id        SERIAL    PRIMARY KEY,
    the_date       DATE      NOT NULL UNIQUE,
    year           INT       NOT NULL,
    quarter        INT       NOT NULL,
    month          INT       NOT NULL,
    day            INT       NOT NULL,
    weekday        VARCHAR(10) NOT NULL
);

CREATE TABLE dim_customer (
    customer_id           INT       PRIMARY KEY,
    first_name            VARCHAR(50),
    last_name             VARCHAR(50),
    age                   INT,
    email                 VARCHAR(50),
    postal_code           VARCHAR(50),
    country_id            INT       REFERENCES dim_country(country_id)
);

CREATE TABLE dim_seller (
    seller_id             INT       PRIMARY KEY,
    first_name            VARCHAR(50),
    last_name             VARCHAR(50),
    email                 VARCHAR(50),
    postal_code           VARCHAR(50),
    country_id            INT       REFERENCES dim_country(country_id)
);

CREATE TABLE dim_store (
    store_id              SERIAL    PRIMARY KEY,
    name                  VARCHAR(50),
    location              VARCHAR(50),
    city                  VARCHAR(50),
    state                 VARCHAR(50),
    country_id            INT       REFERENCES dim_country(country_id),
    phone                 VARCHAR(50),
    email                 VARCHAR(50)
);

CREATE TABLE dim_supplier (
    supplier_id           SERIAL    PRIMARY KEY,
    name                  VARCHAR(50),
    contact_person        VARCHAR(50),
    email                 VARCHAR(50),
    phone                 VARCHAR(50),
    address               VARCHAR(50),
    city                  VARCHAR(50),
    country_id            INT       REFERENCES dim_country(country_id)
);

CREATE TABLE dim_pet (
    pet_id                SERIAL    PRIMARY KEY,
    pet_type              VARCHAR(50),
    pet_name              VARCHAR(50),
    pet_breed             VARCHAR(50),
    pet_category          VARCHAR(50)
);

CREATE TABLE dim_product_category (
    product_category_id   SERIAL    PRIMARY KEY,
    category_name         VARCHAR(50) UNIQUE
);

CREATE TABLE dim_brand (
    brand_id              SERIAL    PRIMARY KEY,
    brand_name            VARCHAR(50) UNIQUE
);

CREATE TABLE dim_material (
    material_id           SERIAL    PRIMARY KEY,
    material_name         VARCHAR(50) UNIQUE
);

CREATE TABLE dim_product (
    product_id            INT       PRIMARY KEY,
    name                  VARCHAR(50),
    category_id           INT       REFERENCES dim_product_category(product_category_id),
    brand_id              INT       REFERENCES dim_brand(brand_id),
    material_id           INT       REFERENCES dim_material(material_id),
    color                 VARCHAR(50),
    size                  VARCHAR(50),
    weight                FLOAT,
    release_date          DATE,
    expiry_date           DATE,
    description           VARCHAR(1024),
    rating                FLOAT,
    reviews_count         INT
);

CREATE TABLE fact_sales (
    sale_id               SERIAL    PRIMARY KEY,
    date_id               INT       NOT NULL REFERENCES dim_date(date_id),
    customer_id           INT       NOT NULL REFERENCES dim_customer(customer_id),
    seller_id             INT       NOT NULL REFERENCES dim_seller(seller_id),
    store_id              INT       NOT NULL REFERENCES dim_store(store_id),
    supplier_id           INT       NOT NULL REFERENCES dim_supplier(supplier_id),
    pet_id                INT       NOT NULL REFERENCES dim_pet(pet_id),
    product_id            INT       NOT NULL REFERENCES dim_product(product_id),
    sale_quantity         INT       NOT NULL,
    sale_total_price      FLOAT     NOT NULL
);
