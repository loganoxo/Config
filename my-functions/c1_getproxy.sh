function getproxy() {
  echo "==================== terminal proxy: ========================"
  echo "http_proxy=$http_proxy;"
  echo "https_proxy=$https_proxy;"
  echo "all_proxy=$all_proxy;"

  echo "==================== git proxy: ============================="
  echo "http-global=$(git config --get http.proxy);"
  echo "https-global=$(git config --get https.proxy);"
  echo "http-github=$(git config --get http.https://github.com.proxy);"
  echo "https-github=$(git config --get https.https://github.com.proxy);"
}
