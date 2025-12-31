-- 1. Delete ALL existing policies for the 'categories' table
DROP POLICY IF EXISTS "Public categories are viewable by everyone." ON categories;
DROP POLICY IF EXISTS "Allow admin to insert categories by email" ON categories;
DROP POLICY IF EXISTS "Allow admin to update categories by email" ON categories;
DROP POLICY IF EXISTS "Allow admin to delete categories by email" ON categories;
-- Add any other policy names here if you have more

-- 2. Create the new, clean policies
-- Policy for SELECT (viewing categories)
CREATE POLICY "Allow public to view categories"
ON categories FOR SELECT
USING (true);

-- Policy for INSERT (only admin)
CREATE POLICY "Allow admin to insert categories"
ON categories FOR INSERT
WITH CHECK (auth.email() = 'calin_moraru@yahoo.com');

-- Policy for UPDATE (only admin)
CREATE POLICY "Allow admin to update categories"
ON categories FOR UPDATE
USING (auth.email() = 'calin_moraru@yahoo.com');

-- Policy for DELETE (only admin)
CREATE POLICY "Allow admin to delete categories"
ON categories FOR DELETE
USING (auth.email() = 'calin_moraru@yahoo.com');