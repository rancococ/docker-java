# from centos:7
FROM centos:7

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set arg info
ARG CENTOS_VER=7
ARG APP_HOME=/data/app
ARG JRE_HOME=/data/jre
ARG GOSU_URL=https://github.com/tianon/gosu/releases/download/1.11/gosu-amd64
ARG JRE_URL=https://github.com/rancococ/serverjre/releases/download/server-jre-8/server-jre-8u192-linux-x64.tar.gz

# copy script
COPY docker-entrypoint.sh /

# install repositories and packages : curl bash passwd openssl openssh wget net-tools gettext zip unzip ncurses
RUN \rm -rf /etc/yum.repos.d/*.repo && \
    curl -s -o /etc/yum.repos.d/centos.repo http://mirrors.aliyun.com/repo/Centos-${CENTOS_VER}.repo && \
    curl -s -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-${CENTOS_VER}.repo && \
    sed -i '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/centos.repo && \
    sed -i '/mirrors.cloud.aliyuncs.com/d' /etc/yum.repos.d/centos.repo && \
    yum clean all && yum makecache && \
    \rm -rf /etc/pki/rpm-gpg/* && \
    curl -s -o /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${CENTOS_VER} https://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-${CENTOS_VER} && \
    curl -s -o /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${CENTOS_VER} https://mirrors.aliyun.com/epel/RPM-GPG-KEY-EPEL-${CENTOS_VER} && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-${CENTOS_VER} && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${CENTOS_VER} && \
    yum install -y passwd openssl openssh-server wget net-tools gettext zip unzip ncurses && \
    yum clean all && \rm -rf /var/lib/{cache,log} /var/log/lastlog && \
    ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' && \
    ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' && \
    ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key  -N '' && \
    sed -i 's/#UseDNS.*/UseDNS no/g' /etc/ssh/sshd_config && \
    sed -i '/^session\s\+required\s\+pam_loginuid.so/s/^/#/' /etc/pam.d/sshd && \
    echo "Asia/Shanghai" > /etc/timezone && \ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    mkdir -p /root/.ssh && chown root.root /root && chmod 700 /root/.ssh && echo 'admin' | passwd --stdin root && \
    mkdir -p ${APP_HOME} && groupadd -r myapp && useradd -r -m -g myapp -d ${APP_HOME} -s /bin/bash myapp && echo '123456' | passwd --stdin myapp && \
    tempuuid=$(cat /proc/sys/kernel/random/uuid) && \
    temphome=/tmp/${tempuuid} && mkdir -p ${temphome} && \
    wget -c -O /usr/local/bin/gosu --no-cookies --no-check-certificate "${GOSU_URL}" && chmod +x /usr/local/bin/gosu && \
    wget -c -O ${temphome}/myjre.tar.gz --no-cookies --no-check-certificate ${JRE_URL} && \
    tar -zxf ${temphome}/myjre.tar.gz -C ${temphome} && \
    myjrename=$(tar -tf ${temphome}/myjre.tar.gz | awk -F "/" '{print $1}' | sed -n '1p') && \
    mkdir -p ${JRE_HOME} && \cp -rf ${temphome}/${myjrename}/jre/. ${JRE_HOME} && \rm -rf ${temphome} && \
    sed -i 's/#crypto.policy=unlimited/crypto.policy=unlimited/g' "${JRE_HOME}/lib/security/java.security" && \
    chmod -Rf u+x ${JRE_HOME}/bin/* && \
    chown -R myapp:myapp /data && \
    chown -R myapp:myapp /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# set environment
ENV TZ "Asia/Shanghai"
ENV TERM xterm
ENV JAVA_HOME ${JRE_HOME}
ENV CLASSPATH .:${JRE_HOME}/lib
ENV PATH .:${PATH}:${JRE_HOME}/bin

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
