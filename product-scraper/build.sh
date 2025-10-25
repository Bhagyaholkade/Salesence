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
npx tsc --declaration --declarationMap --emitDeclarationOnly false
cd ../..

echo "==> Building scraper-core package..."
cd packages/scraper-core
npx tsc --declaration --declarationMap --emitDeclarationOnly false
cd ../..

echo "==> Installing Playwright browsers with system dependencies..."
npx playwright install --with-deps chromium

echo "==> Building API..."
cd apps/api
npx tsc --declaration --declarationMap --emitDeclarationOnly false
cd ../..

echo "==> Build complete!"
