#!/usr/bin/env bash
# Instalador del entorno BSPWM — tgh-cibersecurity
# Compatible con Parrot OS y Kali Linux

# ---------- Colores ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}✔${NC} $1"; }
warn() { echo -e "  ${YELLOW}⚠${NC}  $1"; }
step() { echo -e "\n${CYAN}${BOLD}▶ $1${NC}"; }

clear
echo -e "${MAGENTA}${BOLD}"
cat << "BANNER"
   ████████╗ ██████╗ ██╗  ██╗
   ╚══██╔══╝██╔════╝ ██║  ██║
      ██║   ██║  ███╗███████║
      ██║   ██║   ██║██╔══██║
      ██║   ╚██████╔╝██║  ██║
      ╚═╝    ╚═════╝ ╚═╝  ╚═╝
   BSPWM Environment Installer
BANNER
echo -e "${NC}"
echo -e "${CYAN}Entorno personalizado de tgh-cibersecurity${NC}"
echo -e "${CYAN}Compatible con Parrot OS y Kali Linux${NC}\n"
sleep 1

step "Actualizando paquetes del sistema"
sudo apt update -y && sudo apt upgrade -y

step "Instalando BSPWM, SXHKD y dependencias"
sudo apt install -y \
    bspwm sxhkd polybar rofi feh picom kitty \
    zsh git curl wget unzip \
    fonts-font-awesome fontconfig \
    network-manager || warn "Algunos paquetes no se pudieron instalar, revisa el log de arriba."

step "Copiando configuraciones"
mkdir -p ~/.config

copy_config() {
    local name="$1"
    if [ -d "config/$name" ]; then
        mkdir -p ~/.config/"$name"
        cp -r "config/$name/." ~/.config/"$name/"
        ok "Config de $name copiada"
    else
        warn "No se encontro config/$name, se omite"
    fi
}

copy_config "bspwm"
copy_config "sxhkd"
copy_config "polybar"
copy_config "picom"
copy_config "rofi"
copy_config "kitty"

[ -f ~/.config/bspwm/bspwmrc ] && chmod +x ~/.config/bspwm/bspwmrc
[ -f ~/.config/polybar/launch.sh ] && chmod +x ~/.config/polybar/launch.sh
find ~/.config/polybar/scripts ~/.config/bspwm/scripts -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null

step "Instalando fuentes personalizadas"
if [ -d "config/polybar/fonts" ]; then
    mkdir -p ~/.local/share/fonts
    cp -r config/polybar/fonts/* ~/.local/share/fonts/
    fc-cache -f ~/.local/share/fonts > /dev/null 2>&1
    ok "Fuentes instaladas y cache actualizado"
else
    warn "No se encontro config/polybar/fonts, se omite"
fi

step "Copiando dotfiles"
for f in .bashrc .fzf.bash .fzf.zsh .p10k.zsh .zshrc; do
    if [ -f "$f" ]; then
        cp -f "$f" ~/"$f"
        ok "$f copiado"
    else
        warn "No se encontro $f, se omite"
    fi
done

step "Configurando ZSH (Oh My Zsh + Powerlevel10k)"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || warn "No se pudo instalar Oh My Zsh"
    ok "Oh My Zsh instalado"
else
    ok "Oh My Zsh ya estaba instalado"
fi

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR" > /dev/null 2>&1 || warn "No se pudo clonar Powerlevel10k"
    ok "Powerlevel10k instalado"
else
    ok "Powerlevel10k ya estaba instalado"
fi

step "Copiando wallpapers"
if [ -d "wallpapers" ]; then
    mkdir -p ~/Pictures/wallpapers
    cp -r wallpapers/* ~/Pictures/wallpapers/
    ok "Wallpapers copiados a ~/Pictures/wallpapers/"
else
    warn "No se encontro carpeta wallpapers/, se omite"
fi

step "Neovim"
echo -e "  ${YELLOW}ℹ${NC}  Este repo no incluye la config de Neovim a proposito."
echo -e "  ${YELLOW}ℹ${NC}  Instalala aparte, ej: https://github.com/NvChad/starter"

step "Cambiando shell por defecto a ZSH"
chsh -s "$(command -v zsh)" > /dev/null 2>&1 && ok "Shell cambiado a ZSH" || warn "No se pudo cambiar el shell. Hazlo con: chsh -s \$(which zsh)"

echo -e "\n${GREEN}${BOLD}"
cat << "DONE"
   ┌─────────────────────────────────┐
   │   Instalacion completada! 🚀     │
   └─────────────────────────────────┘
DONE
echo -e "${NC}${CYAN}Cierra sesion y selecciona 'bspwm' en la pantalla de login.${NC}\n"
