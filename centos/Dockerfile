# from centos:7
FROM centos:7

# maintainer
MAINTAINER "rancococ" <rancococ@qq.com>

# set arg info
ARG CENTOS_VER=7
ARG MYAPP_HOME=/data/myapp
ARG MYJRE_HOME=/data/myjre
ARG GOSU_URL=https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64
ARG MYJRE_URL=http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/server-jre-8u181-linux-x64.tar.gz

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
    mkdir -p ${MYAPP_HOME} && groupadd -r myapp && useradd -r -m -g myapp -d ${MYAPP_HOME} -s /bin/bash myapp && echo '123456' | passwd --stdin myapp && \
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
