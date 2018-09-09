# docker-java

#### 项目介绍
docker-java

1. alpine:curl bash openssh wget net-tools gettext zip unzip tzdata ncurses
2. centos:passwd openssl openssh-server wget net-tools gettext zip unzip ncurses
3. support sshd and jre 1.8
4. apphome: /data/myapp
5. jrehome: /data/myjre
6. user: root/admin; myapp/123456
7. usage:
docker run -it --rm --name alpine-java-1.8.181 -p 18080:8080 -p 10001:10001 -p 10002:10002 myharbor.com/base/java:alpine-java-1.8.181 "bash"
docker run -it --rm --name centos-java-1.8.181 -p 18080:8080 -p 10001:10001 -p 10002:10002 myharbor.com/base/java:centos-java-1.8.181 "bash"
