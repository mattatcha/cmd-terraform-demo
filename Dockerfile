FROM alpine
RUN apk --no-cache add wget unzip ca-certificates \
  && cd /tmp && wget -q https://releases.hashicorp.com/terraform/0.7.4/terraform_0.7.4_linux_amd64.zip \
  && unzip terraform_0.7.4_linux_amd64.zip \
  && mv terraform /bin \
  && rm terraform_0.7.4_linux_amd64.zip \
  && apk --no-cache del wget unzip
COPY ./tf /bin/tf
ENTRYPOINT ["/bin/tf"]
