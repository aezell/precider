import os
import sqlite3
import psycopg2
from psycopg2.extras import RealDictCursor

# Remove existing SQLite DB to ensure a fresh schema
if os.path.exists('precider_dev.db'):
    os.remove('precider_dev.db')

# PostgreSQL connection
pg_conn = psycopg2.connect(
    "postgresql://postgres.pjgpnswinaaqymypfopx:tfx*qme1WFV.thk4tng@aws-0-us-east-2.pooler.supabase.com:5432/postgres"
)
pg_cur = pg_conn.cursor(cursor_factory=RealDictCursor)

# SQLite connection
sqlite_conn = sqlite3.connect('precider_dev.db')
sqlite_cur = sqlite_conn.cursor()

# Create tables
sqlite_cur.executescript('''
CREATE TABLE IF NOT EXISTS brands (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    logo_url TEXT,
    website TEXT,
    description TEXT,
    slug TEXT NOT NULL,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP,
    completed BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS ingredients (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    benefits TEXT,
    slug TEXT NOT NULL,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    url TEXT,
    image_url TEXT,
    price REAL,
    serving_size TEXT,
    servings_per_container INTEGER,
    weight_in_grams INTEGER,
    is_active BOOLEAN DEFAULT TRUE,
    slug TEXT NOT NULL,
    search_vector TEXT,
    brand_id INTEGER,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

CREATE TABLE IF NOT EXISTS product_ingredients (
    id INTEGER PRIMARY KEY,
    product_id INTEGER,
    ingredient_id INTEGER,
    dosage_amount REAL,
    dosage_unit TEXT,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);
''')

# Copy data from PostgreSQL to SQLite
def copy_table(table_name):
    print(f"Copying {table_name}...")
    pg_cur.execute(f"SELECT * FROM {table_name}")
    rows = pg_cur.fetchall()
    
    if not rows:
        print(f"No data found in {table_name}")
        return
    
    # Get column names
    columns = rows[0].keys()
    
    # Create placeholders for SQL
    placeholders = ','.join(['?' for _ in columns])
    columns_str = ','.join(columns)
    
    # Prepare insert statement
    insert_sql = f"INSERT INTO {table_name} ({columns_str}) VALUES ({placeholders})"
    
    # Insert data
    for row in rows:
        values = []
        for col in columns:
            val = row[col]
            if isinstance(val, (bytes, bytearray)):
                val = val.decode('utf-8')
            elif not isinstance(val, (str, int, float, type(None))):
                val = str(val)
            values.append(val)
        sqlite_cur.execute(insert_sql, values)
    
    print(f"Copied {len(rows)} rows from {table_name}")

# Copy each table
tables = ['brands', 'ingredients', 'products', 'product_ingredients']
for table in tables:
    copy_table(table)

# Commit changes and close connections
sqlite_conn.commit()
sqlite_conn.close()
pg_conn.close()

print("Conversion complete!") 