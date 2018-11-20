virtualbox:
  pkg.installed
   
vagrant:
  pkg.installed



send_penetrator:
  file.recurse: 
    - name: /root
    - source: salt://vagrant/penetrator
    - makedirs: True
    
start:
  cmd.script:
   - name: /root/./command.sh
   - mode: 744
   
