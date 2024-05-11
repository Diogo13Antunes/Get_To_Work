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
		if [[ "$git_status" =~ "nothing to commit" ]]; then
			PROMPT='%B%{$BG[002]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
		elif [[ "$git_status" =~ "Changes to be committed" ]]; then
			PROMPT='%B%{$BG[003]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
		elif [[ "$git_status" =~ "Changes not staged for commit" ]]; then
			PROMPT='%B%{$BG[172]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
		else
			PROMPT='%B%{$BG[001]%}%{$FG[000]%} $(git_prompt_info) %{$reset_color%}%b'
		fi

		if [[ "$git_status" =~ "nothing to commit" ]]; then
		else
		fi
		PROMPT+='
'
	fi

	PROMPT+="%B${venv_indicator}%{$FG[006]%}%1/%{$reset_color%} ➙  %b"
}

RPROMPT='%B%{$FG[011]%}[%D{%H:%M:%S}]%{$reset_color%}%b'

set_prompt

precmd() {
	set_prompt
}

TMOUT=1

TRAPALRM() {
	zle reset-prompt
}
