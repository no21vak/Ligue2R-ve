/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      { protocol: "https", hostname: "**" }, // logos/photos de clubs & joueurs, à restreindre plus tard
    ],
  },
};

export default nextConfig;
