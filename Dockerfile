FROM node:12

WORKDIR /coursework2

COPY server.js ./

EXPOSE 8080

CMD ["node", "server.js"]
