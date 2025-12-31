-- Disable RLS temporarily to drop existing policies
ALTER TABLE categories DISABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Allow authenticated users to view categories" ON categories;
DROP POLICY IF EXISTS "Allow authenticated users to insert categories" ON categories;
DROP POLICY IF EXISTS "Allow authenticated users to update categories" ON categories;
DROP POLICY IF EXISTS "Allow authenticated users to delete categories" ON categories;

-- Re-enable Row Level Security on the 'categories' table
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

-- Policy to allow ALL users (even non-authenticated) to view categories on the main page
-- If you want only logged-in users to see categories, change 'true' to 'auth.role() = 'authenticated''
CREATE POLICY "Public categories are viewable by everyone."
ON categories FOR SELECT
USING (true);

-- Policy to allow ONLY the admin user to insert new categories
CREATE POLICY "Allow admin to insert categories"
ON categories FOR INSERT
WITH CHECK (auth.uid() = (SELECT id FROM auth.users WHERE email = 'calin_moraru@yahoo.com'));

-- Policy to allow ONLY the admin user to update categories
CREATE POLICY "Allow admin to update categories"
ON categories FOR UPDATE
USING (auth.uid() = (SELECT id FROM auth.users WHERE email = 'calin_moraru@yahoo.com'));

-- Policy to allow ONLY the admin user to delete categories
CREATE POLICY "Allow admin to delete categories"
ON categories FOR DELETE
USING (auth.uid() = (SELECT id FROM auth.users WHERE email = 'calin_moraru@yahoo.com'));