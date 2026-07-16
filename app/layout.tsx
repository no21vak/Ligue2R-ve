import type { Metadata } from "next";
import { Oswald, Inter } from "next/font/google";
import "./globals.css";

const displayFont = Oswald({
  subsets: ["latin"],
  weight: ["500", "600", "700"],
  variable: "--font-display",
});

const bodyFont = Inter({
  subsets: ["latin"],
  variable: "--font-body",
});

export const metadata: Metadata = {
  title: "Ligue2Rêve",
  description: "Ta feuille de match, entre potes.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="fr" className={`${displayFont.variable} ${bodyFont.variable}`}>
      <body className="font-body">{children}</body>
    </html>
  );
}
