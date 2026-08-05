# Stage 1: Build
FROM node:22-alpine AS build
WORKDIR /app

RUN corepack enable

COPY package.json pnpm-lock.yaml ./
RUN pnpm fetch

COPY . .
RUN pnpm install --frozen-lockfile --offline
RUN pnpm build
RUN pnpm install --prod --frozen-lockfile --offline --ignore-scripts

# Stage 2: Runtime (slim, sin toolchain de build)
FROM node:22-alpine
ENV NODE_ENV=production PORT=3000

WORKDIR /app

RUN rm -rf \
      /usr/local/lib/node_modules/npm \
      /usr/local/lib/node_modules/corepack \
      /usr/local/bin/npm \
      /usr/local/bin/npx \
      /usr/local/bin/corepack

COPY --from=build /app/package.json ./
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

USER node

EXPOSE $PORT
CMD ["node", "dist/main"]
