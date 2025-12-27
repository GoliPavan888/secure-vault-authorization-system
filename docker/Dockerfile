FROM node:18-alpine

WORKDIR /app

RUN apk add --no-cache netcat-openbsd

COPY package.json package-lock.json ./
RUN npm install

COPY . .

RUN npx hardhat compile

CMD ["sh", "./docker/entrypoint.sh"]
