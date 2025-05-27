#!/bin/bash

echo "Atualizando pacotes..."
sudo apt update

echo "Instalando OpenSSH Server..."
sudo apt install -y openssh-server

echo "Verificando status do SSH..."
sudo systemctl status ssh --no-pager

echo "Usu�rio atual: $(whoami)"
echo "Endere�o IP:"
ip a

echo "Instalando ProFTPD (Servidor FTP)..."
sudo apt install -y proftpd

echo "Abrindo configura��o do ProFTPD para edi��o..."
sudo nano /etc/proftpd/proftpd.conf

echo "Reiniciando o servi�o do ProFTPD..."
sudo systemctl restart proftpd

echo "Verificando status do ProFTPD..."
sudo systemctl status proftpd --no-pager

echo "Instalando UFW (Firewall)..."
sudo apt install -y ufw

echo "Habilitando a porta 21 no firewall..."
sudo ufw allow 21
sudo ufw reload
sudo ufw status

echo "Instalando cliente FTP..."
sudo apt install -y ftp

echo "Testando conex�o local com o servidor FTP..."
ftp -n localhost <<EOF
quit
EOF

echo "Servidor FTP instalado e configurado com sucesso!"
echo ""
echo "Para acessar o servidor via navegador ou FileZilla, use:"
echo "ftp://<seu-IP-local> ou ftp://$(hostname -I | awk '{print $1}')"