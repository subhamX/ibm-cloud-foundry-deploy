FROM alpine:3.10

# Installing bash
RUN apk add --no-cache bash
# Installing curl
RUN apk --no-cache add curl
# Copying entrypoint.sh
COPY entrypoint.sh /entrypoint.sh
# Updating the permissions
RUN chmod +x entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]

