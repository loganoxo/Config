function unproxy() {
  if [ "$1" != "git" ] && [ "$1" != "term" ] && [ "$1" != "all" ]; then
    echo 输入不符合要求
  fi
  if [ "$1" = "git" ] || [ "$1" = "all" ]; then
    echo "unset git proxy ......"
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    git config --global --unset http.https://github.com.proxy
    git config --global --unset https.https://github.com.proxy
  fi
  if [ "$1" = "term" ] || [ "$1" = "all" ]; then
    echo "unset terminal proxy ......"
    unset https_proxy
    unset http_proxy
    unset all_proxy
  fi
}
