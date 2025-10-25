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

echo "==> Building all packages..."
pnpm -r build

echo "==> Build complete!"
