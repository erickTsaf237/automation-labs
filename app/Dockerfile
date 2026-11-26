# Image de l'application, fournie et fonctionnelle. L'améliorer (multi-étapes, utilisateur non root) est un bonus.
# Construction, depuis la racine du dépôt :
#   docker build --build-arg APP_VERSION=1.0.0 --build-arg APP_COMMIT="$(git rev-parse HEAD)" -t reservations app
FROM node:24.22.3-trixie-slim@sha256:af02d57b57719b9657a45199a79264a9437940cd55b3c7b3fc99615654f124a0 as deps

WORKDIR /app

# Les dépendances d'abord : cette couche reste en cache tant que package-lock.json ne change pas.
COPY package.json package-lock.json ./
# RUN npm ci --omit=dev --no-audit --no-fund && npm cache clean --force

RUN npm ci --omit=dev --no-audit --no-fund && npm cache clean --force

FROM node:24.22.3-trixie-slim@sha256:af02d57b57719b9657a45199a79264a9437940cd55b3c7b3fc99615654f124a0
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY package.json ./

# COPY src ./src

COPY src ./src

# Posées par celui qui construit l'image : c'est ce que renvoie /version.
ARG APP_VERSION=0.0.0-dev
ARG APP_COMMIT=unknown
ENV NODE_ENV=production \
    PORT=8080 \
    APP_VERSION=${APP_VERSION} \
    APP_COMMIT=${APP_COMMIT}

USER node

EXPOSE 8080
CMD ["node", "src/server.js"]
