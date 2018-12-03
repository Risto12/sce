# Palvelintenhallinta LAMP
Lampin asennus salt master - minionilla.<br> 
Testikone on T480 lenovo <br>
OS vagrant bento/ubuntu-18.04.<br>

Kokosin Lampin varmiiksi "moduuleista" mitä olen jo aiemmin tehnyt. Ainoastaan mysql
tietokanta ja testi php file on nyt tehty uudelleen.
Moduulien repot: https://github.com/Risto12/sce, https://github.com/Risto12/saltstack.
Kerron tässä pienissä paloissa miten moduuli tehdään, mutta valmis lamp moduuli on nähtävissä kokonaisuudessaan https://github.com/Risto12/sce/tree/master/lamp

## 1. /srv/salt kansioon tulee lamp tiedosto. Sinne tehdään init.sls tiedosto, jonka sisältö:

> include:
>     - mysql <br>

Tämä asentaa mysql asetukset erillisestä moduulista. Eli erillinen kansio /srv/salt/mysql,jonka sisällä on luonnollisesti init.sls tiedosto, jonka sisältö:

>\#!pyobjects
>
>value = __salt__['pillar.get']('mysqlpass', 'salainen')
>
>Pkg.installed("debconf-utils")
>with Debconf.set("mysqlroot", data=
> {
> 'mysql-server/root_password':{'type':'password', 'value':value},
> 'mysql-server/root_password_again': {'type':'password', 'value':value}
> }):
> Pkg.installed("mysql-server")<br>

Tämä tiedosto ei ole yamlia vaan pythonia. Malli tähän on otettu suoraan Tero Karvisen mysql moduulista

## 2. jatketaan /srv/salt/lamp init.sls tiedoston rakentamista. 
  ... tarkoittaa edellistä koodia, eli nyt include: - mysql<br>
  Lisätään automaattinen authentikointi ja tietokantalauseet 
  
  
> ...
> /home/vagrant/.my.cnf:
>  file.managed:
>    - source: salt://lamp/auth
>    - template: jinja
>    - context:
>       password: {{ pillar.get('mysqlpass', 'salainen') }}
>
>/home/vagrant/querys:
>  file.managed:
>    - source: salt://lamp/querys
>
>( cd /home/vagrant/ ; mysql -u root < querys ):
>   cmd.run:
>- user: vagrant

Nyt joudutaan luomaan samaan kansioon kaksi tiedostoa. auth johon tulee authentikointi ja querys johon tulee tietokantalauseet.

auth:

>[client]
>user=root
>password={{ password }}

querys:

>CREATE DATABASE testo;
>
>USE testo;
>
>CREATE TABLE Persons (
>    ID int NOT NULL AUTO_INCREMENT,
>    NAME varchar(255) NOT NULL,
>    PRIMARY KEY (ID)
>); 
>
>INSERT INTO Persons (NAME) values ("Chifu"),("Fuji"),("Kabanos");<br>

nyt mysql voi kirjautua vain antamalla komennon mysql(toimii vain käyttäjälle, jonka kotihakemistossa tämä tiedosto on)

##Asennetaan apache2 ja tehdään index.php tiedosto.

...
>apache2:
>  pkg.installed
>
>/var/www/html/index.php:
> file.managed:
>   - source: salt://lamp/index.php
>
>/etc/apache2/mods-enabled/userdir.conf:
> file.symlink:
>   - target: ../mods-available/userdir.conf
>
>/etc/apache2/mods-enabled/userdir.load:
> file.symlink:
> target: ../mods-available/userdir.load<br>

Sisältö index.php tiedostoon:
><?php
>$servername = "localhost";
>$username = "root";
>$dbname = "testo";
>$password = "salainen";
>$conn = new mysqli($servername, $username, $password, $dbname);
>// Check connection
>if ($conn->connect_error) {
>    die("Connection failed: " . $conn->connect_error);
>}
>$sql = "SELECT name FROM Persons";
>$result = $conn->query($sql);
>if ($result->num_rows > 0) {
>    // output data of each row
>    while($row = $result->fetch_assoc()) {
>        echo $row["name"]. "   ";
>    }
>} else {
>    echo "0 results";
>}
>$conn->close();
>?>

 
##3. Asennetaan php7.2
...
>libapache2-mod-php7.2:
>pkg.installed
>
>etc/apache2/mods-available/php7.2.conf:
> file.managed:
>   - source: salt://lamp/php7.2.conf
>
>apache2check:
> service.running:
>   - name: apache2
>   - watch:
> file: /etc/apache2/mods-available/php7.2.conf

ja luodaan php7.2.conf. Tämä mahdollistaa php käytön kotihakemistosta.

><FilesMatch ".+\.ph(ar|p|tml)$">
>    SetHandler application/x-httpd-php
></FilesMatch>
><FilesMatch ".+\.phps$">
>    SetHandler application/x-httpd-php-source
>    Require all denied
></FilesMatch>
><FilesMatch "^\.ph(ar|p|ps|tml)$">
>    Require all denied
></FilesMatch>
>
>#<IfModule mod_userdir.c>
>#    <Directory /home/*/public_html>
>#        php_admin_flag engine Off
>#    </Directory>
>#</IfModule>



