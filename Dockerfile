# start from base
FROM node:10.24-alpine as builder

MAINTAINER Jan Bouchner <jan.bouchner@gmail.com>

RUN apk add --no-cache python make g++

COPY package*.json ./

RUN yarn

# The instructions for second stage
FROM node:10.24-alpine

WORKDIR /usr/src/app
COPY --from=builder node_modules node_modules

# Bundle app source
COPY . .

# fetch app specific deps
## Add the wait script to the image
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.3/wait /wait
RUN apk add --no-cache python
RUN chmod +x /wait
RUN chmod -R +x /usr/src/app/separator/separator.py

# expose port
EXPOSE 3001

CMD ["yarn", "start"]
