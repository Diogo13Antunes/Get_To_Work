ZSH_THEME_GIT_PROMPT_PREFIX="[ "
ZSH_THEME_GIT_PROMPT_SUFFIX=" ]"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

function git_prompt_info() {
    local ref
    ref=$(git symbolic-ref --quiet HEAD 2> /dev/null) || return
    echo "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref#refs/heads/}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

function set_prompt() {
    local venv_indicator=''
    if [[ -n $VIRTUAL_ENV ]]; then
        venv_indicator='%{$fg[white]%}(venv)%{$reset_color%} '
    fi

    # Inicia o prompt
    PROMPT=""

    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
        local git_status="$(git status 2> /dev/null)"

        # Configura a cor de fundo com base no status do Git
        if [[ "$git_status" =~ "Changes not staged for commit" ]]; then
            PROMPT='%B%{$BG[001]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'  # Vermelho
        elif [[ "$git_status" =~ "Changes to be committed" ]]; then
            PROMPT='%B%{$BG[172]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'  # Laranja
        elif [[ "$git_status" =~ "nothing to commit" ]]; then
            PROMPT='%B%{$BG[002]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'  # Verde
        else
            PROMPT='%B%{$BG[001]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'  # Vermelho
        fi

        local git_tracking_branch=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
        if [[ -n "$git_tracking_branch" ]]; then
            local local_commit=$(git rev-parse @)
            local remote_commit=$(git rev-parse "$git_tracking_branch")
            local base_commit=$(git merge-base @ "$git_tracking_branch")
            if [[ "$local_commit" != "$remote_commit" ]]; then
                PROMPT='%B%{$BG[003]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'  # Azul (mudança necessária)
            fi
        fi
		PROMPT+='
'
    fi

    PROMPT+="${venv_indicator}%{$FG[006]%}%1/%{$reset_color%} ➙  %b"
}

RPROMPT='%B%{$FG[011]%}[%D{%H:%M:%S}]%{$reset_color%}%b'

# Set prompt on startup
set_prompt

# Update prompt before each command is executed
precmd() {
    set_prompt
}

function zle-line-init zle-keymap-select {
    case $KEYMAP in
        (main|viins|visual|vicmd)
            set_prompt
    esac
}

typeset -agUz preexec_functions
preexec_functions+='set_prompt'
