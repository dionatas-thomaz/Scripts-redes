#!/bin/bash

echo "Instalando vsftpd..."
sudo apt update && sudo apt install vsftpd -y

echo "Habilitando e iniciando o serviço FTP..."
sudo systemctl enable vsftpd
sudo systemctl start vsftpd

echo "Criando backup da configuração original..."
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bkp

echo "Configurando vsftpd..."
sudo bash -c 'cat > /etc/vsftpd.conf' << EOF
listen=YES
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
pasv_min_port=10000
pasv_max_port=10100
EOF

echo "Reiniciando vsftpd..."
sudo systemctl restart vsftpd

echo "Criando usuário FTP..."
sudo adduser ftpuser
sudo usermod -d /var/www/html ftpuser
sudo chown ftpuser:ftpuser /var/www/html

echo "Configuração do FTP concluída!"
echo "Conecte via FTP usando: ftpuser@<IP_DO_SERVIDOR>"
