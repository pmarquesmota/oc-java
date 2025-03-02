FROM alpine:latest AS alpine
RUN apk add openjdk gradle git
VOLUME /srv
WORKDIR /srv
RUN gradle --no-daemon shadowJar && \
    mkdir -p \
    /srv/bin \
    /srv/etc \
    /srv/lib \
    /srv/mnt \
    && \
    echo /lib >> /srv/etc/ld-musl-$(uname -m).path && \
    install /usr/lib/libz.so.1 /srv/lib && \
    install /usr/lib/libz.so.1.3.1 /srv/lib && \
    install /opt/java/openjdk/lib/libjli.so /srv/lib && \
    install /lib/ld-musl-$(uname -m).so.1 /srv/lib && \
    install /bin/busybox /srv/bin && \
    install /opt/java/openjdk/bin/java /srv/bin

FROM scratch AS workshop
EXPOSE 8080
ENV JAVA_HOME=/
COPY --from=temurin /srv /
VOLUME /mnt
ENTRYPOINT [ "/bin/java", "-jar", "/mnt/build/libs/workshop-organizer-0.2.4-all.jar" ]
