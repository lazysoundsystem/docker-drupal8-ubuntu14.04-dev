# About

Dockerised Drupal 8 development environment using Ubuntu 14.04. This image is a development companion to the [docker-drupal-ubuntu14.04](https://github.com/andrewholgate/docker-drupal8-ubuntu14.04) project.

# Included Tools

## Debugging Tools

- [XDebug](http://www.xdebug.org/) - PHP debugging and profiling.
- [XHProf](http://pecl.php.net/package/xhprof) - function-level hierarchical profiler.

## Development tools
- [Drupal Console](https://www.drupal.org/project/console) - execute Drupal

## Code Inspection Tools

- [Drupal Coder](https://www.drupal.org/project/coder) - defines Drupal coding standards.
- [Drupal Strict](https://github.com/andrewholgate/drupalstrict) - defines strict Drupal and PHP coding standards.
- [PHP Code Sniffer](https://github.com/squizlabs/PHP_CodeSniffer) - detect violations of coding standards.
- [PHP Mess Detector (PHPMD)](http://phpmd.org/) - discover possible bugs and suboptimal code.
- [PHP Copy/Paste Detector (PHPCPD)](https://github.com/sebastianbergmann/phpcpd) - detect copy/pasted code.
- [PHP Dead Code Detector (PHPDCD)](https://github.com/sebastianbergmann/phpdcd) - discover unused PHP code.
- [PHP Lines of Code (PHPLoC)](https://github.com/sebastianbergmann/phploc) - measuring the size of a project.
- [PHP Depend (PHPMD)](http://pdepend.org/) - generate design quality metrics.
- [PHPUnit](https://phpunit.de/) - unit testing PHP code.

## PHP Documentation Tools

- [DoxyGen](http://www.doxygen.org) - generate documentation from annotated PHP code. It is used to generate XML which is then interpreted by Sphinx.
- [Sphinx](http://sphinx-doc.org/) - generate beautiful [Read The Docs](http://docs.readthedocs.org/en/latest/) format using [Breathe](https://breathe.readthedocs.org/) as a bridge to DoxyGen XML output.

# Installation

## Create Presistant Database data-only container

```bash
# Build database image based off MySQL 5.5
sudo docker run -d --name mysql-drupal8-ubuntu14-dev mysql:5.5 --entrypoint /bin/echo MySQL data-only container for Drupal 8 Dev MySQL
```

## Build Drupal Base Image

```bash
# Clone Drupal base docker repository
git clone https://github.com/andrewholgate/docker-drupal8-ubuntu14.04.git
# Build docker image
cd docker-drupal8-ubuntu14.04
sudo docker build --rm=true --tag="drupal8-ubuntu14.04" . | tee ./build.log
```

## Build Project Development Image

```bash
# Clone Drupal development docker repository
git clone https://github.com/andrewholgate/docker-drupal8-ubuntu14.04-dev.git
cd docker-drupal8-ubuntu14.04-dev
# Customise docker-compose.yml configurations for environment.
cp docker-compose.yml.dist docker-compose.yml
vim docker-compose.yml
# Build docker image
sudo docker build --rm=true --tag="drupal8-ubuntu14.04-dev" . | tee ./build.log
```

## Build Project using Docker Compose

```bash
# Build docker containers using Docker Composer.
sudo docker-compose build
sudo docker-compose up -d
```

## Host Access

From the host server, add the web container IP address to the hosts file.

```bash
# Add IP address to hosts file.
sudo bash -c "echo $(sudo docker inspect -f '{{ .NetworkSettings.IPAddress }}' \
dockerdrupal8ubuntu1404dev_drupal8ubuntu14devweb_1) \
drupal8dev.example.com \
>> /etc/hosts"
```

## Logging into Web Front-end

```bash
# Using the container name of the web frontend.
sudo docker exec -it dockerdrupal8ubuntu1404dev_drupal8ubuntu14devweb_1 su - ubuntu
```
