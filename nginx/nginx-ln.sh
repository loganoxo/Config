export __PATH_MY_CNF="$HOME/Data/Config" # 我自己的配置文件目录

ln -sf "${__PATH_MY_CNF}/nginx/www" "/opt/homebrew/var/www"
ln -sf "${__PATH_MY_CNF}/nginx/etc/nginx.conf" "/opt/homebrew/etc/nginx/nginx.conf"
ln -sf "${__PATH_MY_CNF}/nginx/etc/servers" "/opt/homebrew/etc/nginx/servers"
