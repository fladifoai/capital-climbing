-- Migration 015: ascensioni pubbliche di default
-- L'utente vuole che le ascensioni siano visibili a tutti per default,
-- private solo se l'utente le marca esplicitamente come tali.

-- Default schema: 'private' -> 'public'
ALTER TABLE public.ascents
  ALTER COLUMN visibility SET DEFAULT 'public';

-- Rendi pubbliche tutte le ascensioni esistenti salvate come private
-- (vecchie/importate senza passare dal form, che usava già default 'public')
UPDATE public.ascents
  SET visibility = 'public'
  WHERE visibility = 'private';
