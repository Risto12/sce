apache2:
  pkg.installed

/etc/apache2/sites-available/salt.conf:
  file.managed:
   - source: salt://apache2/salt.conf
   - template: jinja

/home/{{ pillar["home"] }}/www:
  file.directory:
    - user: {{ pillar["home"] }}
    - group: {{ pillar["home"] }}
    - mode: 755


/home/{{ pillar["home"] }}/www/index.html:
  file.managed:
    - source: salt://apache2/index.html

{% for file in ["default-ssl.conf","000-default.conf"] %}

disable_{{ file }}:
  apache_site.disabled:
    - name: {{ file }}
    
{% endfor %}

enable salt.conf:
  apache_site.enabled:
    - name: salt.conf
    - watch: 
       - file: /etc/apache2/sites-available/salt.conf

   
restartif:
  service.running:
    - name: apache2
    - enable: True
    - reload: True
    - watch:
      - file: /etc/apache2/sites-available/salt.conf
      







 
