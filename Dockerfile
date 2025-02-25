FROM node:16

RUN apt-get update && apt-get install -y default-mysql-client

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 8080

CMD ["npm", "start"]

