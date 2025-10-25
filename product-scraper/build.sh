#!/bin/bash
set -e

echo "==> Installing pnpm..."
npm install -g pnpm

echo "==> Installing dependencies..."
pnpm install --no-frozen-lockfile

echo "==> Generating Prisma client..."
cd packages/db
npx prisma generate
cd ../..

echo "==> Building all packages in correct order..."
pnpm -r --filter "@scraper/db" run build
pnpm -r --filter "@scraper/scraper-core" run build
pnpm -r --filter "@scraper/api" run build

echo "==> Verifying builds..."
ls -la packages/db/dist/ || echo "DB dist not found"
ls -la packages/scraper-core/dist/ || echo "Scraper-core dist not found"
ls -la apps/api/dist/ || echo "API dist not found"

echo "==> Build complete!"
