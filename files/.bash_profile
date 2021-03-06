# Source bashrc
source "$HOME/.bashrc"

# Joins paths together

################################################################################
# Joins paths together by ":"
# Arguments:
#     $1: Array of paths, e.g. join ARR[@]
# Returns:
#     string
################################################################################
join() { a=("${!1}"); local IFS=":"; echo "${a[*]}"; }

################################################################################
# Deduplicates paths separated by ":"
# Arguments:
#     $1: string of paths separated by ":"
# Returns:
#     string
################################################################################
dedup() { echo -n $1 | awk -v RS=: -v ORS=: '!arr[$0]++'; }

# System paths
SYS_PATHS=(
    "/usr/local/opt/coreutils/libexec/gnubin" # Prefer coreutils
    "/usr/local/opt/gnu-sed/libexec/gnubin" # Custom sed
    "/usr/local/opt/python/libexec/bin" # Python
    "/usr/local/opt/ruby/bin" # Ruby
    "/usr/local/sbin" # Brew scripts
)

# User paths
USER_PATHS=(
    "/usr/local/opt/fzf/bin" # Fzf
    "$HOME/.dotfiles/scripts" # Personal scripts
    "$HOME/.composer/vendor/bin" # Global composer scripts
    "$(/usr/local/opt/ruby/bin/ruby -r rubygems -e 'puts Gem.user_dir')/bin" # Ruby
)

# Set PATH with ordering: SYS:PATH:USER
export PATH=$(dedup "$(join SYS_PATHS[@]):$PATH:$(join USER_PATHS[@])")

# Ensures that SHELL is set to my $PATH bash, especially for tmux
export SHELL=$(which bash)

# Homebrew completions
source $(brew --prefix)/etc/bash_completion

# Fzf completions
source "/usr/local/opt/fzf/shell/completion.bash"

# Fzf key bindings
source "/usr/local/opt/fzf/shell/key-bindings.bash"

# macos now shows a deprecation warning about bash, remove it
export BASH_SILENCE_DEPRECATION_WARNING=1

# Set editor
export EDITOR='nvim'

# Ruby
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# Nord Theme for fzf
export FZF_DEFAULT_OPTS='
--color fg:#D8DEE9,bg:#2E3440,hl:#A3BE8C,fg+:#D8DEE9,bg+:#434C5E,hl+:#A3BE8C
--color pointer:#BF616A,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B
'

export TMUX_1PASSWORD_OP_ITEMS_JQ_FILTER="
  .[]
  | [select(.overview.URLs | map(select(.u)) | length == 1)?]
  | map([ .overview.title, .uuid ]
  | join(\",\"))
  | .[]
"

# rbenv
eval "$(rbenv init -)"

# Fast Node Manager
eval "$(fnm env --multi)"

