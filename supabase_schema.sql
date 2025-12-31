-- 1. Tabela pentru Categorii (dacă nu există deja)
CREATE TABLE IF NOT EXISTS public.categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    image_url TEXT,
    order_index INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 2. Tabela pentru Beats (dacă nu există deja)
CREATE TABLE IF NOT EXISTS public.beats (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    producer TEXT DEFAULT 'CM Beats',
    category TEXT REFERENCES public.categories(name),
    price NUMERIC(10,2) NOT NULL,
    cover TEXT,
    audiourl TEXT NOT NULL,
    "order" INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- 3. Tabela pentru Achiziții (ACEASTA LIPSEȘTE)
CREATE TABLE IF NOT EXISTS public.purchases (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id),
    beat_id TEXT NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    status TEXT NOT NULL, -- 'pending', 'completed', 'failed'
    paypal_payment_id TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
    completed_at TIMESTAMP WITH TIME ZONE,
    webhook_verified BOOLEAN DEFAULT false
);

-- 4. Tabela pentru Descărcări
CREATE TABLE IF NOT EXISTS public.downloads (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    purchase_id UUID REFERENCES public.purchases(id) ON DELETE CASCADE,
    user_id UUID REFERENCES auth.users(id),
    beat_id TEXT NOT NULL,
    download_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Activează Row Level Security (RLS)
ALTER TABLE public.purchases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.downloads ENABLE ROW LEVEL SECURITY;

-- Politici de securitate (utilizatorii își pot vedea doar propriile achiziții)
CREATE POLICY "Users can view their own purchases" ON public.purchases
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own purchases" ON public.purchases
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can view their own downloads" ON public.downloads
    FOR SELECT USING (auth.uid() = user_id);