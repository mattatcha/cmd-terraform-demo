FROM alpine

RUN echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk --no-cache add \
      wget unzip ca-certificates \
    && cd /tmp && wget -q https://releases.hashicorp.com/terraform/0.7.4/terraform_0.7.4_linux_amd64.zip \
    && unzip terraform_0.7.4_linux_amd64.zip \
    && mv terraform /bin \
    && rm terraform_0.7.4_linux_amd64.zip \
    && apk --no-cache del wget unzip

RUN apk --no-cache add \
      jq python3 bash docker git sed \
    && pip3 install container-transform \
    && pip3 install awscli

COPY ./bin /usr/local/bin
COPY ./terraform /var/terraform
ENTRYPOINT ["/usr/local/bin/entrypoint"]
