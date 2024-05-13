ZSH_THEME_GIT_PROMPT_PREFIX="[ "
ZSH_THEME_GIT_PROMPT_SUFFIX=" ]"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

function set_prompt() {
	local venv_indicator=''
	if [[ -n $VIRTUAL_ENV ]]; then
		venv_indicator='%{$fg[white]%}(venv)%{$reset_color%} '
	fi
	
	PROMPT=""

	if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
		local git_status="$(git status 2> /dev/null)"
		if [[ "$git_status" =~ "Changes not staged for commit" ]]; then
			PROMPT='%B%{$BG[001]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
		elif [[ "$git_status" =~ "Changes to be committed" ]]; then
			PROMPT='%B%{$BG[172]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
		elif [[ "$git_status" =~ "nothing to commit" ]]; then
			local git_branch=$(git symbolic-ref --short -q HEAD)
			local git_tracking_branch=$(git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD))
			if [[ -n "$git_tracking_branch" ]]; then
				local local_commit=$(git rev-parse @)
				local remote_commit=$(git rev-parse "$git_tracking_branch")
				local base_commit=$(git merge-base @ "$git_tracking_branch")
				if [[ "$local_commit" == "$remote_commit" ]]; then
					PROMPT='%B%{$BG[002]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
				elif [[ "$local_commit" == "$base_commit" ]]; then
					PROMPT='%B%{$BG[003]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
				else
					PROMPT='%B%{$BG[172]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
				fi
			else
				PROMPT='%B%{$BG[172]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
			fi
		else
			PROMPT='%B%{$BG[001]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
		fi
		PROMPT+='
'
	fi

	PROMPT+="%B${venv_indicator}%{$FG[006]%}%1/%{$reset_color%} ➙  %b"
}

function git_prompt_info() {
	local ref
	ref=$(git symbolic-ref --quiet HEAD 2> /dev/null) || return
	echo "[${ref#refs/heads/}]"
}

RPROMPT='%B%{$FG[011]%}[%D{%H:%M:%S}]%{$reset_color%}%b'

set_prompt

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
