#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
这是一个用于统计文件中链接对应文本行数的脚本。
每一行包含一个链接，链接后面跟着逗号和其他内容。
该脚本会计算文件中所有链接对应的文本行数，并打印出来。
"""
import requests


def count_lines_in_file(file_path, encoding='utf-8'):
    try:
        # 读取文件，提取链接
        with open(file_path, 'r', encoding=encoding) as file:
            link_set = set()
            for line in file:
                parts = line.strip().split(',')
                link = parts[0].strip()
                link_set.add(link)

        total_lines = 0
        link_lines = {}

        # 遍历链接集合，获取每个链接对应的网络资源的内容，并记录行数
        for link in link_set:
            response = requests.get(link)
            content = response.text.split('\n')
            line_count = len(content)
            total_lines += line_count
            link_lines[link] = line_count

        return total_lines, link_lines

    except FileNotFoundError:
        # 捕获文件不存在错误，抛出自定义异常
        raise FileNotFoundError(f"File not found: {file_path}")
    except UnicodeDecodeError:
        # 捕获编码错误，抛出自定义异常
        raise UnicodeDecodeError(f"Unable to decode file {file_path} with {encoding} encoding.")
    except Exception as e:
        # 捕获其他异常，记录异常类型和信息到日志（这里用打印代替）
        print(f"An error occurred: {type(e).__name__}: {e}")
        raise


def main(file_path='./a.txt'):
    try:
        # 调用函数统计行数
        total_lines, link_lines = count_lines_in_file(file_path)

        # 打印结果
        print("Total lines in file:", total_lines)
        print("Lines for each link:")
        for link, lines in link_lines.items():
            print(f"Link: {link}, Lines: {lines}")
    except FileNotFoundError:
        print("File not found. Please check the file path.")
    except UnicodeDecodeError:
        print("Unable to decode file. Please check the file encoding.")
    except Exception as e:
        print("An unexpected error occurred:", e)


if __name__ == "__main__":
    main()
