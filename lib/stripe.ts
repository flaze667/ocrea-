import Stripe from "stripe";

// Client Stripe côté serveur uniquement.
export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY ?? "", {
  apiVersion: "2026-04-22.dahlia",
});
