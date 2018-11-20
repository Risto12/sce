#===== Change these values to conf your project ====

#Home(User home directory)
{% set home = "vagrant" %}

#Django project root
{% set django_folder = "django" %}

#Django_project name
{% set django_project = "web" %}

#Django projects virtual environment name
{% set venv_environment = "python_env" %}

#Use mysql instead of mysqlite3
{% set django_mysql = "True" %}

#Djangos database name
{% set dbname = "testing" %}

#=======Don't touch below======

home: {{ home }}
django_folder: {{ django_folder }}
django_home: {{ home }}/{{ django_folder }}
django_project: {{ django_project }}
venv_environment: {{ venv_environment }}
django_mysql: {{ django_mysql }}
dbname: {{ dbname }}
