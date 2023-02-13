FROM jenkins/jenkins:lts-jdk11

USER root

## General
RUN apt-get update && apt-get -y upgrade && apt-get -y install apt-transport-https lsb-release ca-certificates  \
    software-properties-common wget vim && apt-get clean && rm -rf /var/cache/apt/archives

# PHP start
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
RUN apt update

RUN apt -y install php8.2 php-pear software-properties-common libicu-dev gnupg \
  gettext unzip lsb-release zlib1g-dev libpq-dev libzip-dev
RUN apt -y install php8.2-cli php8.2-common php8.2-fpm \
    php8.2-mysql php8.2-gd php8.2-gettext php8.2-bcmath \
    php8.2-zip php8.2-curl php8.2-xml php8.2-mbstring php8.2-dev \
  && pecl install apcu

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# PHP end

# Node installation
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get install -y nodejs

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins

RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
