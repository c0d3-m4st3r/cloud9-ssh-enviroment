FROM ubuntu
#Establecemos la zona horaria
ENV DEBIAN_FRONTEND="noninteractive" TZ="Europe/Madrid"

#Creamos el usuario cloud9
RUN adduser --disabled-password --gecos '' cloud9

#Actualizamos e instalamos dependencias necesarias
RUN apt-get update -yq  && apt upgrade -yq \
    && apt-get -yq install curl gnupg ca-certificates \
    && curl -L https://deb.nodesource.com/setup_12.x | bash \
    && apt-get update -yq \
    && apt-get install -yq \
        python3 \
        python2 \
        openssh-server \
        build-essential \
        locales-all \
        nodejs 

#Configuramos e iniciamos servidor ssh y descargamos cloud9 desde amazon
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && mkdir /home/cloud9/.ssh \
    && echo '' > /home/cloud9/.ssh/authorized_keys \
    && chmod u=rwx,g=rx,o=rx /home/cloud9 

EXPOSE 22/tcp

RUN echo '#!/bin/bash\nservice ssh start\n/bin/bash' > /home/cloud9/start.sh
RUN chmod +x /home/cloud9/start.sh
ENTRYPOINT ["/bin/sh", "-c", "./home/cloud9/start.sh"]
