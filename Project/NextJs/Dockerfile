FROM node:alpine

#ARG NextJsAppName
#ENV NextJsAppName=NextJsAppName

WORKDIR /app/nextjs
#COPY $NextAppName/package.json .

#RUN npm install
#COPY $NextAppName .

# Use the entrypoint.sh file to run the Next.js application
ENTRYPOINT ["./entrypoint.sh"]
