import { NextResponse } from "next/server";

// TODO: implémenter checkout / webhooks Stripe.
export async function POST() {
  try {
    return NextResponse.json({ status: "placeholder" });
  } catch (error) {
    return NextResponse.json({ error: "Erreur Stripe" }, { status: 500 });
  }
}
