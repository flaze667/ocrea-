import Anthropic from "@anthropic-ai/sdk";

// Client Anthropic Claude — usage côté serveur uniquement.
export const claude = new Anthropic({
  apiKey: process.env.ANTHROPIC_API_KEY ?? "",
});

export const CLAUDE_MODEL = "claude-sonnet-4-20250514";
