FROM alpine:latest AS alpine
RUN apk add openjdk21 gradle git
VOLUME /srv
WORKDIR /srv
RUN git clone https://github.com/pmarquesmota/oc-java.git /srv && \
    gradle --no-daemon shadowJar && \
    mkdir -p \
    /mnt/bin \
    /mnt/etc \
    /mnt/lib \
    /mnt/mnt \
    && \
    echo /lib >> /mnt/etc/ld-musl-$(uname -m).path && \
    install /usr/lib/libz.so.1 /mnt/lib && \
    install /usr/lib/libz.so.1.3.1 /mnt/lib && \
    install /opt/java/openjdk/lib/libjli.so /mnt/lib && \
    install /lib/ld-musl-$(uname -m).so.1 /mnt/lib && \
    install /bin/busybox /mnt/bin && \
    install /opt/java/openjdk/bin/java /mnt/bin

FROM scratch AS workshop
EXPOSE 8080
ENV JAVA_HOME=/
COPY --from=alpine /mnt /
VOLUME /mnt
ENTRYPOINT [ "/bin/java", "-jar", "/mnt/build/libs/workshop-organizer-0.2.4-all.jar" ]
