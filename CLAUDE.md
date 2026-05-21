# CLAUDE.md — Ocrea project context
# Ce fichier est lu par Claude Code à chaque session.

## Projet
Nom : Ocrea
Fondateur : Kaloyan, 18 ans, ESSCA Budapest — stage CIC Crédit Mutuel (crédits documentaires)
Objectif : SaaS IA pour PME exportatrices/importatrices
Problème : Réduire coûts et erreurs sur crédits documentaires
  — Frais DHL 30–40€ par envoi répété à cause d'erreurs MT700
  — Aucun outil centralisé pour suivi dossiers LC
  — Vérification manuelle des documents = risque élevé

## Stack
Frontend/Backend : Next.js 14 App Router
Base de données : Supabase (PostgreSQL + Auth + Storage + Vault)
Déploiement : Vercel
IA principale : Anthropic Claude API (claude-sonnet-4-20250514)
Paiements : Stripe
Langage : TypeScript partout
Style : Tailwind CSS

## 4 branches produit
1. Gestion dossiers LC — pipeline, statuts, alertes échéances
2. Analyse MT700 IA — upload, détection erreurs, rapport avant envoi
3. Tracking envois — suivi DHL centralisé, notifications
4. Calculateur coûts — simulateur économies vs coût actuel

## Vocabulaire métier
LC = Lettre de Crédit
MT700 = message SWIFT ouverture crédit documentaire
MT710 = notification LC banque notificatrice
UCP 600 = règles ICC crédits documentaires
Remettant = exportateur qui envoie les documents
Banque émettrice = banque de l'importateur
Banque notificatrice = banque de l'exportateur
Jeu de documents = BL + facture + packing list + certificats
Réserves = irrégularités trouvées dans les documents
DHL = transporteur principal envoi docs physiques

## Règles sécurité CRITIQUES
- RLS activé sur TOUTES les tables Supabase sans exception
- Chaque PME voit uniquement ses propres données
- Documents chiffrés via Supabase Vault
- Variables sensibles uniquement dans .env.local
- Région Supabase : eu-central-1 (RGPD)

## Conventions code
- camelCase variables, PascalCase composants
- Routes : app/[feature]/page.tsx
- API : app/api/[endpoint]/route.ts
- Client Supabase : toujours depuis lib/supabase.ts
- try/catch sur tous les appels API et DB
- Langue UI : Français

## Interdictions absolues
- Jamais de clés API dans le code source
- Jamais désactiver RLS pour simplifier une requête
- Jamais de "any" TypeScript sans justification
- Jamais de route API publique pour des données PME
