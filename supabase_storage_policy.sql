-- 1. Asigură-te că există bucket-ul (opțional, doar dacă nu există)
INSERT INTO storage.buckets (id, name, public)
VALUES ('category-covers', 'category-covers', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Adaugă politica de securitate pentru încărcare (INSERT)
-- Permite doar utilizatorilor logați să încarce fișiere
CREATE POLICY "Allow admin to upload images"
ON storage.objects FOR INSERT
WITH CHECK (
  auth.role() = 'authenticated' AND
  auth.email() = 'calin_moraru@yahoo.com' AND
  bucket_id = 'category-covers'
);

-- 3. (Opțional, dar recomandat) Adaugă politici pentru ștergere și actualizare
CREATE POLICY "Allow admin to update images"
ON storage.objects FOR UPDATE
USING (
  auth.role() = 'authenticated' AND
  auth.email() = 'calin_moraru@yahoo.com' AND
  bucket_id = 'category-covers'
);

CREATE POLICY "Allow admin to delete images"
ON storage.objects FOR DELETE
USING (
  auth.role() = 'authenticated' AND
  auth.email() = 'calin_moraru@yahoo.com' AND
  bucket_id = 'category-covers'
);

-- 4. (Opțional) Permite publicului să vadă imaginile
CREATE POLICY "Allow public to view images"
ON storage.objects FOR SELECT
USING (bucket_id = 'category-covers');