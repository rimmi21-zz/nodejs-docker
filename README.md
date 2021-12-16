# Node.js App in Docker

## Goal

In this blog we learn to create a Node.js Application, wrap it inside of a docker container and then be able to access the web application from a browser running in our local machine.

To begin, we first create a new folder from our terminal. I'd name it `nodejs-docker`.

`mkdir nodejs-docker`

And then, we get inside this directory and open open our favourite code editor.

`cd nodejs-docker`

`code .`

My VS Code opens when I hit the above command.

We, create our package.json file adding `express` as a dependency, and initializing `index.js` as our main node.js file.

We write a few lines of code to define a simple hello world message that displays when we go to localhost:8080.

Node files should always be installed and then runned. So, we will still need to install the package(s) that we have in our package.json file, by typing `npm install` inside this directory, and `npm run` to run the app.

But before that, we create the docker image, inside which this app will run.

To do that, we create a new file and name it: `Dockerfile`. Remmeber dockerfiles have no extensions.

Now, we visit [docker hub](https://hub.docker.com/) and search for an Image for Node that someone else would have created. As alpine doesn't contain the Node image. So, using alpine would result in a fail of installation. Therefore we get to the [node image](https://hub.docker.com/_/node) page. And we see several versions here. We select the alpine version and add it to our dockerfile.

`FROM node:alpine`

We need to make sure, we have the WORKDIR mentioned in our dockerfile, else we might run into erroes. The WORKDIR instruction sets the working directory for any RUN, CMD, ENTRYPOINT, COPY and ADD instructions that follow it in the Dockerfile. The WORKDIR instruction can be used multiple times in a Dockerfile. If a relative path is provided, it will be relative to the path of the previous WORKDIR instruction.

`WORKDIR /usr/app`

Then, we must make sure our `package.json` file and `index.js` file are available to our docker image. For that, we need to specifically instruct our dockerfile to have them included. Therefore, we copy them, just like this:

`COPY ./ ./`

But, before we directly use this, inorder to save all our changes that we do to the index.js file, we need to make sure the build process goes error free. So we divide the COPY instruction into two parts. One to install npm, that would require only the package.json file. So we define it in this order:

`COPY ./package.json ./`

and then, we run npm, like this:

`RUN npm install`

and then, we define the second COPY instruction

`COPY ./ ./`

Now, anytime we make changes to our index.js file, it will not invalidate the

`COPY ./package.json ./`
`RUN npm install`

cache for the processes above. So now, even if we build the dockerfile again anad again, anything that's above these 2 above commands, till these 2 above commands, will not be rebuild.

Now, for the final step, we create our startup command, like this:

`CMD ["npm" , "start"]`

We get back to our terminal, and build our docker file with the command:

`docker build -t sohinipattanayak/nodejs-docker .`

Post that, once the build is completed successfully, we run our docker image with the following command:

`docker run -p 8080:8080 sohinipattanayak/nodejs-docker`

Here the `-p` flag is very essential, else we won't be see our application live on our server. Port mapping comes to the picture here!

Through this instruction, we tell Docker that any incomming request to this (8080) port on localhost should point towards this (8080) port inside the container. So, in our node app, inside the index.js file, we have port 8080, where the app listens. In our docker image, we can have port 80801/8082/8083 etc, that we can point to inside the container. By this i mean, even if our app runs on port 8080 in the app, we can specify a different port inside the container, inside which the app's 8080 server would run. I know it was complex, but i just tried to give a possibility.

And then, we can see the server starts and is succesfully running in localhost:8080.

For the final steps, we can visit localhost:8080 from our browser and see our simple string displayed!
