export __PATH_MY_CNF="$HOME/Data/Config" # 我自己的配置文件目录
# 可能需要先删除 "/opt/homebrew/var/www" 目录
ln -sf "${__PATH_MY_CNF}/nginx/www" "/opt/homebrew/var/www"
ln -sf "$HOME/Share/nginx" "${__PATH_MY_CNF}/nginx/www/files/share"
ln -sf "${__PATH_MY_CNF}/nginx/etc/nginx.conf" "/opt/homebrew/etc/nginx/nginx.conf"
ln -sf "${__PATH_MY_CNF}/nginx/etc/servers" "/opt/homebrew/etc/nginx/servers"
