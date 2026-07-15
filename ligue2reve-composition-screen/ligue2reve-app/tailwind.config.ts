import type { Config } from "tailwindcss";

const config: Config = {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}", "./lib/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        pitch: {
          dark: "#0F2E1F",
          DEFAULT: "#1F5C3D",
          light: "#2F7A52",
        },
        chalk: "#F4F7F2",
        ink: "#0D1B14",
        gold: "#E8B84B",
        clay: "#C1543A",
      },
      fontFamily: {
        display: ["var(--font-display)", "sans-serif"],
        body: ["var(--font-body)", "sans-serif"],
      },
    },
  },
  plugins: [],
};

export default config;
