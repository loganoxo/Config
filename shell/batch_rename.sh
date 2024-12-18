#!/usr/bin/env bash
# 脚本名称: batch_rename.sh
# 作者: HeQin
# 最后修改时间: 2024-04-08
# 描述: 批量重命名。

set -eu #e:遇到错误就停止执行；u:遇到不存在的变量，报错停止执行
# 查看文件的换行符：od -c batch_name.txt
# 获取终端宽度
terminal_width=$(tput cols)

DEAL_DIR="$HOME/Temp"                   #预设的工作目录，只能在此目录下(或子目录下)执行该命令
NAMES_FILE_OLD="000_batch_name_old.txt" #预设的目录下，所有文件或文件夹的名字记录到的文件
NAMES_FILE_NEW="000_batch_name_new.txt" #预设的目录下，修改后的文件或文件夹的名字记录到的文件
RENAME_LOG="000_batch_rename.log"       #预设的目录下，重命名执行时日志记录 mv ./old ./new
OUT_DIR="out_dir"                       #当new的文件名和目录下现有的文件或文件夹重名时，输出重命名后的文件或文件夹到OUT_DIR下
# 在(sh/bash)../xxx/xxx.sh显式执行脚本时，"$(pwd)"为执行命令的当前目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" # 脚本所在目录
CURRENT_DIR="$(pwd)"                        #执行命令的当前目录;用source命令加载函数时也可以使用"$(cd "$(dirname "$0")";pwd)"
FULL_NAMES_FILE_OLD="$CURRENT_DIR/$NAMES_FILE_OLD"
FULL_NAMES_FILE_NEW="$CURRENT_DIR/$NAMES_FILE_NEW"
FULL_RENAME_LOG="$CURRENT_DIR/$RENAME_LOG"

# 声明数组；当数组作为参数时，即使某个元素有空格也不会出错；如：judge_same_for_array "${name_new_array[@]}"；接收端：local my_array=("$@")
# 但是如果要定义一个返回数组的函数，并且有空格的情况，那发送端需要循环echo、接收端要用read方式，否则会有问题，所以尽量用全局变量来处理，避免出错
declare -a name_old_array #老名字
declare -a name_new_array #新名字
declare -a execute_script #需要执行的mv脚本
declare -a file_list      #读取的当前目录下的列表

# custom脚本中的全局变量
declare -a custom_list                #新文件名list
source "$SCRIPT_DIR/custom_rename.sh" #加载自定义脚本

# 遍历当前目录下的所有文件和文件夹
# 不能用for item in $(ls); do ；因为如果文件名中有空格如"a b"，则会拆分成a和b
# 可以用for item in *; do；不会根据空格拆分，保证了文件名完整性
# 也可以：files=(*); for item in "${files[@]}";do
# 不能用for item in $(find . -maxdepth 1 -mindepth 1); do；因为如果文件名中有空格如"a b"，则会拆分成a和b
# 但可以find . -maxdepth 1 -mindepth 1 -print0 | while IFS= read -r -d '' item; do；
# -print0表示在输出文件名时使用空字符(null,''，不是空格)分隔，IFS保证可以读取行尾空格，read -d ''表示使用空字符作为分隔符来读取数据
# 也可以这样写： while IFS= read -r -d '' item; do <代码换行> echo "'$item'" <代码换行> done < <(find . -maxdepth 1 -mindepth 1 -print0)
# find命令输出的内容会带上 './'；< <(find ...) 将 find 命令的输出作为文件提供给了 while 循环
# < filename 表示将文件 filename 的内容作为标准输入传递给命令
# < <(command) <(command)是一种称为进程替换的机制，它会将command的输出作为临时文件或者管道的输入，而这个临时文件或者管道的名字会被传递给前面的<符号，
# 这两个符号之间的空格是为了分隔它们，从而让Bash能够正确地解析这个命令结构
function get_all_from_current_dir_depth1() {
    for item in *; do
        file_list+=("$item")
    done
}

# 读取文件
function read_old_file() {
    # declare -a temp_array #定义在函数里时，是个局部变量
    # -n:字符串判空，read有时最后一行读不到，所以要加|| [ -n "$line" ]
    # -r:把文件中显示的\字符看成一个普通字符，如果不加-r，则读到的内容会把\删掉
    # IFS=' ':默认就为空格，用在读取一行到多个变量中的时候；这里用到的是IFS=空格时，会去掉行首行尾的空格和文本结尾的空行(如果文件最后一行有空格)，为了直观，还是不用这个方式了
    # IFS= read -r line:IFS设为空，则不会去除行首行尾的空格，并且也不会去除文本结尾的空行(如果文件最后一行有空格)
    while IFS= read -r line || [ -n "$line" ]; do
        # 如果行不为空，则打印该行
        if [[ -n "$line" ]]; then
            name_old_array+=("$line")
        fi
    done <"$FULL_NAMES_FILE_OLD"
}

# 读取文件
function read_new_file() {
    while IFS= read -r line || [ -n "$line" ]; do
        # 如果行不为空，则打印该行
        if [[ -n "$line" ]]; then
            name_new_array+=("$line")
        fi
    done <"$FULL_NAMES_FILE_NEW"
}

# 校验当前目录
function validate_current_dir() {

    # 检查输入参数是否为空
    if [ $# -eq 0 ]; then
        echo "!!!error: validate_current_dir, need argument"
        return 1
    fi

    # 预先判断
    for item in "$@"; do
        if [ "$item" = "~" ] || [ "$item" = "/" ] || [ "$item" = "-" ] || [ "$item" = "." ]; then
            # 如果条件满足，执行相应的操作
            echo "!!!error: validate_current_dir, $item --Character illegal ."
            return 1
        fi

        # 定义非法字符集合
        local illegal_chars='~～!`\@'\''",?$%^&*()+={}[]|:;。. '
        for ((i = 0; i < ${#item}; i++)); do
            char="${item:$i:1}"
            # 检查字符是否在非法字符集合中
            if [[ "$illegal_chars" == *"$char"* ]]; then
                echo "!!!error: validate_current_dir, Illegal character '$char' found in the string."
                return 1 # 执行失败，返回非零值
            fi
        done

        if [ ! -e "$item" ]; then
            # 文件或目录不存在
            echo "!!!error: validate_current_dir, $item does not exist."
            return 1
        fi

        # 判断工作目录是否在DEAL_DIR下
        if [ -d "$item" ]; then
            # 如果参数是目录，则获取目录的绝对路径
            item_path="$(cd "$item" && pwd)"
            if [[ "$item_path" == "$DEAL_DIR"* ]]; then
                echo "当前目录正确，可以执行操作！"
                return 0 # 执行成功
            else
                echo "!!!error: 当前目录错误，请在 $DEAL_DIR 目录下执行操作！"
                return 1 # 执行失败，返回非零值
            fi
        else
            # 如果参数是文件
            echo "!!!error: validate_current_dir, current_dir wrong ."
            return 1 # 执行失败，返回非零值
        fi
        # 预先判断结束
    done
}

# 校验目录下修改后的文件夹名或文件名，还未存在
function validate_new_name() {
    # 检查输入参数是否为空
    if [ $# -eq 0 ]; then
        echo "!!!error: validate_new_name, need argument"
        return 1
    fi
    # 定义非法字符集合
    local illegal_chars='~～!/`\@'\''",?$%^&*()+={}[]|:;。'
    for item in "$@"; do
        if [ "$item" = "~" ] || [ "$item" = "/" ] || [ "$item" = "-" ] || [ "$item" = "." ]; then
            # 如果条件满足，执行相应的操作
            echo "!!!error: validate_new_name, $item --Character illegal ."
            return 1
        fi

        for ((i = 0; i < ${#item}; i++)); do
            char="${item:$i:1}"
            # 检查字符是否在非法字符集合中
            if [[ "$illegal_chars" == *"$char"* ]]; then
                echo "!!!error: validate_new_name, Illegal character '$char' found in '$item'."
                return 1 # 执行失败，返回非零值
            fi
        done
    done
    return 0 #校验成功
}

# 校验目录下存在的文件夹名或文件名
function validate_name() {
    # 检查输入参数是否为空
    if [ $# -eq 0 ]; then
        echo "!!!error: validate_name, need argument"
        return 1
    fi

    # 预先判断
    for item in "$@"; do
        if [ ! -e "$item" ]; then
            # 文件或目录不存在
            echo "!!!error: validate_name, $item does not exist."
            return 1
        fi
    done
    if ! validate_new_name "$@"; then
        # 校验失败
        return 1
    fi
    return 0 #校验成功
}

# 输出分界线
function print_head_line() {
    # 使用 tput 设置文本颜色为红色
    red_text=$(tput setaf 1)
    reset_style=$(tput sgr0)

    # 使用 printf 生成带颜色的分隔线
    printf "${red_text}%*s${reset_style}\n" "$1" "" | tr ' ' '——'
}

# 判读数组中是否有相同元素
function judge_same_for_array() {
    local my_array=("$@")
    # 标记是否找到相同的字符串
    found=false
    local ele=""
    # 使用双重循环来比较数组中的每个元素
    for ((mm = 0; mm < ${#my_array[@]} - 1; mm++)); do
        for ((nn = mm + 1; nn < ${#my_array[@]}; nn++)); do
            if [[ "${my_array[mm]}" == "${my_array[nn]}" ]]; then
                found=true
                ele="${my_array[mm]}"
                break 2 # 跳出两层循环
            fi
        done
    done

    # 结果
    if [ $found == "true" ]; then
        echo "!!!error: 有相同元素：$ele"
        return 1 #有相同元素
    else
        return 0 #没有相同元素
    fi
}

# 执行mv操作
function execute_mv() {
    local if_mkdir=false #是否需要新建文件夹
    local if_mv=false    #是否有mv语句
    for ((i = 0; i < ${#name_old_array[@]}; i++)); do
        old="${name_old_array[i]}"
        new="${name_new_array[i]}"
        if [[ -n "$old" && -n "$new" && "$old" != "$new" ]]; then
            # 如果old和new非空，并且old和new不相同，则拼接mv语句
            if_mv=true
            # 如果old和new非空，并且old和new不相同时，判断new是否与当前目录其他文件同名(不同行号)
            if [ -e "$CURRENT_DIR/$new" ]; then
                if_mkdir=true
                break # 提前退出循环
            fi
        fi
    done

    # 整理脚本
    local prefix=""
    if [ $if_mv == "true" ]; then
        # 有mv语句
        if [ $if_mkdir == "true" ]; then
            # 需要创建文件夹
            read -rp "发现某新文件名与当前文件夹中的某文件名相同，会发生覆盖，所以要新建一个输出文件夹，确认吗? (y/n): " choice
            case "$choice" in
            y | Y)
                # 创建文件夹
                mkdir "$OUT_DIR"
                echo "已创建输出文件夹：$OUT_DIR"
                prefix="$OUT_DIR/"
                ;;
            *)
                echo "操作取消."
                exit 1 #脚本停止
                ;;
            esac
        fi

        # 判断一下
        temp_prefix="${prefix// /}" #去除所有空格
        if [[ "$temp_prefix" != "$prefix" || "$prefix" == "/" ]]; then
            echo "!!!error: batch_rename(), 目录prefix不正确:'$prefix'."
            exit 1
        fi
        if [[ -n "$prefix" ]]; then
            dir=$(cd $prefix && pwd)
            if [[ "$dir" != "$DEAL_DIR"* ]]; then
                echo "!!!error: batch_rename(), 目录prefix不正确:'$dir'."
                exit 1
            fi
        fi
        # 拼接脚本
        for ((i = 0; i < ${#name_old_array[@]}; i++)); do
            old="${name_old_array[i]}"
            new="${name_new_array[i]}"
            if [[ -n "$old" && -n "$new" && "$old" != "$new" ]]; then
                # 如果old和new非空，并且old和new不相同，则拼接mv语句
                execute_script+=("mv -i \"$old\" \"$prefix$new\" ;")
            fi
        done
    else
        # 不需要mv
        echo "!!!error: batch_rename(),old_names和new_names中，行对应相同,不需要重命名，脚本停止运行"
        exit 1
    fi
    print_head_line "$terminal_width" #输出分界线

    # 执行重命名
    if [ ${#execute_script[@]} -eq 0 ]; then
        echo "!!!error: batch_rename(),old_names和new_names中，execute_script为空，脚本停止运行"
        exit 1
    else
        echo "以下为将要执行的mv语句："
        print_head_line "$terminal_width"    #输出分界线
        printf "%s\n" "${execute_script[@]}" #逐行输出
        print_head_line "$terminal_width"    #输出分界线
        # 执行前确认
        read -rp "确认要执行以上 ${#execute_script[@]} 条 脚本吗? (y/n): " choice
        print_head_line "$terminal_width" #输出分界线
        case "$choice" in
        y | Y)
            # 执行批量重命名
            echo "$(date "+%Y-%m-%d %H:%M:%S")  ------将要执行的mv----------------------- " >>"$FULL_RENAME_LOG"
            for log in "${execute_script[@]}"; do
                echo "$log" >>"$FULL_RENAME_LOG"
            done
            echo "$(date "+%Y-%m-%d %H:%M:%S")  ------现在开始执行mv----------------------- " >>"$FULL_RENAME_LOG"
            local count=0 #初始化计数器
            local if_failed=false
            for cmd in "${execute_script[@]}"; do
                if eval "$cmd"; then
                    # 成功
                    ((count++)) #计数器加1
                    echo "【success】>  $cmd"
                    echo "$(date "+%Y-%m-%d %H:%M:%S")  $cmd" >>"$FULL_RENAME_LOG"
                else
                    # 失败
                    if_failed=true
                    echo "【Failure】>  $cmd"
                    echo "发生错误，提前终止!"
                    echo "$(date "+%Y-%m-%d %H:%M:%S")  发生错误，提前终止，错误语句为：$cmd" >>"$FULL_RENAME_LOG"
                    break
                fi
            done
            # 打印日志
            if [ $if_failed == "false" ]; then
                echo "成功执行了 $count 条语句,未发生错误"
                echo "$(date "+%Y-%m-%d %H:%M:%S")  ------成功执行完毕，执行了 $count 条语句，未发生错误-------------------------- " >>"$FULL_RENAME_LOG"
            else
                echo "发生了错误，但是成功执行了 $count 条语句"
                echo "$(date "+%Y-%m-%d %H:%M:%S")  ------发生了错误，但是成功执行执行了 $count 条语句-------------------------- " >>"$FULL_RENAME_LOG"
            fi
            echo "日志已记录在文件 $FULL_RENAME_LOG 中"
            ;;
        *)
            echo "操作取消."
            exit 1 #脚本停止
            ;;
        esac
    fi
}

# 从当前目录整理所有一级文件或文件夹的名字，输出到某个文件
function batch_name() {
    if ! validate_current_dir "$CURRENT_DIR"; then
        echo "!!!error: 当前目录不正确."
        return 1
    fi
    echo "正在整理当前目录中所有的文件名...."
    print_head_line "$terminal_width"
    # 进入当前目录
    cd "$CURRENT_DIR" || {
        echo "!!!error: batch_name()，cd $CURRENT_DIR 出现错误"
        return 1
    }
    # 初始化计数器
    local count=0
    # 输出所有文件名到终端并保存到临时变量
    local temp_file_names=""
    local temp_file_names_display=""
    # 遍历当前目录下的所有文件和文件夹
    get_all_from_current_dir_depth1
    for item in "${file_list[@]}"; do
        # 排除文件名
        if [[ "$item" != "$NAMES_FILE_OLD" && "$item" != "$NAMES_FILE_NEW" && "$item" != "$RENAME_LOG" ]]; then
            if ! validate_name "$item"; then
                echo "!!!error: batch_name(),文件名 $item 非法，脚本停止运行"
                return 1 #校验失败
            fi
            # 将文件名追加到临时变量中，每个文件名一行
            temp_file_names_display+="'$item'"$'\n'
            temp_file_names+="$item"$'\n'
            # 计数器加1
            ((count++))
        fi
    done

    if [ "$count" -eq 0 ]; then
        echo "!!!error: batch_name(),当前目录下，没有可操作的文件或文件夹！"
        return 1
    fi

    #执行前的确认
    echo -ne "$temp_file_names_display" #把所有文件名打印到终端确认
    print_head_line "$terminal_width"
    read -rp "确认将以上所有文件名输出到文件中吗? (y/n): " choice
    case "$choice" in
    y | Y)
        # 将文件名追加到txt中,-n选项：表示不要在输出文本后自动添加换行符。
        # -e选项：表示启用转义字符的解析，例如 \n 会被解释为换行符，\t 会被解释为制表符等。
        # 即使不用-e,echo 命令大多数情况下会默认解析转义字符,但为了保证脚本的可移植性和一致性，建议在使用转义字符时始终使用 -e 选项
        # 清空或创建文件
        echo -ne "$temp_file_names" >"$FULL_NAMES_FILE_OLD"
        echo "成功读入到 $FULL_NAMES_FILE_OLD 中, 共 $count 条"
        return 0
        ;;
    *)
        echo "操作取消."
        exit 1
        ;;
    esac

}

# 从两个文件中读取数据，然后批量重命名
function batch_rename() {
    # 校验当前目录
    if ! validate_current_dir "$CURRENT_DIR"; then
        echo "!!!error: 当前目录不正确."
        return 1 # 校验失败
    fi
    # 判断old存在否
    if [ ! -e "$FULL_NAMES_FILE_OLD" ]; then
        echo "!!!error: batch_rename(),无法重命名, 因为 $FULL_NAMES_FILE_OLD 不存在."
        return 1
    fi
    # 判断new存在否
    if [ ! -e "$FULL_NAMES_FILE_NEW" ]; then
        echo "!!!error: batch_rename(),无法重命名, 因为 $FULL_NAMES_FILE_NEW 不存在."
        return 1
    fi

    # 读取文件
    read_old_file #读到name_old_array
    read_new_file #读到name_new_array
    # 确保两个文件列表的行数相同
    if [ "${#name_old_array[@]}" -ne "${#name_new_array[@]}" ]; then
        echo "!!!error: batch_rename(),两个文件有效行数不相等,old:${#name_old_array[@]},new:${#name_new_array[@]}"
        return 1
    fi
    local count=${#name_old_array[@]}
    # 进入当前目录
    cd "$CURRENT_DIR" || {
        echo "!!!error: batch_rename(),cd $CURRENT_DIR 出现错误"
        return 1
    }

    # 校验字符
    if ! validate_name "${name_old_array[@]}"; then
        echo "!!!error: batch_rename(),name_old_array,原文件的文件名非法，脚本停止运行"
        return 1 #校验失败
    fi
    if ! validate_new_name "${name_new_array[@]}"; then
        echo "!!!error: batch_rename(),name_new_array,新文件的文件名非法，脚本停止运行"
        return 1 #校验失败
    fi

    # 校验new新文件名 是否包含预设文件，是否行首行尾有空格，是否有同名文件，将中间的空格转译
    for ((i = 0; i < ${#name_new_array[@]}; i++)); do
        item="${name_new_array[i]}"

        # 是否包含预设文件
        if [[ "$item" == "$NAMES_FILE_OLD" || "$item" == "$NAMES_FILE_NEW" || "$item" == "$RENAME_LOG" ]]; then
            echo "!!!error: batch_rename(), 新文件名name_new_array中包含预设文件: '$NAMES_FILE_OLD' or '$NAMES_FILE_NEW' or '$RENAME_LOG'"
            return 1
        fi

        # 是否行首行尾有空格
        if [[ "$item" =~ ^[[:space:]]|[[:space:]]$ ]]; then
            echo "!!!error: batch_rename(), 新文件名name_new_array中,'$item'前后有空格!"
            return 1
        fi
        # 将中间的空格转译,不需要；
        # 双引号"$temp"将整个变量视为一个单独的参数。这意味着mv命令将"$temp"解释为一个文件名，而不会将空格视为分隔符
    done
    # 是否有同名文件
    if ! judge_same_for_array "${name_new_array[@]}"; then
        echo "!!!error: batch_rename(),name_new_array,有相同的文件名，脚本停止运行"
        return 1 #校验失败
    fi

    # 校验old旧文件名 是否包含预设文件，是否有同名文件，将中间的空格转译
    for ((i = 0; i < ${#name_old_array[@]}; i++)); do
        item="${name_old_array[i]}"
        # 是否包含预设文件
        if [[ "$item" == "$NAMES_FILE_OLD" || "$item" == "$NAMES_FILE_NEW" || "$item" == "$RENAME_LOG" ]]; then
            echo "!!!error: batch_rename(), 旧文件名name_old_array中包含预设文件: '$NAMES_FILE_OLD' or '$NAMES_FILE_NEW' or '$RENAME_LOG'"
            return 1
        fi
        # 将中间的空格转译,不需要；
        # 双引号"$temp"将整个变量视为一个单独的参数。这意味着mv命令将"$temp"解释为一个文件名，而不会将空格视为分隔符
    done
    # 是否有同名文件
    if ! judge_same_for_array "${name_old_array[@]}"; then
        echo "!!!error: batch_rename(),name_old_array,有相同的文件名，脚本停止运行"
        return 1 #校验失败
    fi
    echo "校验通过，正在整理需要修改的文件名...."

    # 执行mv操作
    execute_mv
}

# 自定义重命名，source另一个脚本
function custom_rename() {
    # 校验当前目录
    cd "$CURRENT_DIR" || {
        echo "!!!error: custom_rename(),cd $CURRENT_DIR 出现错误"
        return 1
    }
    if ! validate_current_dir "$CURRENT_DIR"; then
        echo "!!!error: 当前目录不正确."
        return 1 # 校验失败
    fi

    # 输出所有文件名到终端并保存到临时变量
    local temp_file_names=""
    # 遍历当前目录下的所有文件和文件夹
    get_all_from_current_dir_depth1
    local count=0
    for item in "${file_list[@]}"; do
        if ! validate_name "$item"; then
            echo "!!!error: custom_rename(),文件名 $item 非法，脚本停止运行"
            return 1 #校验失败
        fi
        # 将文件名追加到临时变量中，每个文件名一行
        temp_file_names+="'$item'"$'\n'
        # 计数器加1
        ((count++))
    done

    if [ "$count" -eq 0 ]; then
        echo "!!!error: custom_rename(),当前目录下，没有可操作的文件或文件夹！"
        return 1
    fi

    # 是否有同名文件
    if ! judge_same_for_array "${file_list[@]}"; then
        echo "!!!error: custom_rename(),旧文件名中有相同的文件名，脚本停止运行"
        return 1 #校验失败
    fi
    echo "旧文件名校验通过...."
    print_head_line "$terminal_width"
    echo -ne "$temp_file_names" #把所有文件名打印到终端确认
    print_head_line "$terminal_width"
    read -rp "共 $count 条 ，确认将以上所有旧文件名正确，并执行自定义脚本获取新文件名吗? (y/n): " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "操作取消."
        exit 1
    fi
    echo "正在执行自定义处理脚本，去获得新文件名...."
    custom_operation #执行custom_rename.sh中的自定义操作函数
    if [ "${#custom_list[@]}" -eq 0 ]; then
        echo "!!!error: custom_rename(),新文件数组为空数组，脚本停止运行"
        return 1 #校验失败
    fi
    # 确保两个文件列表的行数相同
    if [ "${#file_list[@]}" -ne "${#custom_list[@]}" ]; then
        echo "!!!error: custom_rename(),新旧文件列表有效行数不相等,old:${#file_list[@]},new:${#custom_list[@]}"
        return 1
    fi
    if ! validate_new_name "${custom_list[@]}"; then
        echo "!!!error: custom_rename(),新文件的文件名非法，脚本停止运行"
        return 1 #校验失败
    fi

    # 校验new新文件名 是否包含预设文件，是否行首行尾有空格，是否有同名文件，将中间的空格转译
    for ((i = 0; i < ${#custom_list[@]}; i++)); do
        item="${custom_list[i]}"
        # 是否包含预设文件
        if [[ "$item" == "$NAMES_FILE_OLD" || "$item" == "$NAMES_FILE_NEW" || "$item" == "$RENAME_LOG" ]]; then
            echo "!!!error: custom_rename(), 新文件名custom_list中包含预设文件: '$NAMES_FILE_OLD' or '$NAMES_FILE_NEW' or '$RENAME_LOG'"
            return 1
        fi
        # 是否行首行尾有空格
        if [[ "$item" =~ ^[[:space:]]|[[:space:]]$ ]]; then
            echo "!!!error: custom_rename(), 新文件名custom_list中,'$item'前后有空格!"
            return 1
        fi
        # 将中间的空格转译,不需要；
        # 双引号"$temp"将整个变量视为一个单独的参数。这意味着mv命令将"$temp"解释为一个文件名，而不会将空格视为分隔符
    done
    # 是否有同名文件
    if ! judge_same_for_array "${custom_list[@]}"; then
        echo "!!!error: custom_rename(),custom_list,有相同的文件名，脚本停止运行"
        return 1 #校验失败
    fi
    print_head_line "$terminal_width"
    #把所有文件名打印到终端确认
    for element in "${custom_list[@]}"; do
        echo "'$element'"
    done
    print_head_line "$terminal_width"
    read -rp "共 ${#custom_list[@]} 条 ，确认将以上所有新文件名正确，并执行重命名吗? (y/n): " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "操作取消."
        exit 1
    fi
    #公共数组先置空再赋值
    name_old_array=()
    name_new_array=()
    for ele in "${file_list[@]}"; do
        name_old_array+=("$ele")
    done
    for ele in "${custom_list[@]}"; do
        name_new_array+=("$ele")
    done
    # 执行mv操作
    execute_mv
}

########################## 执行脚本 ######################
no_spaces="${CURRENT_DIR// /}" #去除所有空格
if [[ -z "$no_spaces" || "$no_spaces" != "$CURRENT_DIR" || "$CURRENT_DIR" != "$DEAL_DIR"* ]] || ! validate_current_dir "$CURRENT_DIR"; then
    echo "!!!error: 当前目录不正确."
    exit 1
fi

str0="\033[31m 当前目录: $CURRENT_DIR ; 日志文件记录在文件 $RENAME_LOG 中. \033[0m \n"
str1="\033[31m[ 1 ] 提取文件名\033[0m 输出到 $NAMES_FILE_OLD 中. \n"
str2="\033[31m[ 2 ] 批量重命名\033[0m 根据文件 $NAMES_FILE_OLD 和 $NAMES_FILE_NEW . \n"
str3="\033[31m[ 3 ] 自定义重命名\033[0m 根据脚本custom_rename.sh \n"
str4="\033[31m[ 4 ] Exit\033[0m\n"
echo -e "$str0$str1$str2$str3$str4"
read -rp "Input your choice : " choice

if [ "$choice" == "1" ]; then
    batch_name
elif [ "$choice" == "2" ]; then
    batch_rename
elif [ "$choice" == "3" ]; then
    custom_rename
elif [ "$choice" == "4" ]; then
    echo -e "\033[31m exit.....\033[0m"
    exit 0
else
    echo -e "\033[31m !!!error: There is no such choice,please input the right number.\033[0m"
    exit 1
fi
