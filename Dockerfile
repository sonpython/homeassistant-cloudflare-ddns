FROM alpine:3.15

RUN apk add --no-cache curl bash jq

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
