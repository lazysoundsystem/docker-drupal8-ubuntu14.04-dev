FROM drupal8-ubuntu14.04:latest
MAINTAINER Andrew Holgate <andrewholgate@yahoo.com>

RUN apt-get update
RUN apt-get -y upgrade

# Install tools for documenting.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-sphinx python-pip doxygen
RUN DEBIAN_FRONTEND=noninteractive pip install sphinx_rtd_theme breathe

# Install XDebug
RUN DEBIAN_FRONTEND=noninteractive pecl install xdebug
COPY xdebug.ini /etc/php5/mods-available/xdebug.ini
RUN ln -s ../../mods-available/xdebug.ini /etc/php5/apache2/conf.d/20-xdebug.ini && \
    ln -s ../../mods-available/xdebug.ini /etc/php5/cli/conf.d/20-xdebug.ini && \
    mkdir /tmp/xdebug && \
    chown www-data:www-data /tmp/xdebug && \
    mkdir /var/log/xdebug && \
    chown www-data:www-data /var/log/xdebug

# Install XHProf
RUN DEBIAN_FRONTEND=noninteractive pecl install -f xhprof
COPY xhprof.ini /etc/php5/mods-available/xhprof.ini
RUN ln -s ../../mods-available/xhprof.ini /etc/php5/apache2/conf.d/20-xhprof.ini
COPY xhprof.conf /etc/apache2/conf.d/xhprof.conf
RUN mkdir /tmp/xhprof && \
    chown www-data:www-data /tmp/xhprof

# Install tools via Composer.
USER ubuntu
RUN composer global require squizlabs/php_codesniffer:~2.0
RUN composer global require drupal/coder:~8.0
RUN composer global require andrewholgate/drupalstrict:~0.1
RUN composer global require halleck45/phpmetrics:~1.0
RUN composer global require pdepend/pdepend:~2.0
RUN composer global require phpmd/phpmd:~2.0
RUN composer global require sebastian/phpcpd:~2.0
RUN composer global require sebastian/phpdcd:~1.0
RUN composer global require phploc/phploc:~2.0
RUN composer global require phpunit/phpunit:~4.0
RUN composer global require phpunit/phpunit-skeleton-generator:~2.0
RUN composer global require phpunit/php-invoker:~1.0
RUN composer global require phpunit/dbunit:~1.0

# Symlink PHP Code Sniffer standards.
RUN ln -s $COMPOSER_HOME/vendor/drupal/coder/coder_sniffer/Drupal $COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/ && \
    ln -s $COMPOSER_HOME/vendor/andrewholgate/drupalstrict/DrupalStrict $COMPOSER_HOME/vendor/squizlabs/php_codesniffer/CodeSniffer/Standards/

USER root

# Install Humbug tool, @todo install via Composer once stable.
#RUN composer global require humbug/humbug:@dev
RUN wget https://padraic.github.io/humbug/downloads/humbug.phar && \
    mv humbug.phar /usr/local/bin/humbug && \
    chmod +x /usr/local/bin/humbug && \
    wget https://padraic.github.io/humbug/downloads/humbug.phar.pubkey && \
    mv humbug.phar.pubkey /usr/local/bin/humbug.pubkey

# Turn on PHP error reporting
RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/apache2/php.ini && \
    sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php5/cli/php.ini  && \
    sed -ri 's/^error_reporting\s*=.*$/error_reporting = -1/g' /etc/php5/apache2/php.ini && \
    sed -ri 's/^error_reporting\s*=.*$/error_reporting = -1/g' /etc/php5/cli/php.ini && \
    sed -ri 's/^display_startup_errors\s*=\s*Off/display_startup_errors = On/g' /etc/php5/apache2/php.ini && \
    sed -ri 's/^display_startup_errors\s*=\s*Off/display_startup_errors = On/g' /etc/php5/cli/php.ini && \
    sed -ri 's/^track_errors\s*=\s*Off/track_errors = On/g' /etc/php5/apache2/php.ini && \
    sed -ri 's/^track_errors\s*=\s*Off/track_errors = On/g' /etc/php5/cli/php.ini && \
    sed -ri 's/^;xmlrpc_errors\s*=\s*0/xmlrpc_errors = 1/g' /etc/php5/apache2/php.ini && \
    sed -ri 's/^;xmlrpc_errors\s*=\s*0/xmlrpc_errors = 1/g' /etc/php5/cli/php.ini

# Symlink log files.
RUN ln -s /var/log/xdebug/xdebug.log /var/www/log/

# Grant ubuntu user access to sudo with no password.
RUN apt-get -y install sudo && \
    echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    usermod -a -G sudo ubuntu


# Clean-up installation.
RUN DEBIAN_FRONTEND=noninteractive apt-get autoclean && apt-get autoremove

RUN /etc/init.d/apache2 restart

CMD ["/usr/local/bin/run"]
