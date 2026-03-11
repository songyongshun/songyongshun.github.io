#!/usr/bin/env bash
# 遇到错误时退出，使用未定义变量时报错，管道中任何命令失败时返回非零状态
set -o errexit
set -o nounset
set -o pipefail

# 简单警告
echo "注意：脚本会在当前目录执行你的命令，请在安全目录运行（例如一个练习目录）。"
echo "输入 'hint' 获取提示，输入 'skip' 跳过当前题。按 Ctrl+C 退出。"
echo

ORIGINAL_DIR="$PWD"
TARGET_DIR="$ORIGINAL_DIR/basic-file-command"
WORK_DIR="$TARGET_DIR"

# 运行前准备练习目录
echo "将会在目录 \"$TARGET_DIR\" 中进行练习。"
if [ -d "$TARGET_DIR" ]; then
  echo "目录已存在，正在删除：$TARGET_DIR"
  rm -rf "$TARGET_DIR"
fi
mkdir -p "$TARGET_DIR"

CURRENT_DIR="$WORK_DIR"
cd_visited=0

cleanup() {
  # 退出时提示并删除练习目录
  if [ -d "$WORK_DIR" ]; then
    echo
    read -rp "按回车删除练习目录 $WORK_DIR（或按 Ctrl+C 保留）... " _
    rm -rf "$WORK_DIR"
    echo "已删除 $WORK_DIR"
  fi
}
trap cleanup EXIT


run_and_capture() {
  # 在函数开始处初始化并检测复合命令（; && |）
  LAST_COMPOUND=0
  if printf '%s' "$cmd" | grep -qE '[;&|]'; then
    LAST_COMPOUND=1
  fi

  local cmd="$1"
  output=""
  rc=0

  case "$cmd" in
    cd|cd\ *)
      # extract argument (may be empty)
      arg="${cmd#cd}"
      arg="${arg#"${arg%%[![:space:]]*}"}" # trim leading spaces

      if [ "$LAST_COMPOUND" -eq 1 ]; then
        # 复合命令含有 cd（如 "cd dir; touch f"），在子 shell 执行，不改变 CURRENT_DIR
        output=$(bash -c "cd \"$CURRENT_DIR\" && $cmd" 2>&1) || rc=$?
      else
        if [ -z "$arg" ]; then
          newdir="$HOME"
        else
          newdir=$(bash -c 'cd "$1" && cd -- "$2" 2>/dev/null && pwd' _ "$CURRENT_DIR" "$arg") || rc=$?
        fi

        if [ -n "${newdir:-}" ]; then
          CURRENT_DIR="$newdir"
          if [ "$CURRENT_DIR" = "$WORK_DIR/my_projects" ]; then
            cd_visited=1
          fi
          output=""
          rc=${rc:-0}
        else
          output=$(bash -c "cd \"$CURRENT_DIR\" && $cmd" 2>&1) || rc=$?
        fi
      fi
      ;;
    *)
      output=$(bash -c "cd \"$CURRENT_DIR\" && $cmd" 2>&1) || rc=$?
      ;;
  esac

  rc=${rc:-0}
}

check_ok() {
  # run the given command in CURRENT_DIR in a subshell so validators work relative to CURRENT_DIR
  (cd "$CURRENT_DIR" && "$@")
}

exercise_loop() {
  local prompt="$1"
  local validator="$2"
  local hint="$3"

  echo
  echo "题目：$prompt"
  while true; do
    read -rp "请输入命令 (hint/skip): " cmd
    case "$cmd" in
      hint)
        echo "提示: $hint"
        continue
        ;;
      skip)
        echo "已跳过。"
        return 0
        ;;
      "")
        continue
        ;;
    esac

    # 运行并捕获输出/返回码
    output=""
    rc=0
    run_and_capture "$cmd"

    # 立即把命令输出回显给用户（如果有）
    if [ -n "$output" ]; then
      printf '%s\n' "$output"
    fi

    # 调用校验函数（传递 output 和 rc 环境变量）
    if $validator; then
      echo "✅ 正确"
      return 0
    else
        echo "❌ 未通过，请重试或输入 'hint'。最近命令返回码：$rc"
    fi
  done
}

# 各题的校验函数（使用 CURRENT_DIR）
validate_1() { check_ok test -f myfile.txt; }
validate_2() { check_ok grep -qxF "Hello, Linux!" myfile.txt; }
validate_3() { [ "$rc" -eq 0 ] && printf '%s' "$output" | grep -Fq "Hello, Linux!"; }
validate_4() { check_ok bash -c 'test -f myfile_copy.txt && cmp -s myfile.txt myfile_copy.txt'; }
validate_5() { check_ok test -d backup; }
validate_6() { check_ok test -f backup/myfile_copy.txt; }
validate_7() { check_ok test ! -e myfile.txt; }
validate_8() { [ "$rc" -eq 0 ] && [ -n "$output" ]; }
validate_9() { check_ok test -d projects; }
validate_10() { [ "$CURRENT_DIR" = "$WORK_DIR/projects" ]; }
validate_11() { [ -f "$CURRENT_DIR/example.txt" ]; }
validate_12() { [ "$CURRENT_DIR" = "$WORK_DIR" ]; }
validate_13() { check_ok test -d my_projects; }
validate_14() { check_ok test ! -e backup; }

# 题目与 hint（根据 excersize.md 第12题已更新为切换目录练习）
exercise_loop "1) 使用 touch 创建空文件 myfile.txt。" validate_1 "示例：touch myfile.txt"
exercise_loop "2) 将文本写入 myfile.txt：写入 \"Hello, Linux!\"。" validate_2 "示例：echo 'Hello, Linux!' > myfile.txt"
exercise_loop "3) 使用 cat 查看 myfile.txt 的内容。" validate_3 "示例：cat myfile.txt"
exercise_loop "4) 复制 myfile.txt 为 myfile_copy.txt。" validate_4 "示例：cp myfile.txt myfile_copy.txt"
exercise_loop "5) 创建 backup 目录。" validate_5 "示例：mkdir backup"
exercise_loop "6) 将 myfile_copy.txt 移动到 backup 目录。" validate_6 "示例：mv myfile_copy.txt backup/"
exercise_loop "7) 删除 myfile.txt。" validate_7 "示例：rm myfile.txt"
exercise_loop "8) 列出当前目录下的文件。" validate_8 "示例：ls"
exercise_loop "9) 创建目录 projects。" validate_9 "示例：mkdir projects"
exercise_loop "10) 切换目录：使用cd进入projects目录。" validate_10 "示例：cd projects"
exercise_loop "11) 在当前目录创建 example.txt。" validate_11 "示例：touch example.txt"
exercise_loop "12) 切换目录：使用cd返回上一级目录。" validate_12 "示例：cd .."
exercise_loop "13) 将 projects 重命名为 my_projects。" validate_13 "示例：mv projects my_projects"
exercise_loop "14) 删除 backup 目录。" validate_14 "示例：rm -r backup"

echo
echo "所有题目完成。干得好！"