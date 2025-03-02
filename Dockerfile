FROM alpine:latest AS alpine
RUN apk add openjdk21 gradle
VOLUME /srv
COPY . /srv
WORKDIR /srv
RUN gradle --no-daemon shadowJar && \
    mkdir -p \
    /mnt/bin \
    /mnt/etc \
    /mnt/lib \
    /mnt/mnt \
    && \
    echo /lib >> /mnt/etc/ld-musl-$(uname -m).path && \
    install /usr/lib/libz.so.1 /mnt/lib && \
    install /usr/lib/libz.so.1.3.1 /mnt/lib && \
    install /usr/lib/jvm/java-21-openjdk/lib/libjli.so /mnt/lib && \
    install /usr/lib/jvm/java-21-openjdk/lib/libjava.so /mnt/lib && \
    install /usr/lib/jvm/java-21-openjdk/lib/jvm.cfg /mnt/lib && \
    install /lib/ld-musl-$(uname -m).so.1 /mnt/lib && \
    install /bin/busybox /mnt/bin && \
    install /usr/bin/java /mnt/bin

FROM scratch AS workshop
EXPOSE 8080
ENV JAVA_HOME=/
COPY --from=alpine /mnt /
VOLUME /srv
ENTRYPOINT [ "/bin/java", "-jar", "/srv/build/libs/workshop-organizer-0.2.4-all.jar" ]
