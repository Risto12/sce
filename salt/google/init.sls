Download_google_chrome:
  cmd.run:
    - name: wget -P {{ pillar["home"] }} https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && dpkg -i {{ pillar["home"] }}/google-chrome-stable_current_amd64.deb


rm {{ pillar["home"] }}/google-chrome-stable_current_amd64.deb:
  cmd.run

