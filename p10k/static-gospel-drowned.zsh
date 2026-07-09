# Static Gospel Drowned - powerlevel10k
# Source this AFTER ~/.p10k.zsh (it overrides the generated config's colors):
#   [[ -f ~/.config/zsh/static-gospel-drowned.zsh ]] && source ~/.config/zsh/static-gospel-drowned.zsh
#
# Collapses p10k's rainbow to one lit signal bar: every segment sits on the
# same block (this variant's `hl_med`, a step up from the muted overlay so the
# prompt reads like backlit signage over the deep base), differentiated by hot
# accent text rather than per-segment fills. Only the block color changes between
# variants; the text accents are shared. Git status text colors live in
# my_git_formatter in the p10k config itself (also shared accents), not here.

() {
  local v
  # Put every segment on the lit surface individually. NOT via the global
  # POWERLEVEL9K_BACKGROUND, which fills the whole prompt line into one band.
  for v in ${(k)parameters[(I)POWERLEVEL9K_*_BACKGROUND]}; do
    typeset -g $v='#3e4750'
  done
  # Drop the generated block-tuned foregrounds; a readable base + accents below.
  for v in ${(k)parameters[(I)POWERLEVEL9K_*_FOREGROUND]}; do
    unset $v
  done
}
typeset -g POWERLEVEL9K_FOREGROUND='#97a0b6'
# Prompt char and the left/right gap stay transparent (no surface fill).
typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND=
typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_BACKGROUND=
typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_GAP_BACKGROUND=

# Same-color segments: plain spacers internally so they merge into one bar;
# the config's rounded outer caps are kept for pill ends.
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=' '
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=' '
typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '

# Text accents (shared across variants).
typeset -g POWERLEVEL9K_DIR_FOREGROUND='#ebfafa'
typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#505a64'
typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#ebfafa'
typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND='#66e4fd'
typeset -g POWERLEVEL9K_TERRAFORM_FOREGROUND='#b48eff'
typeset -g POWERLEVEL9K_GCLOUD_FOREGROUND='#ff86d4'
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND='#ffce54'
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND='#37f499'
typeset -g POWERLEVEL9K_TIME_FOREGROUND='#6e7487'
typeset -g POWERLEVEL9K_CONTEXT_FOREGROUND='#6e7487'
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND='#ff5c78'
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND='#37f499'
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#37f499'
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND='#ff5c78'

# Re-apply if p10k is already loaded (no-op on a fresh shell).
(( ! $+functions[p10k] )) || p10k reload
