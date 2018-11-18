{% if pillar["server"] == False %}

Download_google:
  cmd.run:
    - name: wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb|dpkg -i google-chrome-stable_current_amd64.deb|rm google-chrome-stable_current_amd64.deb 
 

{% else %}

Do_nothing:
 cmd.run:
  - name: echo "comment='Pillar -> Server -> True. Google not installed'"
  - stateful: True

   
{% endif %}


