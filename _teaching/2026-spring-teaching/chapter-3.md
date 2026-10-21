---
title: "Linux软件安装和包管理"
collection: teaching
chapter: true
chapter_order: 3
type: "Undergraduate course"
permalink: /teaching/2026-spring-teaching/chapter-3
venue: "常州工业职业技术学院, 信息工程学院"
date: 2026-03-01
location: "Changzhou, China"
---

## Linux软件安装和包管理

### 1. 软件包管理器介绍
- **RPM包管理器**：Red Hat Package Manager，用于安装、更新和删除RPM格式的软件包
- **YUM包管理器**：Yellowdog Updater Modified，基于RPM的高级包管理器
- **DNF包管理器**：Dandified YUM，YUM的下一代版本，性能更好

### 2. 常用软件包管理命令

#### RPM命令
```bash
# 安装RPM包
rpm -ivh package_name.rpm

# 查看已安装的软件包
rpm -qa

# 查看软件包信息
rpm -qi package_name

# 卸载软件包
rpm -e package_name
```

#### YUM/DNF命令
```bash
# 更新系统
yum update
# 或者使用DNF
dnf update

# 安装软件包
yum install package_name
# 或者使用DNF
dnf install package_name

# 搜索软件包
yum search keyword
# 或者使用DNF
dnf search keyword

# 查看已安装的软件包
yum list installed
# 或者使用DNF
dnf list installed

# 卸载软件包
yum remove package_name
# 或者使用DNF
dnf remove package_name
```

### 3. 源码编译安装
```bash
# 下载源码包
wget http://example.com/package.tar.gz

# 解压源码包
tar -zxvf package.tar.gz

# 进入源码目录
cd package_directory

# 配置编译选项
./configure

# 编译源码
make

# 安装编译结果
make install
```

### 4. 实践练习
请下载并安装以下软件：
- wget：用于从网络下载文件
- htop：系统监控工具
- git：版本控制系统

使用以下命令进行安装：
```bash
# 安装wget
yum install wget

# 安装htop
yum install htop

# 安装git
yum install git
```

### 5. 软件仓库配置
- **默认仓库**：系统自带的软件仓库
- **EPEL仓库**：Extra Packages for Enterprise Linux，提供更多软件包
- **第三方仓库**：如RPM Fusion等

添加EPEL仓库：
```bash
yum install epel-release
# 或者使用DNF
dnf install epel-release
```

### 6. 故障排除
- **依赖问题**：使用`yum deplist package_name`查看依赖关系
- **冲突问题**：使用`yum check`检查包冲突
- **损坏的包**：使用`yum reinstall package_name`重新安装

### 7. 课后作业
1. 安装并配置一个Web服务器（如Apache或Nginx）
2. 学习使用`systemctl`命令管理服务
3. 尝试从源码编译安装一个简单的程序