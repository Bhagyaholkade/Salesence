#!/bin/bash
set -e

echo "Installing pnpm globally..."
npm install -g pnpm

echo "Installing dependencies..."
pnpm install

echo "Installing Playwright browsers..."
npx playwright install chromium --with-deps

echo "Building packages..."
pnpm run build

echo "Build complete!"
