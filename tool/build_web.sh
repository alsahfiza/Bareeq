#!/usr/bin/env bash
set -e

echo "🔹 Cleaning..."
flutter clean
rm -rf build

echo "🔹 Building PUBLIC app..."
flutter build web \
  -t lib/main_public.dart \
  -o build/web

echo "🔹 Building ADMIN app..."
flutter build web \
  -t lib/main_admin.dart \
  --base-href /admin/ \
  -o build/web-admin

echo "🔹 Merging admin into public..."
mkdir -p build/web/admin
rsync -a --delete build/web-admin/ build/web/admin/

echo "✅ Build complete"
