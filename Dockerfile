FROM alpine AS builder
RUN apk add --update --no-cache alpine-sdk
RUN git clone --depth 1 git://git.alpinelinux.org/aports
COPY patches patches
RUN cd aports \
	&& git apply ../patches/* \
	&& abuild-keygen -a -n \
	&& cd main/privoxy \
	&& abuild -F deps && abuild -F 

FROM alpine
COPY --from=builder /root/packages /root/packages
RUN apk add --update --no-cache --allow-untrusted --repository /root/packages/main privoxy
