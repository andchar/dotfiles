### directories {{{

setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

### }}}
### env {{{

export EDITOR="nvim"

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
export GREP_COLOR='37;45'
#export GREP_OPTIONS='--color=auto'
export LSCOLORS="exfxcxdxbxegedabagacad"
export PAGER=less
export PATH=$PATH:/usr/local/go/bin
export PATH=$HOME/.linkerd2/bin:$PATH

#source ~/.autojump/etc/profile.d/autojump.zsh
#. /opt/r15b02/activate
#. /opt/r16b/activate

### }}}
### aliases {{{

alias m='mvim'
#alias ls="ls -G"
alias l='ls -1A'         # Lists in one column, hidden files.
alias ll='ls -lh'        # Lists human readable sizes.
alias lr='ll -R'         # Lists human readable sizes, recursively.
alias la='ll -A'         # Lists human readable sizes, hidden files.
alias lm='la | "$PAGER"' # Lists human readable sizes, hidden files through pager.
alias lx='ll -XB'        # Lists sorted by extension (GNU only).
alias lk='ll -Sr'        # Lists sorted by size, largest last.
alias lt='ll -tr'        # Lists sorted by date, most recent last.
alias lc='lt -c'         # Lists sorted by date, most recent last, shows change time.
alias lu='lt -u'         # Lists sorted by date, most recent last, shows access time.
alias sl='ls'            # I often screw this up.
#alias poweroff='sudo poweroff'            # I often screw this up.
#alias reboot='sudo reboot'            # I often screw this up.
alias o='open'
alias get='wget -t0 -c'
alias history-stat="history . | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
alias u="nmcli con up "
alias d="nmcli con down "
alias vmr="ssh 192.168.88.88 vmadm list state=running -o uuid,type,nics.0.ip,alias"
alias vma="ssh 192.168.88.88 vmadm list -o uuid,alias,type,nics.0.ip"
#xbps:
alias xin='sudo xbps-install -S'
alias xup='sudo xbps-install -Syuv'
alias xq='xbps-query'
alias xf='xbps-query -Rs'
alias xme='xbps-query -m'
alias xrm='sudo xbps-remove -R'

alias k=kubectl
# alias k="microk8s kubectl"
alias kc=kubectx
alias kcn=kubens

alias -s tex=vim
alias -s html=vimb
alias -s org=vimb
alias -s pdf=zathura
alias -s exe=wine
alias -s txt=vim -R
#video
alias -s mp4=mpv
alias -s mkv=mpv
alias -s avi=mpv
#localc:
alias -s ods=localc
alias -s xls=localc
alias -s xlsx=localc
alias -s torrent=tremotesf

# p() { passy "$*" | pbcopy; }

# Make fileutils verbose
for c in cp rm chmod chown rename; do
    alias $c="$c -v"
done

### }}}
### completion {{{

# Load and initialize the completion system ignoring insecure directories.
autoload -Uz compinit && compinit -i
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
setopt PATH_DIRS           # Perform path search even on command names with slashes.
setopt AUTO_MENU           # Show completion menu on a succesive tab press.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE     # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL      # Disable start/stop characters in shell editor.

# Treat these characters as part of a word.
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
# Use caching to make completion for cammands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
if zstyle -t ':prezto:module:completion:*' case-sensitive; then
  zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  setopt CASE_GLOB
else
  zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
  unsetopt CASE_GLOB
fi


# aws autocomplete
autoload bashcompinit && bashcompinit
complete -C 'aws_completer' aws

#. <(kubectl completion zsh)
#. <(minikube completion zsh)
#. <(minishift completion zsh)
#. <(oc completion zsh)
#. <(crc completion zsh)
#. <(helm completion zsh)
#. <(linkerd completion zsh)
#. <(tkn completion zsh)

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (помилки: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- не знайдено --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,comm -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single
# }}}
### prompt {{{
autoload -U colors
colors

function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

# Load and execute the prompt theming system.
autoload -Uz promptinit && promptinit
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{28}+'
zstyle ':vcs_info:*' unstagedstr '%F{11}-'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn
precmd () {
    if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
        zstyle ':vcs_info:*' formats '[%F{green}%b%c%u%F{blue}]'
    } else {
        zstyle ':vcs_info:*' formats '[%F{green}%b%c%u%F{red}*%F{blue}]'
    }

    vcs_info
}

setopt prompt_subst
#PROMPT=' %F{green}$(collapse_pwd)${vcs_info_msg_0_} %{$reset_color%}λ % '
#PROMPT=' %F{green}$(collapse_pwd)${vcs_info_msg_0_} %F{blue}λ %F{green}% '
PROMPT='%F{white}%F{white}%n${vcs_info_msg_0_}%F{214}@%F{167}%m%F{white}: %'

### }}}
### history {{{

HISTFILE="$HOME/.zhistory"
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history f
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

### }}}
### moar commandline & keybindings {{{

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -e
bindkey '^[[Z' reverse-menu-complete
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search

bindkey "\e[3~" delete-char
### }}}

### vi-like keys {{{
#bindkey -v
### }}}

### prompt {{{
  autoload -Uz promptinit
  promptinit
  #prompt adam1 16 124 60
### }}}
### {{{ colorification
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
        'alias'           'fg=153,bold'
        'builtin'         'fg=153'
        'function'        'fg=166'
        'command'         'fg=153'
        'precommand'      'fg=153, underline'
        'hashed-commands' 'fg=153'
        'path'            'underline'
        'globbing'        'fg=166'
)
### }}} colorification

case `uname` in
  Linux)
    ###comletion linux
    #source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source ~/.zsh_completion/*
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  ;;
  OpenBSD)
    ###comletion OpenBSD
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source /usr/local/share/zsh/kubectl.zsh
    source /usr/local/share/zsh/vendor-completions/_google-cloud-sdk
  ;;
esac

PATH="/home/acharnosh/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/acharnosh/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/acharnosh/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/acharnosh/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/acharnosh/perl5"; export PERL_MM_OPT;
# OPS config
#export OPS_DIR="$HOME/.ops"
#export PATH="$HOME/.ops/bin:$PATH"
#source "$HOME/.ops/scripts/bash_completion.sh"#

function jwt() {
  for part in 1 2; do
    b64="$(cut -f$part -d. <<< "$1" | tr '_-' '/+')"
    len=${#b64}
    n=$((len % 4))
    if [[ 2 -eq n ]]; then
      b64="${b64}=="
    elif [[ 3 -eq n ]]; then
      b64="${b64}="
    fi
    d="$(openssl enc -base64 -d -A <<< "$b64")"
    python -mjson.tool <<< "$d"
    # don't decode further if this is an encrypted JWT (JWE)
    if [[ 1 -eq part ]] && grep '"enc":' <<< "$d" >/dev/null ; then
        exit 0
    fi
  done
}

source /home/${USER}/.config/broot/launcher/bash/br

# >>>> Vagrant command completion (start)
fpath=(/usr/lib/vagrant/gems/vagrant-2.3.6/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)

# Directories bookmars with 'z' or 'zi' commands (zoxide package)
eval "$(zoxide init zsh)"

function copy_cmd_to_clipboard() {
  print -rn -- "$BUFFER" | xclip -selection clipboard
  zle -M "Command copied to clipboard"
}

zle -N copy_cmd_to_clipboard

# shortcut to copy the command to clipboard
bindkey '^G' copy_cmd_to_clipboard
