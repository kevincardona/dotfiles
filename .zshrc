#          _                                 _   
#  ___ ___| |_    _ _ ___ _ _ ___    ___ ___| |_ 
# |   | . |  _|  | | | . | | |  _|  |- _|_ -|   |
# |_|_|___|_|    |_  |___|___|_|    |___|___|_|_|
#                |___|                           
#	 my zsh
#

source $(brew --prefix)/share/antigen/antigen.zsh
antigen use oh-my-zsh

# -------------------------------------------------------------------
# ZSH Theme
# -------------------------------------------------------------------
antigen theme romkatv/powerlevel10k
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# -------------------------------------------------------------------
# Plugins
# -------------------------------------------------------------------
antigen bundle git
antigen bundle pip
antigen bundle ael-code/zsh-colored-man-pages
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

# -------------------------------------------------------------------
# Library Setup
# -------------------------------------------------------------------

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# FZF
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height 96% --reverse --preview "cat {}"'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# -------------------------------------------------------------------
# Aliases & Functions
# -------------------------------------------------------------------

# Python 2 has got to go
alias python=python3

# Git Aliases
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias 'git co'='git checkout'
alias gra='git remote add'
alias grr='git remote rm'
alias gpu='git pull'

# Tmux Aliases
function ts() {
  eval "~/.tmux_scripts/$1"
}
alias tst='tmux switch -t'

# Other
alias sp="spotify play"
alias spp="spotify pause"
alias spot="spotify"

# -------------------------------------------------------------------
# Local Config
# -------------------------------------------------------------------
if [ -e ~/.zsh.local ]; then
  . ~/.zsh.local
fi

# -------------------------------------------------------------------
# I didn't add this you did
# -------------------------------------------------------------------