FROM centos/systemd
MAINTAINER Bernard Lechler <bernard@theminery.com>

RUN yum clean all; yum -y update --nogpgcheck
RUN yum -y install yum-utils

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm; \
    yum-config-manager --enable remi-php72

# Install some must-haves
RUN yum -y install --nogpgcheck \
    epel-release \
    wget \
    git \
    httpd \
    nano \
    postfix \
    gcc-c++ \
    make

RUN yum -y install \
    php \
    php-bcmath \
    php-cli \
    php-curl \
    php-devel \
    php-gd \
    php-fileinfo \
    php-fpm \
    php-imagick \
    php-imap\
    php-intl \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysqlnd \
    php-opcache --nogpgcheck \
    php-pdo \
    php-posix \
    php-xml \
    php-zip

RUN curl https://phar.phpunit.de/phpunit.phar -L -o phpunit.phar && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit



# ------------------------------------------------------------------------

RUN yum install -y geoip emacs

# install http
#RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# install httpd
#RUN yum -y install httpd vim-enhanced bash-completion unzip

# install mysql
#RUN yum install -y mysql mysql-server wget
#RUN echo "NETWORKING=yes" > /etc/sysconfig/network
# start mysqld to create initial tables
# RUN service mysqld start

#RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm

#RUN yum install -y yum-utils
#RUN yum-config-manager --enable remi-php70
#RUN yum-config-manager --enable remi-php72

# install php
#RUN yum install -y php 
#Run yum install -y php php-cli php-curl php-devel php-fileinfo php-gd php-ldap
#RUN yum install -y php php-mcrypt php-cli php-gd php-curl php-devel php-mysql php-ldap php-zip php-fileinfo
#RUN yum install php-mcrypt 
#RUN yum install -y php-mysql 
#RUN yum install -y php-pecl-memcache 
#RUN yum install -y php-pspell
#RUN yum install -y php-snmp php-xml php-xmlrpc php-zip

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py

# install supervisord
# RUN yum install -y python-pip && pip install "pip>=1.4,<1.5" --upgrade
RUN pip install supervisor

# install sshd
RUN yum install -y openssh-server openssh-clients passwd

RUN mkdir /var/www/html/htdocs
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key 
RUN sed -i -e 's|/var/www/html|/var/www/html/htdocs|g' /etc/httpd/conf/httpd.conf

RUN sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config && echo 'root:changeme' | chpasswd

ADD phpinfo.php /var/www/html/
ADD supervisord.conf /etc/
ADD install_geoip_db.sh /root/
RUN chmod +x /root/install_geoip_db.sh && \
    /root/install_geoip_db.sh
EXPOSE 22 80
CMD ["supervisord", "-n"]