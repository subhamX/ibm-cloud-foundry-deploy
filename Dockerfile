FROM alpine:3.10

RUN apk add --no-cache bash
RUN apk --no-cache add curl
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]

