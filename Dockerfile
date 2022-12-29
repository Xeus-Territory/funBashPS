FROM mhart/alpine-node:14

EXPOSE 3000

WORKDIR /app

RUN apk add --update curl git zip 

RUN git clone https://github.com/johnpapa/node-hello.git /app

RUN npm install

CMD ["npm", "start"]