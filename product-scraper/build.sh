#!/bin/bash
set -e

echo "==> Installing pnpm..."
npm install -g pnpm

echo "==> Installing dependencies..."
pnpm install --no-frozen-lockfile

echo "==> Installing Playwright browsers with system dependencies..."
pnpm exec playwright install --with-deps chromium

echo "==> Generating Prisma client..."
cd packages/db
pnpm exec prisma generate
cd ../..

echo "==> Building database package..."
cd packages/db
pnpm exec tsc
cd ../..

echo "==> Building scraper-core package..."
cd packages/scraper-core
pnpm exec tsc
cd ../..

echo "==> Building API..."
cd apps/api
pnpm exec tsc
cd ../..

echo "==> Build complete!"
