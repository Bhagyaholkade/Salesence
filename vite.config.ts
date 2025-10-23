import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";

// https://vitejs.dev/config/
export default defineConfig(({ command, mode }) => {
  const isProduction = mode === 'production';

  return {
    base: '/',
    server: {
      host: "::",
      port: 5173,
      allowedHosts: [
        "salesence-h463.onrender.com",
        ".onrender.com",
      ],
    },
    plugins: [
      react(),
    ],
    resolve: {
      alias: {
        "@": path.resolve(__dirname, "./src"),
      },
    },
    build: {
      outDir: 'dist',
      assetsDir: 'assets',
      minify: 'esbuild',
      sourcemap: false,
      target: 'es2015',
      emptyOutDir: true,
      rollupOptions: {
        external: isProduction ? [] : undefined,
      },
    },
    define: {
      'process.env.NODE_ENV': JSON.stringify(mode),
    },
    clearScreen: false,
  };
});
