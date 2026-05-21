import { NextResponse } from "next/server";

// TODO: implémenter l'analyse MT700 via Claude API.
export async function POST() {
  try {
    return NextResponse.json({ status: "placeholder" });
  } catch (error) {
    return NextResponse.json({ error: "Erreur analyse MT700" }, { status: 500 });
  }
}
