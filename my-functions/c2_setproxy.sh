function setproxy() {
  # proxy
  #alias setproxy="export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:25307 all_proxy=socks5://127.0.0.1:25307"
  #alias unproxy="unset http_proxy;unset https_proxy;unset ALL_PROXY"

  # git-proxy
  #alias gitProxy="git config --global http.proxy socks5://127.0.0.1:25307;git config --global https.proxy socks5://127.0.0.1:25307"
  #alias gitUnproxy="git config --global --unset http.proxy;git config --global --unset https.proxy"
  # 上面alias舍弃，代理用自定义函数方式去做

  if [ "$1" != "git" ] && [ "$1" != "term" ] && [ "$1" != "all" ]; then
    echo 输入不符合要求
  fi

  if [ "$1" = "git" ] || [ "$1" = "all" ]; then
    echo "set git proxy ......"
    # 全局，不推荐
    # git config --global http.proxy socks5://127.0.0.1:25307
    # git config --global https.proxy socks5://127.0.0.1:25307
    # 只针对github
    git config --global http.https://github.com.proxy socks5h://127.0.0.1:25307
    git config --global https.https://github.com.proxy socks5h://127.0.0.1:25307
  fi
  if [ "$1" = "term" ] || [ "$1" = "all" ]; then
    echo "set terminal proxy ......"
    export https_proxy=http://127.0.0.1:25307
    export http_proxy=http://127.0.0.1:25307
    export all_proxy=socks5://127.0.0.1:25307
  fi
}
