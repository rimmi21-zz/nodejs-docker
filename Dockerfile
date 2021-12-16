# To use this file, go to terminal and route to this folder.
# run > docker build .
# run > docker run <id_of_image>

# Use an existing docker image from base

FROM node:alpine

# Download and install a dependency

WORKDIR /usr/app
COPY ./package.json ./
RUN npm install 
COPY ./ ./

# Tell the image what to do when it starts as a container

CMD ["npm" , "start"]