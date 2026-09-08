#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
plain='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}致命错误: ${plain} 请使用 root 权限运行此脚本\n" && exit 1

# ----------------------------------------------------------
# 函数：免费版安装逻辑
# ----------------------------------------------------------
install_free_version() {
    echo ""
    echo -e "${green}正在安装 TYKJ-Panel ...${plain}"
    echo ""
    sleep 2

    cur_dir=$(pwd)

    # Check OS and set release variable
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        release=$ID
    elif [[ -f /usr/lib/os-release ]]; then
        source /usr/lib/os-release
        release=$ID
    else
        echo ""
        echo -e "${red}检查服务器操作系统失败，请联系作者!${plain}" >&2
        exit 1
    fi
    echo ""
    echo -e "${green}---------->>>>>目前服务器的操作系统为: $release${plain}"

    arch() {
        case "$(uname -m)" in
            x86_64 | x64 | amd64 ) echo 'amd64' ;;
            i*86 | x86 ) echo '386' ;;
            armv8* | armv8 | arm64 | aarch64 ) echo 'arm64' ;;
            armv7* | armv7 | arm ) echo 'armv7' ;;
            armv6* | armv6 ) echo 'armv6' ;;
            armv5* | armv5 ) echo 'armv5' ;;
            s390x) echo 's390x' ;;
            *) echo -e "${green}不支持的CPU架构! ${plain}" && rm -f install.sh && exit 1 ;;
        esac
    }

    echo ""
    echo -e "${yellow}---------->>>>>当前系统的架构为: $(arch)${plain}"
    echo ""

    # 从你的 GitHub Releases 获取版本号
    last_version="db6b3fd"

    # 检查是否已安装
    xui_version=$(/usr/local/x-ui/x-ui -v 2>/dev/null)

    if [[ -z "$xui_version" ]]; then
        echo ""
        echo -e "${red}------>>>当前服务器没有安装任何代理面板${plain}"
        echo ""
        echo -e "${green}-------->>>>开始安装 TYKJ-Panel${plain}"
    else
        echo -e "${green}---------->>>>>检测到已安装版本: ${xui_version}${plain}"
        echo -e "${green}-------->>>>即将进行更新${plain}"
    fi
    echo ""
    echo -e "${yellow}---------------------->>>>>当前版本：${last_version}${plain}"
    sleep 2

    os_version=$(grep -i version_id /etc/os-release | cut -d \" -f2 | cut -d . -f1)

    if [[ "${release}" == "arch" ]]; then
        echo "您的操作系统是 ArchLinux"
    elif [[ "${release}" == "manjaro" ]]; then
        echo "您的操作系统是 Manjaro"
    elif [[ "${release}" == "armbian" ]]; then
        echo "您的操作系统是 Armbian"
    elif [[ "${release}" == "alpine" ]]; then
        echo "您的操作系统是 Alpine Linux"
    elif [[ "${release}" == "opensuse-tumbleweed" ]]; then
        echo "您的操作系统是 OpenSUSE Tumbleweed"
    elif [[ "${release}" == "centos" ]]; then
        if [[ ${os_version} -lt 8 ]]; then
            echo -e "${red} 请使用 CentOS 8 或更高版本 ${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "ubuntu" ]]; then
        if [[ ${os_version} -lt 20 ]]; then
            echo -e "${red} 请使用 Ubuntu 20 或更高版本!${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "fedora" ]]; then
        if [[ ${os_version} -lt 36 ]]; then
            echo -e "${red} 请使用 Fedora 36 或更高版本!${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "debian" ]]; then
        if [[ ${os_version} -lt 11 ]]; then
            echo -e "${red} 请使用 Debian 11 或更高版本 ${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "almalinux" ]]; then
        if [[ ${os_version} -lt 9 ]]; then
            echo -e "${red} 请使用 AlmaLinux 9 或更高版本 ${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "rocky" ]]; then
        if [[ ${os_version} -lt 9 ]]; then
            echo -e "${red} 请使用 RockyLinux 9 或更高版本 ${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "oracle" ]]; then
        if [[ ${os_version} -lt 8 ]]; then
            echo -e "${red} 请使用 Oracle Linux 8 或更高版本 ${plain}\n" && exit 1
        fi
    else
        echo -e "${red}此脚本不支持您的操作系统。${plain}\n"
        echo "请确保您使用的是以下受支持的操作系统之一："
        echo "- Ubuntu 20.04+"
        echo "- Debian 11+"
        echo "- CentOS 8+"
        echo "- Fedora 36+"
        echo "- Arch Linux"
        echo "- Manjaro"
        echo "- Armbian"
        echo "- Alpine Linux"
        echo "- AlmaLinux 9+"
        echo "- Rocky Linux 9+"
        echo "- Oracle Linux 8+"
        echo "- OpenSUSE Tumbleweed"
        exit 1
    fi

    install_base() {
        case "${release}" in
        ubuntu | debian | armbian)
            apt-get update && apt-get install -y -q wget curl sudo tar tzdata
            ;;
        centos | rhel | almalinux | rocky | ol)
            yum -y --exclude=kernel* update && yum install -y -q wget curl sudo tar tzdata
            ;;
        fedora | amzn | virtuozzo)
            dnf -y --exclude=kernel* update && dnf install -y -q wget curl sudo tar tzdata
            ;;
        arch | manjaro | parch)
            pacman -Sy && pacman -S --noconfirm wget curl sudo tar tzdata
            ;;
        alpine)
            apk update && apk add --no-cache wget curl sudo tar tzdata
            ;;
        opensuse-tumbleweed)
            zypper refresh && zypper -q install -y wget curl sudo tar timezone
            ;;
        *)
            apt-get update && apt-get install -y -q wget curl sudo tar tzdata
            ;;
        esac
    }

    gen_random_string() {
        local length="$1"
        local random_string=$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w "$length" | head -n 1)
        echo "$random_string"
    }

    config_after_install() {
        echo -e "${yellow}安装/更新完成！为了您的面板安全，建议修改面板设置${plain}"
        echo ""
        read -p "$(echo -e "${green}是否修改面板设置？${red}[y/n]${plain}：")" config_confirm
        if [[ "${config_confirm}" == "y" || "${config_confirm}" == "Y" ]]; then
            read -p "请设置您的用户名: " config_account
            echo -e "${yellow}您的用户名将是: ${config_account}${plain}"
            read -p "请设置您的密码: " config_password
            echo -e "${yellow}您的密码将是: ${config_password}${plain}"
            read -p "请设置面板端口: " config_port
            echo -e "${yellow}您的面板端口号为: ${config_port}${plain}"
            read -p "请设置面板登录访问路径: " config_webBasePath
            echo -e "${yellow}您的面板访问路径为: ${config_webBasePath}${plain}"
            echo -e "${yellow}正在初始化，请稍候...${plain}"
            /usr/local/x-ui/x-ui setting -username ${config_account} -password ${config_password}
            echo -e "${yellow}用户名和密码设置成功!${plain}"
            /usr/local/x-ui/x-ui setting -port ${config_port}
            echo -e "${yellow}面板端口号设置成功!${plain}"
            /usr/local/x-ui/x-ui setting -webBasePath ${config_webBasePath}
            echo -e "${yellow}面板登录访问路径设置成功!${plain}"
            echo ""
        else
            echo ""
            sleep 1
            echo -e "${red}--------------->>>>取消修改...${plain}"
            echo ""
            if [[ ! -f "/etc/x-ui/x-ui.db" ]]; then
                local usernameTemp=$(head -c 10 /dev/urandom | base64)
                local passwordTemp=$(head -c 10 /dev/urandom | base64)
                local webBasePathTemp=$(gen_random_string 15)
                /usr/local/x-ui/x-ui setting -username ${usernameTemp} -password ${passwordTemp} -webBasePath ${webBasePathTemp}
                echo ""
                echo -e "${yellow}检测到为全新安装，生成随机登录信息:${plain}"
                echo -e "###############################################"
                echo -e "${green}用户名: ${usernameTemp}${plain}"
                echo -e "${green}密  码: ${passwordTemp}${plain}"
                echo -e "${green}访问路径: ${webBasePathTemp}${plain}"
                echo -e "###############################################"
                echo -e "${green}如忘记登录信息，可通过 x-ui 命令查看${plain}"
            else
                echo -e "${green}此次为版本升级，保留之前设置${plain}"
            fi
        fi
        sleep 1
        echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo ""
        /usr/local/x-ui/x-ui migrate
    }

    echo ""
    install_x-ui() {
        cd /usr/local/

        if [ $# == 0 ]; then
            last_version="db6b3fd"
            echo ""
            echo -e "-----------------------------------------------------"
            echo -e "${green}--------->>安装 TYKJ-Panel 版本：${yellow}${last_version}${plain}${green}${plain}"
            echo -e "-----------------------------------------------------"
            echo ""
            sleep 2
            echo -e "${green}---------------->>>>>>>>>安装进度50%${plain}"
            sleep 2
            echo ""
            echo -e "${green}---------------->>>>>>>>>>>>>>>>>>>>>安装进度100%${plain}"
            echo ""
            sleep 2
            wget -N --no-check-certificate -O /usr/local/x-ui-linux-$(arch).tar.gz https://github.com/TYKJ749/X-Panel/releases/download/db6b3fd/x-ui-linux-$(arch).tar.gz
            if [[ $? -ne 0 ]]; then
                echo -e "${red}下载失败，请检查网络连接${plain}"
                exit 1
            fi
        else
            last_version=$1
            url="https://github.com/TYKJ749/X-Panel/releases/download/db6b3fd/x-ui-linux-$(arch).tar.gz"
            echo ""
            echo -e "--------------------------------------------"
            echo -e "${green}---------------->>>>安装 TYKJ-Panel $1${plain}"
            echo -e "--------------------------------------------"
            echo ""
            sleep 2
            echo -e "${green}---------------->>>>>>>>>安装进度50%${plain}"
            sleep 2
            echo ""
            echo -e "${green}---------------->>>>>>>>>>>>>>>>>>>>>安装进度100%${plain}"
            echo ""
            sleep 2
            wget -N --no-check-certificate -O /usr/local/x-ui-linux-$(arch).tar.gz ${url}
            if [[ $? -ne 0 ]]; then
                echo -e "${red}下载 TYKJ-Panel $1 失败${plain}"
                exit 1
            fi
        fi

        cp -f x-ui/x-ui.sh /usr/bin/x-ui-temp
        if [[ -e /usr/local/x-ui/ ]]; then
            systemctl stop x-ui
            rm /usr/local/x-ui/ -rf
        fi
        
        sleep 2
        echo -e "${green}------->>>>>>>>>>>解压安装中...${plain}"
        echo ""
        tar zxvf x-ui-linux-$(arch).tar.gz
        rm x-ui-linux-$(arch).tar.gz -f
        
        cd x-ui
        chmod +x x-ui
        chmod +x x-ui.sh

        if [[ $(arch) == "armv5" || $(arch) == "armv6" || $(arch) == "armv7" ]]; then
            mv bin/xray-linux-$(arch) bin/xray-linux-arm
            chmod +x bin/xray-linux-arm
        fi
        chmod +x x-ui bin/xray-linux-$(arch)

        mv -f /usr/bin/x-ui-temp /usr/bin/x-ui
        chmod +x /usr/bin/x-ui
        sleep 2
        echo -e "${green}------->>>>>>>>>>>安装成功${plain}"
        sleep 2
        echo ""
        config_after_install

        cp -f x-ui.service /etc/systemd/system/
        systemctl daemon-reload
        systemctl enable x-ui
        systemctl start x-ui

        echo ""
        echo -e "------->>>>${green}TYKJ-Panel ${last_version}${plain}<<<<安装成功，正在启动..."
        sleep 1
        echo ""
        echo -e "         ---------------------"
        echo -e "         |${green}TYKJ-Panel 控制菜单 ${plain}|${plain}"
        echo -e "         |  ${yellow}基于Xray Core构建   ${plain}|${plain}"  
        echo -e "--------------------------------------------"
        echo -e "x-ui              - 进入管理脚本"
        echo -e "x-ui start        - 启动面板"
        echo -e "x-ui stop         - 关闭面板"
        echo -e "x-ui restart      - 重启面板"
        echo -e "x-ui status       - 查看面板状态"
        echo -e "x-ui settings     - 查看当前设置"
        echo -e "x-ui enable       - 启用开机启动"
        echo -e "x-ui disable      - 禁用开机启动"
        echo -e "x-ui log          - 查看运行日志"
        echo -e "x-ui update       - 更新面板"
        echo -e "x-ui install      - 安装面板"
        echo -e "x-ui uninstall    - 卸载面板"
        echo -e "--------------------------------------------"
        echo ""
        sleep 2
        echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo ""
        echo -e "${yellow}----->>>TYKJ-Panel 启动成功<<<-----${plain}"
    }

    # 设置时区为上海时间
    sudo timedatectl set-timezone Asia/Shanghai

    install_base
    install_x-ui $1
    echo ""
    echo -e "----------------------------------------------"
    sleep 3
    info=$(/usr/local/x-ui/x-ui setting -show true)
    echo -e "${info}${plain}"
    echo ""
    echo -e "----------------------------------------------"
    echo ""
    sleep 2
    echo -e "${green}安装/更新完成！${plain}"
    echo ""
    echo -e "${green}项目地址：${yellow}https://github.com/TYKJ749/X-Panel${plain}"
    echo ""
    echo -e "${green}交流群：${yellow}https://t.me/TYwl_857${plain}"
    echo ""
    echo -e "${green}作者：${yellow}https://t.me/TY_749${plain}"
    echo ""
    echo -e "----------------------------------------------"
    echo ""
}

# ----------------------------------------------------------
# 脚本执行入口
# ----------------------------------------------------------
clear
install_free_version
