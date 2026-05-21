import { NextResponse } from "next/server";

// TODO: implémenter le tracking DHL.
export async function GET() {
  try {
    return NextResponse.json({ status: "placeholder" });
  } catch (error) {
    return NextResponse.json({ error: "Erreur tracking" }, { status: 500 });
  }
}
