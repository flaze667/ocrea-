# Règles d'analyse MT700

Document de référence pour la vérification automatisée des messages SWIFT MT700
(ouverture de crédit documentaire) selon les UCP 600.

## Champs MT700 vérifiés
- :27: Sequence of Total
- :40A: Form of Documentary Credit
- :20: Documentary Credit Number
- :31C: Date of Issue
- :40E: Applicable Rules
- :31D: Date and Place of Expiry
- :50: Applicant
- :59: Beneficiary
- :32B: Currency Code, Amount
- :41a: Available With ... By ...
- :42C: Drafts at ...
- :43P: Partial Shipments
- :43T: Transhipment
- :44A/E/F/B: Lieu de prise en charge / port chargement / déchargement / destination
- :44C/D: Latest Date of Shipment / Shipment Period
- :45A: Description of Goods and/or Services
- :46A: Documents Required
- :47A: Additional Conditions
- :71B: Charges
- :48: Period for Presentation
- :49: Confirmation Instructions

## Erreurs courantes
- Incohérence entre lieu d'expédition (:44E:) et Incoterm (:45A:)
- Date de validité antérieure à la date d'expédition
- Devise non ISO 4217
- Bénéficiaire / donneur d'ordre incomplet (adresse manquante)
- Documents requis incompatibles (ex : BL maritime sur expédition aérienne)
- Réserves UCP 600 non respectées (art. 14 — examen des documents)

## Sources
- ICC UCP 600
- ISBP 821
- SWIFT MT Standards Release Guide
