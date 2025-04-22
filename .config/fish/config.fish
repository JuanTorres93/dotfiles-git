if status is-interactive
  # Commands to run in interactive sessions can go here

  # Change accept suggestion to Ctrl + L
  bind \cl accept-autosuggestion

  ## Terminal prompt accent (Fish usa `fish_prompt` en lugar de `PS1`)
  function fish_prompt
      # Definir colores
      set_color -o magenta
      echo -n "$(whoami)"  # Usuario
      set_color -o normal
      echo -n "@"  # Separador
      set_color -o magenta
      echo -n (hostname | cut -d'.' -f1)  # Nombre del host (sin dominio)
      set_color normal
      echo -n " "
      set_color cyan
      echo -n "$(basename (pwd))"  # Carpeta actual
      #echo -n "$(basename $(pwd))"  # Carpeta actual
      set_color normal
      echo -n " "  
      set_color magenta
      echo -n "⮞ "  # Símbolo de prompt estilizado
      set_color normal
  end
  # Agregar ~/.bin al PATH si existe
  if test -d "$HOME/.bin"
      set -x PATH $HOME/.bin $PATH
  end
  
  # Ejecutar Neofetch al abrir la terminal
  neofetch
  
  # Activar modo vi (Fish lo maneja con `fish_vi_key_bindings`)
  # No se activa por defecto porque Fish usa sus propias combinaciones
  # fish_vi_key_bindings
  
  # ----- ALIASES -----
  # Cambiar programas
  alias ls="exa --color=auto"
  alias ll="exa -lgh --color=auto"
  alias la="exa -la --color=auto"
  
  # Agregando flags
  # alias ls="ls --color=auto"
  # alias ll="ls -lh --color=auto"
  # alias la="ls -lhA --color=auto"
  
  alias diff="diff --color=auto"
  alias ..="cd .."
  alias lns="ln -srfi"
  alias mv="mv -i"
  alias cp="cp -i"
  
  alias grep="grep --color=auto"
  alias df="df -h"
  
  alias yta="yt-dlp -ic --extract-audio --audio-format mp3"
  alias yt="yt-dlp -ic"
  
  alias subdl="subdl --existing=overwrite"
  alias subdl-name="subdl --existing=overwrite --force-filename"
  
  # Aliases útiles
  alias d="docker"
  alias dc="docker-compose"
  alias k="kubectl"
  alias update="sudo pacman -Syu; xmonad --recompile; yay -S --needed visual-studio-code-bin"
  
  # alias run_bot="cd ~/hdd/python_projects/trading-bot/ && source venv/bin/activate && cd src/ && python run_bot.py"
  function botcheck
      while true
          sleep 60
          botdbcli
          echo ""
          echo ""
      end
  end
  
  # Obtener los mirrors más rápidos
  alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
  alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
  alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
  alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"
  
  alias heaviestDirs="du -ah | sort -hr | head -n 20"
  
  # Limpiar paquetes huérfanos
  alias cleanup="sudo pacman -Rns (pacman -Qtdq)"
  
  alias listServices="systemctl list-units --type=service"
  
  # Shenanigans
  alias tiempo="curl wttr.in"
  alias listfonts="fc-list"
end
