FROM kalilinux/kali-rolling

# Evitar prompts interactivos durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar herramientas de red y pentesting básico
RUN apt-get update && apt-get install -y \
    nmap \
    hydra \
    aircrack-ng \
    sqlmap \
    metasploit-framework \
    wireshark \
    autopsy \
    sleuthkit \
    john \
    hashcat \
    net-tools \
    curl \
    wget \
    netcat-traditional \
    default-mysql-client \
    git \
    openssh-server \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

# Configurar SSH para que el contenedor se mantenga vivo
RUN mkdir -p /var/run/sshd

# El contenedor se quedará ejecutando el demonio SSH
CMD ["/usr/sbin/sshd", "-D"]