include:
  - curl

curl -sL https://deb.nodesource.com/setup_{{ pillar.get('nodever','10.x') }} | sudo bash -:
  cmd.run:
    - require: 
       - sls: curl

nodejs:
  pkg.installed
  
