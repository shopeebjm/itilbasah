#!/data/data/com.termux/files/usr/bin/bash

# Color definitions
e() { echo -e "$@"; }
m="\033[1;31m"  # Red
h="\033[1;32m"  # Green
k="\033[1;33m"  # Yellow
b="\033[1;34m"  # Blue
bl="\033[1;36m" # Cyan
p="\033[1;37m"  # White
u="\033[1;35m"  # Magenta
c="\033[1;96m"  # Bright Cyan
RESET="\033[0m" # Reset
REQUIRED_PKGS=(neofetch shc ruby wget mpv zsh boxes git curl)
for pkg in "${REQUIRED_PKGS[@]}"; do
  if ! command -v "$pkg" &>/dev/null; then
    e "${b}[📦]${p} Menginstall: $pkg...${RESET}"
    pkg install -y "$pkg" || {
      e "${b}[❌]${m} Gagal install $pkg!${RESET}"
      exit 1
    }
    [[ "$pkg" == "ruby" ]] && gem install lolcat
  else
    e "${b}[✅]${h} $pkg sudah terinstall.${RESET}"
  fi
done
if ! command -v "yt-dlp" &>/dev/null; then
  e "${b}[📦]${p} Menginstall yt-dlp...${RESET}"
  wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O $PREFIX/bin/yt-dlp
  chmod +x $PREFIX/bin/yt-dlp
fi
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  e "${b}[📦]${p} Memasang Oh My Zsh...${RESET}"
  export CHSH=no
  RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
    e "${b}[❌]${m} Gagal install Oh My Zsh!${RESET}"
    exit 1
  }
fi
buat_script_ascii() {
  cat <<EOF > "$delok"
#!/data/data/com.termux/files/usr/bin/bash
clear
mpv "$HOME/THEMEK/sound/hello.mp3" &>/dev/null
neofetch --ascii_distro "$selected"
EOF
}

tanam() {
  delok="sementara.sh"
  buat_script_ascii
  chmod +x "$delok"
  if shc -f "$delok"; then
    rm -f "$PREFIX/bin/watashi"
    mv -f "${delok}.x" "$PREFIX/bin/watashi"
    chmod +x "$PREFIX/bin/watashi"
    e "${b}[✅]${h} Binary 'watashi' disimpan ke $PREFIX/bin/${RESET}"
  else
    e "${b}[❌]${m} Gagal compile!${RESET}"
    exit 1
  fi
  rm -f "$delok" "${delok}.x.c"
}
pasang_prompt() {
  local CONFIG_FILE="$HOME/.zshrc"
  local ZSH_DIR="$HOME/.oh-my-zsh"
  local PLUGIN_DIR="$ZSH_DIR/custom/plugins"
  [[ ! -d "$PLUGIN_DIR/zsh-autosuggestions" ]] &&
    git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGIN_DIR/zsh-autosuggestions"
  [[ ! -d "$PLUGIN_DIR/zsh-syntax-highlighting" ]] &&
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$PLUGIN_DIR/zsh-syntax-highlighting"
    sed -i '/# ascii-menu-start/,/# ascii-menu-end/d' "$CONFIG_FILE"
    cat <<'EOF' >> "$CONFIG_FILE"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
m="%F{red}"; h="%F{green}"; k="%F{yellow}"; b="%F{blue}"; bl="%F{cyan}"
p="%F{white}"; u="%F{magenta}"; pu="%F{black}"; c="%F{brightcyan}"
or="%F{brightred}"; g="%F{brightgreen}"; y="%F{brightyellow}"
bld="%F{brightblue}"; pwl="%F{brightmagenta}"; blg="%F{brightwhite}"; lg="%F{gray}"
bg_m="%K{red}"; bg_h="%K{green}"; bg_k="%K{yellow}"; bg_b="%K{blue}"; bg_bl="%K{cyan}"
bg_p="%K{white}"; bg_u="%K{magenta}"; bg_pu="%K{black}"; bg_c="%K{brightcyan}"
bg_or="%K{brightred}"; bg_g="%K{brightgreen}"; bg_y="%K{brightyellow}"
bg_bld="%K{brightblue}"; bg_pwl="%K{brightmagenta}"; bg_lg="%K{gray}"
RESET="%f%k"; BLINK="%B"
setopt PROMPT_SUBST
parse_git_branch() {
    git rev-parse --is-inside-work-tree &>/dev/null && \
    git symbolic-ref --short HEAD 2>/dev/null | sed 's/.*/🔥 &/'
}

PROMPT='${b}┌⟮ ${h}Root@%m ${b}⟯${k}⮕ ${b}⟮ ${m}%~ ${b}⟯${RESET}${k}⮕ ${b}⟮${bg_lg}${g}$(parse_git_branch)${b}⟯ ${lg}%*'$'\n'"${b}└─► ${RESET}"
# ascii-menu-end
EOF
   mkdir -p "$HOME/.termux"
  cat <<EOP > "$HOME/.termux/termux.properties"
# Termux Properties - Auto Generated
font_size=14
bell-character=ignore
terminal-transcript-opacity=0.95
use-black-ui=true
hide-soft-keyboard-on-startup=true
clipboard-autocopy=true
terminal-margin-vertical=1

# Extra keys
extra-keys = [ \
  ['TAB', 'ESC', '|', '/', '\\', '<', '>', 'HOME', 'PGUP'], \
  ['SHIFT', 'CLEAR\n', '{}', '', '', '[]', '-', 'END', 'PGDN'], \
  ['cd /sdcard\n', '$', '=', '&', '', '~', 'UP', 'DEL', 'BKSP'], \
  ['CTRL', 'ALT', 'QUOTE', 'TOOLSV5\n', '', 'LEFT', 'DOWN', 'RIGHT', 'ENTER']]
EOP
  termux-reload-settings
  e "${b}[✅]${h} Konfigurasi prompt & termux.properties selesai!${RESET}"
}
DISTROS=$(neofetch --help | awk '/--ascii_distro/,/have ascii logos/' | grep -Eo '[A-Za-z0-9_+-]+' | sort -u)
DISTRO_LIST=($DISTROS)
TOTAL=${#DISTRO_LIST[@]}
print_menu() {
  clear
  e "${m}
████████╗██╗  ██╗███████╗███╗   ███╗
╚══██╔══╝██║  ██║██╔════╝████╗ ████║
   ██║   ███████║█████╗  ██╔████╔██║
   ██║   ██╔══██║██╔══╝  ██║╚██╔╝██║
   ██║   ██║  ██║███████╗██║██║ ╚████║
   ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═══╝
${u}[${m}TEMA${p} TERMUX${b} BY${h} GALIRUS OFFICIAL${u}]${RESET}" | boxes -d ansi-rounded | lolcat
  e
  local cols=3
  local rows=$(( (TOTAL + cols - 1) / cols ))
  local title="PILIH ASCII DISTRO"
  local total_width=$(( cols * 18 ))
  local centered_title=$(printf "%*s" $(( (${#title} + total_width) / 2 )) "$title")
  local menu_output="$centered_title\n\n"

  for ((i=0; i<rows; i++)); do
    line=""
    for ((j=0; j<cols; j++)); do
      idx=$(( i + j * rows ))
      if (( idx < TOTAL )); then
        num=$((idx + 1))
        name="${DISTRO_LIST[$idx]}"
        line+="$(printf "%-3s %-15s" "$num." "$name")"
      fi
    done
    menu_output+="$line\n"
  done

  e "$menu_output" | boxes -d ansi-rounded
}
while true; do
  print_menu
  echo "Masukkan nomor distro (q untuk keluar): "
  read input
  [[ "$input" == "q" ]] && exit 0

  if [[ "$input" =~ ^[0-9]+$ ]] && (( input >= 1 && input <= TOTAL )); then
    selected="${DISTRO_LIST[$((input - 1))]}"
    e "${b}[ℹ️ ]${p} Menampilkan: $selected${RESET}\n"
    neofetch --ascii_distro "$selected"

    echo "Setel sebagai default di Termux? (y/n): "
    read confirm
    if [[ "$confirm" =~ ^[yY]$ ]]; then
      tanam
      clear
      print_menu
      pasang_prompt
      termux-reload-settings
      e "${b}[✅]${h} Konfigurasi selesai. Restart Termux untuk melihat hasilnya!${RESET}"
    fi
    echo "Tekan Enter untuk kembali ke menu..."
    read
  else
    e "${b}[❌]${m} Input tidak valid!${RESET}"
    sleep 2
  fi
done