# Haaga-Helia Palvelinten hallinta ict4tn022 - Mini project

## this saltstack project will install my favorite software development tools and environments. It also installs completely working django project that uses db (mysql/sqlite3) and apache2

Configuration have been tested with xubuntu 18.04. <br>
Computers used in testing: Lenovo thinkpad t13, T480, thinkcenter <br>
Version: 1.0b <br>
status: Everything working expect google module <br>
Date: 19.11.2018 <br>

## how to use:

### Before! Learn to use salt-master/minion....

### Step 1:

>sudo mkdir /srv
>sudo git clone repo /srv/ 

### Step 2: 

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


## Issues:





- I havent included npm -g i create-react-app. I think its better to use command npx create-react-app my-app which comes with npm 5.2+. 

##
- BUGS:
  - With lenovo thinkcentre mysql won't install
