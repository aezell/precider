CREATE TABLE brands (
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
CREATE TABLE ingredients (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    benefits TEXT,
    slug TEXT NOT NULL,
    inserted_at TIMESTAMP,
    updated_at TIMESTAMP
);
CREATE TABLE products (
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
CREATE TABLE product_ingredients (
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
CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" INTEGER PRIMARY KEY, "inserted_at" TEXT);
CREATE TABLE IF NOT EXISTS "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "email" TEXT NOT NULL, "hashed_password" TEXT, "confirmed_at" TEXT, "inserted_at" TEXT NOT NULL, "updated_at" TEXT NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE UNIQUE INDEX "users_email_index" ON "users" ("email");
CREATE TABLE IF NOT EXISTS "users_tokens" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "user_id" INTEGER NOT NULL CONSTRAINT "users_tokens_user_id_fkey" REFERENCES "users"("id") ON DELETE CASCADE, "token" BLOB NOT NULL, "context" TEXT NOT NULL, "sent_to" TEXT, "authenticated_at" TEXT, "inserted_at" TEXT NOT NULL);
CREATE INDEX "users_tokens_user_id_index" ON "users_tokens" ("user_id");
CREATE UNIQUE INDEX "users_tokens_context_token_index" ON "users_tokens" ("context", "token");
INSERT INTO schema_migrations VALUES(20250430005447,'2025-05-26T20:45:24');
