. ~/.bashrc

# 便利なls
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# d(^_^o)
function shimamon() {
  local hamburg=$PWD
  cd ~/config
  make $1 $2
  cd $hamburg
}

# d(^_^o)
function simamon() {
  shimamon $1 $2
}
