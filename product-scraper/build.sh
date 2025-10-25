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

echo "==> Building database package with declarations..."
cd packages/db
npx tsc --declaration --declarationMap --emitDeclarationOnly false
cd ../..

echo "==> Verifying db build and declarations..."
ls -la packages/db/dist/
cat packages/db/dist/index.d.ts || echo "ERROR: index.d.ts not found!"

echo "==> Building scraper-core package..."
cd packages/scraper-core
npx tsc
cd ../..

echo "==> Building API..."
cd apps/api
npx tsc
cd ../..

echo "==> Verifying all builds..."
echo "DB dist:"
ls -la packages/db/dist/
echo "Scraper-core dist:"
ls -la packages/scraper-core/dist/
echo "API dist:"
ls -la apps/api/dist/

echo "==> Build complete!"
