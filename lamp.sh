#!/bin/bash

echo "Atualizando o sistema..."
sudo apt update && sudo apt upgrade -y

echo "Instalando Apache..."
sudo apt install apache2 -y

echo "Ativando Apache no boot e iniciando o serviço..."
sudo systemctl enable apache2
sudo systemctl start apache2

echo "Instalando MySQL..."
sudo apt install mysql-server -y

echo "Executando configuração segura do MySQL..."
sudo mysql_secure_installation

echo "Instalando PHP e módulos necessários..."
sudo apt install php libapache2-mod-php php-mysql -y

echo "Reiniciando o Apache para aplicar mudanças..."
sudo systemctl restart apache2

echo "Criando arquivo de teste PHP..."
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php > /dev/null

echo "LAMP instalado com sucesso!"
echo "Abra o navegador e acesse: http://localhost/info.php"
