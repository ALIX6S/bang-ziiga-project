#!/bin/bash

echo "========================================"
echo "  DIAGNOSTIC COMPLET - BÃNG ZĨIGA"
echo "========================================"

echo -e "\n### 1. STRUCTURE PROJET ###"
ls -la

echo -e "\n### 2. CONTENU UPLOADS/SITES ###"
ls -lh uploads/sites/ 2>/dev/null || echo "❌ Dossier introuvable"

echo -e "\n### 3. CONTENU UPLOADS/ITINERAIRES ###"
ls -lh uploads/itineraires/ 2>/dev/null || echo "❌ Dossier introuvable"

echo -e "\n### 4. FICHIERS GIT UPLOADS ###"
git ls-files uploads/

echo -e "\n### 5. GITIGNORE (uploads) ###"
cat .gitignore | grep -A 3 -B 1 uploads

echo -e "\n### 6. GIT STATUS ###"
git status --short

echo -e "\n### 7. STRUCTURE DOSSIERS ###"
find . -maxdepth 3 -type d -not -path '*/node_modules/*' -not -path '*/.git/*' | head -30

echo -e "\n### 8. TEST RENDER DEBUG-FS ###"
curl -s https://bang-ziiga-project.onrender.com/debug-fs | python3 -m json.tool 2>/dev/null || curl -s https://bang-ziiga-project.onrender.com/debug-fs

echo -e "\n### 9. TEST RENDER TEST-UPLOADS ###"
curl -s https://bang-ziiga-project.onrender.com/test-uploads | python3 -m json.tool 2>/dev/null || curl -s https://bang-ziiga-project.onrender.com/test-uploads

echo -e "\n### 10. MONGODB CHECK ###"
node quick_check_mongo.js 2>&1

echo -e "\n========================================"
echo "  FIN DU DIAGNOSTIC"
echo "========================================"