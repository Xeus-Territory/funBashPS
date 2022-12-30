FROM mhart/alpine-node:12

EXPOSE 3000

WORKDIR /app

RUN apk add --update curl git zip 

RUN git clone https://github.com/johnpapa/node-hello.git /app

RUN rm index.js && rm package.json

COPY . /app

RUN npm install

CMD ["npm", "start"]


