#!/bin/bash
set -e

echo "==> Installing pnpm..."
npm install -g pnpm

echo "==> Installing dependencies..."
pnpm install --no-frozen-lockfile

echo "==> Generating Prisma client..."
cd packages/db && npx prisma generate && cd ../..

echo "==> Building database package..."
cd packages/db && pnpm run build && cd ../..

echo "==> Building scraper-core package..."
cd packages/scraper-core && pnpm run build && cd ../..

echo "==> Installing Playwright..."
npx playwright install chromium --with-deps

echo "==> Building API..."
cd apps/api && pnpm run build && cd ../..

echo "==> Build complete!"
