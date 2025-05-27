#!/bin/bash

# Diretórios
ADS_DIR="/home/iftm/ADS"
BACKUP_DIR="/home/iftm/backup"
LOG_DIR="/home/iftm/log"
LOG_FILE="/home/iftm/log/Log.txt"

# Verificar se a pasta ADS existe, se não, criar
if [ ! -d "$ADS_DIR" ]; then
    mkdir "$ADS_DIR"
    echo "Pasta $ADS_DIR criada."
fi

# Verificar se a pasta backup existe, se não, criar
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir "$BACKUP_DIR"
    echo "Pasta $BACKUP_DIR criada."
fi

if [ ! -d "$LOG_DIR" ]; then
    mkdir "$LOG_DIR"
    echo "Pasta $LOG_DIR criada."
fi    


# Fazer o backup das imagens na pasta ADS
for imagem in "$ADS_DIR"/*; do
    # Verificar se é um arquivo
    if [ -f "$imagem" ]; then
        # Extrair o nome do arquivo e a extensão
        filename=$(basename -- "$imagem")
        extension="${filename##*.}"
        name="${filename%.*}"

        # Obter a data e hora atual
        current_date=$(date +"%Y_%m_%d_%H_%M")

        # Criar o novo nome para o arquivo
        backup_name="${name}_${current_date}.${extension}"

        # Copiar para a pasta de backup com o novo nome
        cp "$imagem" "$BACKUP_DIR/$backup_name"
        
        
        echo "Backup realizado na data $current_date $filename." >> "$LOG_FILE"
    fi
done
echo "Realizando Backup"
sleep 3
echo "Um Backup de CRIA foi realizado com success!"