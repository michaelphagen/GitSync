FROM alpine:3.12

RUN apk update && apk add git bash curl gawk
WORKDIR /app
COPY ./gitSync.bash /app/gitSync.bash
RUN chmod +x /app/gitSync.bash
RUN mkdir /app/git
CMD while true; do echo "Running GitSync"; /app/gitSync.bash -u $USER -f /app/git $STARRED $PERSONAL_TOKEN; echo "Done Syncing, sleeping for $INTERVAL"; sleep $INTERVAL; done