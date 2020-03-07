FROM golang:1.14

WORKDIR /tmp

ARG protocRelease="https://github.com/protocolbuffers/protobuf/releases/download/v3.11.4/protoc-3.11.4-linux-x86_64.zip"

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update

# install protobuf compiler
RUN PROTOC_ZIP=$(mktemp) \
    && apt-get update \
    && apt-get install -y unzip \
    && wget -q ${protocRelease} -O ${PROTOC_ZIP} \
    && unzip ${PROTOC_ZIP} -d /usr/local \
    && rm -rf ${PROTOC_ZIP}

# install protoc generators
RUN go get -u github.com/go-task/task/cmd/task \
    && go get -u github.com/gogo/protobuf/protoc-gen-gogofast \
    && go get -u github.com/envoyproxy/protoc-gen-validate

# install node and yarn
RUN apt install -y yarn

ENTRYPOINT ["task"]