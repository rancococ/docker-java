# from frolvlad/alpine-glibc:alpine-3.8
FROM frolvlad/alpine-glibc:alpine-3.8

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set arg info
ARG ALPINE_VER=v3.8
ARG MYAPP_HOME=/data/myapp
ARG MYJRE_HOME=/data/myjre
ARG GOSU_URL=https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64
ARG MYJRE_URL=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/server-jre-8u181-linux-x64.tar.gz

# copy script
COPY docker-entrypoint.sh /

# install repositories and packages : curl bash openssh wget net-tools gettext zip unzip tzdata ncurses
RUN echo -e "https://mirrors.aliyun.com/alpine/${ALPINE_VER}/main\nhttps://mirrors.aliyun.com/alpine/${ALPINE_VER}/community" > /etc/apk/repositories && \
    apk --update add curl bash openssh wget net-tools gettext zip unzip tzdata ncurses && \
    \rm -rf /var/cache/apk/* && \
    ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key  -N '' && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key  -N '' && \
    sed -i 's/#UseDNS.*/UseDNS no/g' /etc/ssh/sshd_config && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config && \
    sed -i "s/#AuthorizedKeysFile/AuthorizedKeysFile/g" /etc/ssh/sshd_config && \
    echo "Asia/Shanghai" > /etc/timezone && \ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh && \
    sed -i 's/root:x:0:0:root:\/root:\/bin\/ash/root:x:0:0:root:\/root:\/bin\/bash/g' /etc/passwd && echo -e 'admin\nadmin' | passwd root && \
    mkdir -p ${MYAPP_HOME} && addgroup -S myapp && adduser -S -G myapp -h ${MYAPP_HOME} -s /bin/bash myapp && echo -e '123456\n123456' | passwd myapp && \
    wget -c -O /usr/local/bin/gosu --no-cookies --no-check-certificate "${GOSU_URL}" && chmod +x /usr/local/bin/gosu && \
    wget -c -O /tmp/myjre.tar.gz --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" ${MYJRE_URL} && \
    tar -zxf /tmp/myjre.tar.gz -C /tmp/ && \
    myjrename=$(tar -tf /tmp/myjre.tar.gz | awk -F "/" '{print $1}' | sed -n '1p') && \
    mkdir -p ${MYJRE_HOME} && \cp -rf /tmp/${myjrename}/jre/. ${MYJRE_HOME} && \rm -rf /tmp/* && \
    sed -i 's/#crypto.policy=unlimited/crypto.policy=unlimited/g' "${MYJRE_HOME}/lib/security/java.security" && \
    chmod -Rf u+x ${MYJRE_HOME}/bin/* && \
    chown -R myapp:myapp /data && \
    chown -R myapp:myapp /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# set environment
ENV TZ "Asia/Shanghai"
ENV TERM xterm
ENV JAVA_HOME ${MYJRE_HOME}
ENV CLASSPATH .:${MYJRE_HOME}/lib
ENV PATH .:${PATH}:${MYJRE_HOME}/bin

# set work home
WORKDIR /data

# expose port 22
EXPOSE 22

# stop signal
STOPSIGNAL SIGTERM

# entry point
ENTRYPOINT ["/docker-entrypoint.sh"]

# default command
CMD ["java", "-version"]
