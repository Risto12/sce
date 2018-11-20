# Tee koneestasi salt-slave

A)
 >#!/bin/bash

>apt-get update -qq

>apt-get install salt-minion -y 

>echo -e "master: 192.168.1.112\nid: testing"|tee /etc/salt/minion

>systemctl restart salt-minion.service

C) 

Asennetaan centos 7

>vagrant init centos/7
>vagrant up
>vagrant ssh

#Bonus) Suuri määrä orjia.

##2000 lähdettiin tavoittelemaan, mutta 100 jäätiin...

101 slaven kohdalla muistia oli käytetty jo noin ~180g. Myöskään 10 slavea ei voinut pitää samanaikaisesti päällä, muuten kone alkoi jähmettymään. Joten 10 hyväksynnän välein jouduttiin antamaan koneille shutdown komento. 

Koodi miten virtuaalikoneet asennettiin.

oikea kone loi valmiista kansiosta missä oli Vagrant kuvake(xubuntu 18.04) 50 kopiota:
>#!/bin/bash
>
>for i in {1..50}
>do
>   v=test$i
>   cp -r test $v
>   ( cd $v ; vagrant up )
>done

Näitä koodeja laitetiin 4 eri terminaaliin samanaikaisesti.

Vagrantfile oli lisätty seuraava koodinpätkä:

>config.vm.provision "shell",run:"always",inline: <<-SHELL
>    sudo apt-get update -q
>    sudo apt install -yq salt-minion
>    echo -e "master: 192.168.1.112\nid: $RANDOM%Y"|sudo tee /etc/salt/minion
>    sudo systemctl restart salt-minion

Eli jokainen virtuaalikone ottaa yhteyttä emokoneeseen uniikilla id:llä.

Yhden koneen asentamisessa meni noin 1-2minuuttia, joten tätä piti tehostaa idealla, että
minionin otettua yhteyttä masteriin lähettäisi master saman for i in {1..50} koodin minionille ja tämä alkaisi myös tekemään uusia virtuaalikoneita. Päänsärystä johtuen idea jäi kesken.




