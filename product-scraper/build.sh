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

echo "==> Building database package..."
cd packages/db
npx tsc --build
cd ../..

echo "==> Verifying db build..."
ls -la packages/db/dist/

echo "==> Building scraper-core package..."
cd packages/scraper-core
npx tsc --build
cd ../..

echo "==> Building API..."
cd apps/api
npx tsc --build
cd ../..

echo "==> Verifying all builds..."
ls -la packages/db/dist/
ls -la packages/scraper-core/dist/
ls -la apps/api/dist/

echo "==> Build complete!"
