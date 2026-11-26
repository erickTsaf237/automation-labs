#!/usr/bin/env bash

set -euo pipefail #evite de continuer le script en cas d'echec d'une etape
# à la première erreur, tout s'arrête
ref="${1:?usage: deploy.sh <ref>}" 

sha="$(git rev-parse --verify "$ref^{commit}")" # référence inconnue : rien n'est touché
version="$(git rev-parse --short "$sha")"
work="$(mktemp -d)"


git archive "$sha" app | tar -x -C "$work"
# le code de ce commit, et lui seul
# cd /workspaces/automation-labs/app/
cd "$work/app"

npm ci && npm run lint && npm test
npm prune --omit=dev


# ce qui peut échouer, avant le serveur
# seules les dépendances d'exécution partent
echo "5-----------------------------------------"
# pwd
# cat ~/.ssh/usine_lab

tar -cz src package.json node_modules \
| ssh -i ~/.ssh/usine_lab  deploy@srv-test 'rm -rf /opt/reservations/* && tar -xz -C /opt/reservations'
echo "6-----------------------------------------"
# le fichier est réécrit (> et non >>) : le script reste rejouable
printf 'APP_VERSION=%s\nAPP_COMMIT=%s\n' "$version" "$sha" \
| ssh -i ~/.ssh/usine_lab deploy@srv-test 'cat > /etc/reservations/reservations.env'
ssh -i ~/.ssh/usine_lab deploy@srv-test 'sudo service reservations restart'
curl -fsS --retry 10 http://srv-test:8080/health # puis /version doit annoncer $sha

