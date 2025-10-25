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

echo "==> Verifying db build..."
ls -la packages/db/dist/

echo "==> Building scraper-core package with declarations..."
cd packages/scraper-core
npx tsc --declaration --declarationMap --emitDeclarationOnly false
cd ../..

echo "==> Verifying scraper-core build..."
ls -la packages/scraper-core/dist/

echo "==> Building API with declarations..."
cd apps/api
npx tsc --declaration --declarationMap --emitDeclarationOnly false
cd ../..

echo "==> Verifying all builds..."
echo "DB dist:"
ls -la packages/db/dist/
echo "Scraper-core dist:"
ls -la packages/scraper-core/dist/
echo "API dist:"
ls -la apps/api/dist/

echo "==> Build complete!"
