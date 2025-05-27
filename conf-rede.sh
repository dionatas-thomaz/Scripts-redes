#!/bin/bash

# Requer permissões de superusuário
if [[ $EUID -ne 0 ]]; then
   echo "Este script deve ser executado como root." 
   exit 1
fi

# Detectar interface de rede principal (excluindo lo e virtual)
IFACE=$(ip -o link show | awk -F': ' '{print $2}' | grep -v 'lo' | head -n1)

# Verificar se NetworkManager está disponível
if ! command -v nmcli &> /dev/null; then
    echo "Erro: NetworkManager (nmcli) não está instalado."
    exit 1
fi

# Solicitar tipo de configuração
echo "Interface detectada: $IFACE"
echo "Você deseja configurar IP [1] Estático ou [2] DHCP?"
read -rp "Escolha (1/2): " CONFIG_TYPE

# Nome da conexão
CONN_NAME="config_script_$IFACE"

# Remover configuração anterior
nmcli connection delete "$CONN_NAME" 2>/dev/null

if [ "$CONFIG_TYPE" == "1" ]; then
    # Coletar dados do usuário
    read -rp "Endereço IP (ex: 192.168.1.100/24): " IPADDR
    read -rp "Gateway (ex: 192.168.1.1): " GATEWAY
    read -rp "DNS (ex: 8.8.8.8): " DNS

    # Criar conexão estática
    nmcli connection add type ethernet ifname "$IFACE" con-name "$CONN_NAME" \
        ipv4.method manual ipv4.addresses "$IPADDR" ipv4.gateway "$GATEWAY" \
        ipv4.dns "$DNS" autoconnect yes

    echo "Conexão estática criada com sucesso."

elif [ "$CONFIG_TYPE" == "2" ]; then
    # Criar conexão DHCP
    nmcli connection add type ethernet ifname "$IFACE" con-name "$CONN_NAME" \
        ipv4.method auto autoconnect yes

    echo "Conexão DHCP criada com sucesso."
else
    echo "Opção inválida."
    exit 1
fi

# Ativar nova conexão
nmcli connection up "$CONN_NAME"

# Mostrar configurações
echo -e "\n✅ Configuração aplicada. Informações da interface $IFACE:"
ip addr show "$IFACE"
ip route
cat /etc/resolv.conf
