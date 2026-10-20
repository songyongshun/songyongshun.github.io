---
title: "Linux用户和权限管理"
collection: teaching
type: "Undergraduate course"
permalink: /teaching/2026-spring-teaching/chapter-2
venue: "常州工业职业技术学院, 信息工程学院"
date: 2026-03-01
location: "Changzhou, China"
---

## Linux用户和权限管理

### 1. 用户管理基础
- **用户分类**：
  - 超级用户（root）：拥有系统最高权限
  - 普通用户：拥有有限的系统权限
  - 系统用户：用于运行系统服务

### 2. 用户管理命令

#### 查看用户信息
```bash
# 查看当前用户
whoami

# 查看所有登录用户
who

# 查看用户详细信息
id username

# 查看用户列表
cat /etc/passwd
```

#### 用户管理
```bash
# 添加用户
useradd username

# 设置用户密码
passwd username

# 删除用户
userdel username

# 修改用户信息
usermod -s /bin/bash username
```

### 3. 权限管理

#### 文件权限类型
- **读权限（r）**：4
- **写权限（w）**：2
- **执行权限（x）**：1

#### 查看文件权限
```bash
# 查看文件详细信息
ls -l filename

# 查看目录权限
ls -ld directoryname
```

#### 修改文件权限
```bash
# 使用数字方式修改权限
chmod 755 filename

# 使用符号方式修改权限
chmod u+rwx,g+rx,o+r filename

# 修改文件所有者
chown username filename

# 修改文件所属组
chgrp groupname filename
```

### 4. 用户组管理

#### 组管理命令
```bash
# 查看用户组
cat /etc/group

# 添加用户组
groupadd groupname

# 删除用户组
groupdel groupname

# 将用户添加到组
usermod -a -G groupname username
```

### 5. 特殊权限

#### SUID权限
```bash
# 设置SUID权限
chmod u+s filename
```

#### SGID权限
```bash
# 设置SGID权限
chmod g+s directoryname
```

#### 粘滞位（Sticky Bit）
```bash
# 设置粘滞位
chmod +t directoryname
```

### 6. 实践练习

#### 创建用户和组
```bash
# 创建用户组
groupadd developers

# 创建用户并添加到组
useradd -g developers -m -s /bin/bash developer1
passwd developer1

# 创建多个用户
useradd -g developers -m -s /bin/bash developer2
passwd developer2
```

#### 设置项目目录权限
```bash
# 创建项目目录
mkdir /home/developers

# 设置目录权限
chown root:developers /home/developers
chmod 775 /home/developers

# 设置粘滞位
chmod +t /home/developers
```

### 7. 权限故障排除

#### 常见权限问题
- **权限不足**：检查文件/目录权限设置
- **无法执行脚本**：确保脚本有执行权限
- **无法访问目录**：检查目录的读和执行权限

#### 权限检查命令
```bash
# 检查文件权限
ls -l filename

# 检查目录权限
ls -ld directoryname

# 检查用户所属组
groups username
```

### 8. 课后作业
1. 创建一个名为"students"的用户组
2. 添加3个用户到该组
3. 创建一个共享目录，设置适当的权限
4. 练习使用chmod命令修改文件权限
5. 理解SUID、SGID和粘滞位的作用