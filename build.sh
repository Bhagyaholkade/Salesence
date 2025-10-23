#!/bin/bash

# Clean any existing build artifacts
rm -rf dist
rm -rf .vite
rm -rf node_modules/.vite

# Install dependencies
npm ci

# Build for production
NODE_ENV=production npm run build

# Verify build output
ls -la dist/