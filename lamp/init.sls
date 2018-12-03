include:
  - mysql

apache2:
  pkg.installed

libapache2-mod-php7.2:
  pkg.installed

/home/vagrant/.my.cnf:
  file.managed:
    - source: salt://lamp/auth
    - template: jinja
    - context:
       password: {{ pillar.get('mysqlpass', 'salainen') }}

/home/vagrant/querys:
  file.managed:
    - source: salt://lamp/querys

( cd /home/vagrant/ ; mysql -u root < querys ):
   cmd.run:
    - user: vagrant

/var/www/html/index.php:
 file.managed:
   - source: salt://lamp/index.php

/etc/apache2/mods-enabled/userdir.conf:
 file.symlink:
   - target: ../mods-available/userdir.conf

/etc/apache2/mods-enabled/userdir.load:
 file.symlink:
   - target: ../mods-available/userdir.load

/etc/apache2/mods-available/php7.2.conf:
 file.managed:
   - source: salt://lamp/php7.2.conf

apache2check:
 service.running:
   - name: apache2
   - watch:
      - file: /etc/apache2/mods-available/php7.2.conf
