# [START docker]
FROM gcr.io/google_appengine/python
RUN apt-get clean all
RUN apt-get update
RUN apt-get -y dist-upgrade
RUN apt-get install -y git

#ADD RSA Files for bitbucket access
RUN mkdir ~/.ssh
RUN chmod 777 ~/.ssh/
RUN touch /root/.ssh/config
RUN echo "StrictHostKeyChecking no" >> /root/.ssh/config
echo $id_rsa /root/.ssh/id_rsa
echo $id_rsa_pub /root/.ssh/id_rsa.pub

# Get code
RUN git clone git@github.com:bdmckean/django-k8s-hello.git /var/www/django 

#Install logs dir
RUN mkdir /var/log/django

#Install project virutalenv
RUN virtualenv -p python3 /var/www/django/env
ENV PATH /var/www/django/env/bin:$PATH

RUN pip install --upgrade pip && pip install -r /var/www/django/requirements.txt

ENV NODB 1

#Start server
CMD python /var/www/django/manage.py runserver
