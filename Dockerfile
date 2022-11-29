FROM node:18.12.1-alpine

USER node

RUN mkdir -p /home/node/app
WORKDIR /home/node/app

COPY --chown=node package*.json .
RUN npm ci

COPY --chown=node . .
RUN npm run build

ENV HOST=0.0.0.0 PORT=3000

EXPOSE ${PORT}

CMD ["npm", "run", "start"]
