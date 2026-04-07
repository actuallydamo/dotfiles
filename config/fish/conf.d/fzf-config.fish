set -l FZF_DEFAULT_OPTS '--height=40%'

# set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
# " --color=bg+:{{colors.color01}},bg:{{colors.color00}},spinner:{{colors.color0c}},hl:{{colors.color0d}}"\
# " --color=fg:{{colors.color04}},header:{{colors.color0d}},info:{{colors.color0a}},pointer:{{colors.color0c}}"\
# " --color=marker:{{colors.color0c}},fg+:{{colors.color06}},prompt:{{colors.color0a}},hl+:{{colors.color0d}}"


# set -l color00 '#1a1b26'
# set -l color01 '#16161e'
# set -l color02 '#2f3549'
# set -l color03 '#444b6a'
# set -l color04 '#787c99'
# set -l color05 '#a9b1d6'
# set -l color06 '#cbccd1'
# set -l color07 '#d5d6db'
# set -l color08 '#c0caf5'
# set -l color09 '#a9b1d6'
# set -l color0A '#0db9d7'
# set -l color0B '#9ece6a'
# set -l color0C '#b4f9f8'
# set -l color0D '#2ac3de'
# set -l color0E '#bb9af7'
# set -l color0F '#f7768e'

set -l color00 "#16161E"
set -l color01 "#1A1B26"
set -l color02 "#2F3549"
set -l color03 "#444B6A"
set -l color04 "#787C99"
set -l color05 "#787C99"
set -l color06 "#CBCCD1"
set -l color07 "#D5D6DB"
set -l color08 "#F7768E"
set -l color09 "#FF9E64"
set -l color0A "#E0AF68"
set -l color0B "#41A6B5"
set -l color0C "#7DCFFF"
set -l color0D "#7AA2F7"
set -l color0E "#BB9AF7"
set -l color0F "#D18616"

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
" --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"\
" --color=preview-fg:$color04,preview-bg:$color00"\
" --color=preview-label:$color04,preview-border:$color02"
