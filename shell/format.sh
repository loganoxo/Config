#!/usr/bin/awk -f
{
    gsub(/^[ \t]+/, ""); # 删除行首的空白字符
    indentation = ""; # 初始化缩进字符串
    if (/^\}/) context_depth--; # 如果是右括号，减少缩进层级
    for (i = 0; i < context_depth; i++) indentation = indentation "    "; # 按层级添加缩进
    print indentation $0; # 输出缩进后的行
    if (/\{$/) context_depth++; # 如果是左括号，增加缩进层级
}
BEGIN { context_depth = 0 } # 初始化层级计数器
