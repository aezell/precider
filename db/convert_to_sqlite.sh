#!/bin/bash

# Remove existing SQLite database
rm -f precider_dev.db

# Create SQLite database with schema
sqlite3 precider_dev.db << EOF
-- Create tables
CREATE TABLE brands (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    website TEXT,
    logo_url TEXT,
    slug TEXT NOT NULL,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE ingredients (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    slug TEXT NOT NULL,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    brand_id INTEGER,
    slug TEXT NOT NULL,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP,
    is_deleted BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

CREATE TABLE product_ingredients (
    id INTEGER PRIMARY KEY,
    product_id INTEGER,
    ingredient_id INTEGER,
    amount REAL,
    unit TEXT,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

-- Import data
.mode csv
.separator "|"
.import supabase_data.sql brands
.import supabase_data.sql ingredients
.import supabase_data.sql products
.import supabase_data.sql product_ingredients
EOF 