FROM node:18-alpine AS dependencies
WORKDIR /workspace
# COPY package.json yarn.lock ./
COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./
# RUN yarn
RUN \
  if [ -f yarn.lock ]; then yarn --frozen-lockfile; \
  elif [ -f package-lock.json ]; then npm ci; \
  elif [ -f pnpm-lock.yaml ]; then yarn global add pnpm && pnpm i --frozen-lockfile; \
  else echo "Lockfile not found." && exit 1; \
  fi
FROM node:18-alpine AS build
WORKDIR /workspace
COPY --from=dependencies /workspace/node_modules ./node_modules
COPY . .
RUN yarn run build

FROM node:18-alpine AS deploy
ENV NODE_ENV production
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nestjs

WORKDIR /workspace
COPY --from=build --chown=nestjs:nodejs /workspace/dist ./dist
COPY --from=build --chown=nestjs:nodejs /workspace/node_modules ./node_modules
EXPOSE 3004
ENV PORT 3004
USER nestjs
CMD [ "node", "dist/main.js" ]

# WORKDIR /workspace
# # COPY --from=build --chown=nestjs:nodejs /workspace/dist ./dist
# # COPY --from=build --chown=nestjs:nodejs /workspace/node_modules ./node_modules
# COPY --from=build /workspace/dist ./dist
# COPY --from=build /workspace/node_modules ./node_modules
# # USER nestjs
# EXPOSE 3005
# ENV PORT 3005
# # ENTRYPOINT ["yarn","start:prod"]
# CMD [ "node", "dist/main.js" ]