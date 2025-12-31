-- Disable RLS temporarily to drop existing policies
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Public categories are viewable by everyone." ON categories;
DROP POLICY IF EXISTS "Allow admin to insert categories by email" ON categories;
DROP POLICY IF EXISTS "Allow admin to update categories by email" ON categories;
DROP POLICY IF EXISTS "Allow admin to delete categories by email" ON categories;

-- Re-enable Row Level Security on the 'categories' table
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Policy to allow ALL users (even non-authenticated) to view categories on the main page
CREATE POLICY "Public categories are viewable by everyone."
ON categories FOR SELECT
USING (true);

-- Policy to allow ONLY the admin user to insert new categories
CREATE POLICY "Allow admin to insert categories by email"
ON categories FOR INSERT
WITH CHECK (auth.email() = 'calin_moraru@yahoo.com');

-- Policy to allow ONLY the admin user to update categories
CREATE POLICY "Allow admin to update categories by email"
ON categories FOR UPDATE
USING (auth.email() = 'calin_moraru@yahoo.com');

-- Policy to allow ONLY the admin user to delete categories
CREATE POLICY "Allow admin to delete categories by email"
ON categories FOR DELETE
USING (auth.email() = 'calin_moraru@yahoo.com');