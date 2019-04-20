# docker-java

#### 项目介绍
docker-java

1. alpine:curl bash openssh wget net-tools gettext zip unzip tzdata ncurses
2. centos:passwd openssl openssh-server wget net-tools gettext zip unzip ncurses
3. support sshd and jre 1.8
4. apphome: /data/app
5. jrehome: /data/jre
6. user: root/admin; app/123456
7. usage:
docker run -it --rm --name java-1.8.192-alpine registry.cn-hangzhou.aliyuncs.com/rancococ/java:1.8.192-alpine "bash"
docker run -it --rm --name java-1.8.192-centos registry.cn-hangzhou.aliyuncs.com/rancococ/java:1.8.192-centos "bash"
