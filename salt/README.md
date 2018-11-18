# Haaga-Helia Palvelinten hallinta ict4tn022 - Mini project

## this saltstack project will install my favorite software development tools and environments. It also installs completely working django project that uses db (mysql/sqlite3) and apache2

Configuration have been tested with:<br>
OS:xubuntu 18.04. <br>
Computers: Lenovo thinkpad t13, T480, thinkcenter <br>

Project:
Version: 1.0b <br>
status: Everything working expect google module <br>

Last update:
Date: 19.11.2018 <br>

## how to use:

### Before! Learn to use salt-master/minion....

### Step 1:

>sudo mkdir /srv
>sudo git clone repo /srv/ 

### Step 2: Conf settings && choose mods

### Settings for this installation are located in /srv/pillar folder.
- mysql.sls -> Set password to mysql
- server.sls -> If installing to server distro like ubuntu server 18.04 set to True. Skips some mods.
- Django project -> Here you can set your project User, Django folder name, Django project name, Django venv, use mysql or sqlite3
- Node.js -> if you want different version of nodejs. defualt is 10.x which is the LTS

### Now conf your /srv/salt/top.sls file to install what you want:
Note! Some mods are just depencys. Meaning that you can install any mods but some mods install other because of depency.

Example:
- Nodejs -> Installs curl
- djangoserver -> apache2,venv,pip, mysql(if True(Pillar))

Depencys are marked on the init.sls file -> include -mysql.sls

### Step 3:
relax and highstate
> sudo salt '*' state.highstate

### Testing:
 shell command = s:
 nodejs -> s: nodejs --version = 10. something
 django -> browser to your localhost -> front page should be django
 mysql -> s: mysql -u root -p 
 venv -> s: python3 -m venv yourproject
 pip -> s: pip freeze


 ## Issues:

- Can't install mysql to Try xubuntu state

## Still coming(maybe): 
 -Shell script to install this automaticly....

## NOTE!

- Full support only for Xubuntu 18.04

- I havent included React. To install react project install npm module and use command: npx create-react-app my-app

- Django module is perfectly working but may still change.

- google mod && ssh-server mod not complitely configured....

## Sources: This mod uses Tero karvisen mysql configuration with some changes 
Source:  http://terokarvinen.com/2015/preseed-mysql-server-password-with-salt-stack

