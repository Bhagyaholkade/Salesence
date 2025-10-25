#!/bin/bash
set -e

echo "==> Installing pnpm..."
npm install -g pnpm

echo "==> Installing dependencies..."
pnpm install --no-frozen-lockfile

echo "==> Installing Playwright browsers with system dependencies..."
npx playwright install --with-deps chromium

echo "==> Generating Prisma client..."
cd packages/db
npx prisma generate
cd ../..

echo "==> Building database package..."
cd packages/db
npx tsc
cd ../..

echo "==> Building scraper-core package..."
cd packages/scraper-core
npx tsc
cd ../..

echo "==> Building API..."
cd apps/api
npx tsc
cd ../..

echo "==> Build complete!"
