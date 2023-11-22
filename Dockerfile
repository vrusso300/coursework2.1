FROM node:12

WORKDIR /coursework2

COPY server.js ./

RUN npm install

EXPOSE 8080

CMD ["npm" , "start"]
