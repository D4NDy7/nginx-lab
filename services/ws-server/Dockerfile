FROM node:18-alpine
WORKDIR /app
RUN npm init -y && npm install ws
COPY server.js .
CMD ["node", "server.js"]
