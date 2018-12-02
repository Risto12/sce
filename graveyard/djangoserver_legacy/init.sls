#Before using. Make configurations to /srv/pillar/ django.sls

{% set user = pillar["home"] %}
{% set env = pillar["venv_environment"] %}
{% set django_folder = pillar["django_folder"] %}
{% set django_project = pillar["django_project"] %}
{% set django_home = pillar["django_home"] %}


include:
  - venv
  - apache2
{% if pillar["django_mysql"] %}   
  - mysql
{% endif %}



python3 -m venv /home/{{ user }}/{{ django_folder }}/{{ env }}:
  cmd.run:
    - makedirs: True
    - user: {{ user }}
    - group: {{ user }}
    - mode: 744
    - recurse:
       - user
       - group
    - require:
      -  sls: venv 

/home/{{ user }}/{{ django_folder }}/salt_agent.py:
  file.managed:
    - source: salt://djangoserver_legacy/salt_agent
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 744
    - context:
       user: {{ user }}
       env: {{ env }}
       django: {{ django_folder }}
       project: {{ django_project }}
       stage: 1

{% if pillar["django_mysql"] %}

install_mysql:
  require:
    - sls: mysql

{% endif %}

active_agent:
  cmd.run:
    - name: /home/{{ user }}/{{ django_folder }}/salt_agent.py
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}
    - cwd: /
    - stateful: True
   

libapache2-mod-wsgi-py3:
  pkg.installed:
    - require:
      - sls: apache2
    
django-configuration-file:
  file.managed:
   - name: /etc/apache2/sites-available/django.conf
   - source: salt://djangoserver_legacy/django 
   - template: jinja
   - context:
      user: {{ user }}
      env: {{ env }}
      root: {{ django_home }}
      project: {{ django_project }}

django-settings-file:
  file.managed:
   - name: /home/{{ user }}/{{ django_folder }}/{{ django_project }}/settings.py
   - source: salt://djangoserver_legacy/settings
   - mode: 644
   - template: jinja
   - user: {{ user }}
   - group: {{ user }}
   - replace: True

disable salt.conf:
  apache_site.disabled:
    - name: salt.conf

enable django.conf:
  apache_site.enabled:
    - name: django.conf

restart_apache2:
  service.running:
    - name: apache2
    - enable: True
    - reload: True
    - watch:
      - file: /etc/apache2/sites-available/django.conf

sets_salt_agent_to_stage_2:
  file.managed:
    - name: /home/{{ user }}/{{ django_folder }}/salt_agent.py
    - source: salt://djangoserver_legacy/salt_agent
    - template: jinja
    - user: {{ user }}
    - group: {{ user }}
    - mode: 744
    - context:
       user: {{ user }}
       env: {{ env }}
       django: {{ django_folder }}
       project: {{ django_project }}
       stage: 2

active_agent_stage_2:
  cmd.run:
    - name: /home/{{ user }}/{{ django_folder }}/salt_agent.py
    - mode: 744
    - user: {{ user }}
    - group: {{ user }}
    - cwd: /
    - stateful: True
   

