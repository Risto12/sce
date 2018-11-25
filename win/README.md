## Kotitehtävät linux palvelimet H5 Salt-windows....

# A)Asennetaan salt master slave arkkitehtuuri xubuntu18.04 ja windows10 välille.
kaikki komennot annetaan xubuntulle, poislukien salt-minion asentamista windowsille.<br>
<br>
Ensiksi tarkistetaan salt-masterin versio(Xubuntu), koska masterilla pitää olla sama tai
uudempi versio, kun minionilla.

> salt-master --version
> bash: salt-master 2017.7.4 Nitrogen 


Nyt täytyy windowsille asennetaan sama versio windowsille.<br>
Saltin repo https://repo.saltstack.com/windows/<br>
Otetaan 2017.7.4 python 3 x86 ja asennetaan.<br>
<br>
Kun ohjelma on asennettu katsotaan avaimet. Windowsille annettiin id:ksi (winsla)<br>

> sudo salt-key -A
> bash: winsla

Hyväksytään avain ja tehdään testikomento<br>

> sudo salt 'winsla' cmd.run 'dir' 

Vastaus:<br>
Volume in drive C has no label. <br> 
     Volume Serial Number is A23A-FFEF <br>

jatkuu ....<br>

Nyt säädetään salt-masteria Tero Karvisen http://terokarvinen.com/2018/control-windows-with-salt ohjeiden mukaisesti, jotta windowsille olisi helpompi asentaa paketteja. 

Seuraavassa tehdään kansio /srv/salt/windows/ ja annetaan sille oikeudet:

>sudo mkdir -p /srv/salt/win 
>sudo chown root.salt /srv/salt/win 
>sudo chmod ug+rwx /srv/salt/win 

Päivitetään repot :
> sudo salt-run winrepo.update_git_repos 

Tarkistetaan onnistuminen:
> sudo salt -G 'os:windows' pkg.refresh_db

Odotettu lopputulos on:<br>
failed:0, success:260, total: 260<br>

Asennetaan vlc:
> sudo salt 'winsla' pkg.install vlc

Testataan windowsissa vielä, että vlc toimii. OK.

## B) Käytetää salt-call --local windowsilla.

Jatketaan jo aiemmin mainituilla Tero Karvisen ohjeilla ja asennetaan gimp windowsille ilman linuxia. 

Etsitään windowsista search toiminnolla powershell ja käynnistetään se run as administrator. Nyt annetaan komentokehotteeseen seuraava käsky:<br>

>salt.call.bat --local pkg.install gimp

Tuloksena on muutama virheilmoitus, että win_update moduuli tulee poistumaan käytöstä, kun Salt fluorine julkaistaan. Käytä mielummin win_wua moduulia. Tämä viesti ei kuitenkaan haittaa asennusta nyt, joten powershell ilmoitti, että gimp: new: 2.10.4 = eli gimp on asennettu. Tarkistetaan asia vielä käynistämällä gimp, eli käytetään taas search toimintoa ja kirjoitetaan gimp. Käynnistys ja tarkistus. OK!

## Muutetaan windowsin asennuksia saltilla.

Luodaan kansio back -> /srv/salt/back ja lisätään se top.sls tiedostoon. Tehty edellisissä tehtävissä. <br>
back kansioon luodaan init.sls tiedosto seuraavilla configuroinneilla:
>send_background_image:
>  file.managed: 
>    - name: C:\\Windows\Web\Screen\
>    - source: salt://back/new.jpg 

nyt haetaan kuva, joka halutaan lähettää ja laitetaan se samaan kansioon nimellä new.jpg.<br>
Juoksutetaan sudo salt 'winsla' state.highstate ja salt kertoi, että tiedoston siirtäminen onnistui. <br>

Tarkistetaan windowsista, että new.jpg tiedosto on tullut samaan kansioon missä muut windowsin taustakuvat on. Sen jälkeen mennään muuttamaan windowsin taustaa käyttämällä search toiminta ja kirjoittamalla background image settings. Ja kappas window ilmoittaa, että taustakuvia ei voi muuttaa en, kun on aktivoinut windowsin... GG windows, mutta uskotaan, että muutos on onnistunut ja taustakuvaa voisi vaihtaa...

