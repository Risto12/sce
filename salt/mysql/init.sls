#!pyobjects

#Pkg.installed("mysql-client")

value = __salt__['pillar.get']('mysqlpass', 'salainen')



Pkg.installed("debconf-utils")
with Debconf.set("mysqlroot", data=
 {
 'mysql-server/root_password':{'type':'password', 'value':value},
 'mysql-server/root_password_again': {'type':'password', 'value':value}
 }):
 Pkg.installed("mysql-server")
 
 #Support for django mysqlclient package
 Pkg.installed("libmysqlclient-dev")
