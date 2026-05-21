# Schéma base de données — Ocrea

Toutes les tables sont en RLS activé. Chaque PME accède uniquement à ses données
via la colonne `company_id`.

## Tables principales (draft)

### companies
- id (uuid, pk)
- name (text)
- country (text)
- created_at (timestamptz)

### users
- id (uuid, pk, lien auth.users)
- company_id (uuid, fk → companies.id)
- role (text)
- created_at (timestamptz)

### lc_dossiers
- id (uuid, pk)
- company_id (uuid, fk)
- reference (text)
- status (text — draft / issued / shipped / paid / closed)
- amount (numeric)
- currency (text, ISO 4217)
- issuing_bank (text)
- advising_bank (text)
- expiry_date (date)
- latest_shipment_date (date)
- created_at (timestamptz)
- updated_at (timestamptz)

### mt700_analyses
- id (uuid, pk)
- dossier_id (uuid, fk → lc_dossiers.id)
- raw_message (text — chiffré via Vault)
- analysis (jsonb)
- errors_count (int)
- created_at (timestamptz)

### shipments
- id (uuid, pk)
- dossier_id (uuid, fk)
- carrier (text — DHL par défaut)
- tracking_number (text)
- status (text)
- last_event_at (timestamptz)

### documents
- id (uuid, pk)
- dossier_id (uuid, fk)
- type (text — BL / invoice / packing_list / certificate / other)
- storage_path (text — Supabase Storage)
- uploaded_at (timestamptz)

## Policies RLS (modèle)
- SELECT/INSERT/UPDATE/DELETE autorisés uniquement si
  `company_id = (select company_id from users where id = auth.uid())`.
