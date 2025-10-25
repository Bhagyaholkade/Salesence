#!/bin/bash
set -e

echo "==> Installing pnpm..."
npm install -g pnpm

echo "==> Installing dependencies..."
pnpm install --no-frozen-lockfile

echo "==> Generating Prisma client..."
cd packages/db
pnpm exec prisma generate
cd ../..

echo "==> Building db package..."
pnpm --filter @scraper/db build

echo "==> Building scraper-core package..."
pnpm --filter @scraper/scraper-core build

echo "==> Building api..."
pnpm --filter api build

echo "==> Build complete!"
