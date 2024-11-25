function fkill() {
  local pid
  if [ "$UID" != "0" ]; then
    pid=$(ps -f -u $UID | sed 1d | (fzf -m --preview='') | awk '{print $2}')
  else
    pid=$(ps -ef | sed 1d | (fzf -m --preview='') | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]; then
    echo "$pid" | xargs kill -"${1:-9}"
  fi
}
