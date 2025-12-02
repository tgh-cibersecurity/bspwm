cat > install.sh <<'EOF'
#!/usr/bin/env bash

set -e

echo "⚡ Instalando entorno BSPWM..."

------------------------------

    Actualizar sistema

------------------------------
echo "🔄 Actualizando paquetes..."
sudo apt update -y && sudo apt upgrade -y

------------------------------

    Instalar paquetes necesarios

------------------------------
echo "📦 Instalando BSPWM, SXHKD y dependencias..."
sudo apt install -y bspwm sxhkd polybar rofi feh picom neovim zsh git curl wget fonts-firacode

------------------------------

    Copiar configuraciones

------------------------------
echo "📁 Copiando configuraciones..."

mkdir -p ~/.config

BSPWM
mkdir -p ~/.config/bspwm
cp -r config/bspwm/* ~/.config/bspwm/  true
chmod +x ~/.config/bspwm/bspwmrc  true

SXHKD
mkdir -p ~/.config/sxhkd
cp -r config/sxhkd/* ~/.config/sxhkd/  true

Polybar
mkdir -p ~/.config/polybar
cp -r config/polybar/* ~/.config/polybar/  true

Picom
mkdir -p ~/.config/picom
cp -r config/picom/* ~/.config/picom/  true

Rofi
mkdir -p ~/.config/rofi
cp -r config/rofi/* ~/.config/rofi/  true

Neovim
mkdir -p ~/.config/nvim
cp -r config/nvim/* ~/.config/nvim/  true

ZSH
echo "⚙️ Instalando configuración ZSH..."
cp -f .zshrc ~/.zshrc  true

Wallpapers
if [ -d "wallpapers" ]; then
    mkdir -p ~/Pictures/wallpapers
    cp -r wallpapers/* ~/Pictures/wallpapers/  true
fi

------------------------------

    Cambiar shell a ZSH

------------------------------
echo "🐚 Cambiando shell a ZSH..."
chsh -s /usr/bin/zsh  true

------------------------------

    Mensaje final

------------------------------
echo ""
echo "🚀 Instalación completada!"
echo "Reinicia tu sesión para activar BSPWM."
echo ""
