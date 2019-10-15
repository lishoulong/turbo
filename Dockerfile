FROM dockercore/golang-cross

LABEL maintainer="Goren G<gythialy.koo+github@gmail.com>"

# install arm gcc
RUN apt-get update -qq && apt-get install -y aptitude && \
      aptitude install -y -q build-essential \
	  gcc-arm-linux-gnueabi g++-arm-linux-gnueabi gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
	  libc6-dev-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev \
	  gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
	  gcc-mingw-w64 g++-mingw-w64 && \
	  apt -y autoremove && \
      apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

# install goreleaser
RUN  \
	GORELEASER_VERSION=0.118.2 && \
	GORELEASER_SHA=131937804698f57c0f22db833da7425d8a175df131f6cec4b06be1768058a2a1 && \
	GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz && \
	GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE} && \
	wget ${GORELEASER_DOWNLOAD_URL}; \
			echo "$GORELEASER_SHA $GORELEASER_DOWNLOAD_FILE" | sha256sum -c - || exit 1; \
			tar -xzf $GORELEASER_DOWNLOAD_FILE -C /usr/bin/ goreleaser; \
			rm $GORELEASER_DOWNLOAD_FILE;

# update golang
RUN \
	GOLANG_VERSION=1.13.1 && \
	GOLANG_DIST=https://storage.googleapis.com/golang/go${GOLANG_VERSION}.linux-amd64.tar.gz \
	GOLANG_DIST_SHA=94f874037b82ea5353f4061e543681a0e79657f787437974214629af8407d124 && \
	wget -O go.tgz "$GOLANG_DIST"; \
	echo "${GOLANG_DIST_SHA} *go.tgz" | sha256sum -c -; \
	rm -rf /usr/local/go; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; 

RUN go get -u github.com/git-chglog/git-chglog/cmd/git-chglog

CMD ["goreleaser", "-v"]
