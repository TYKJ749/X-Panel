**---------------------------------------一个更好的面板 • 基于Xray Core构建------------------------------**

[![](https://img.shields.io/github/v/release/xeefei/x-panel.svg?style=for-the-badge)](https://github.com/xeefei/x-panel/releases)
[![](https://img.shields.io/github/actions/workflow/status/xeefei/x-panel/release.yml.svg?style=for-the-badge)](https://github.com/xeefei/x-panel/actions)
[![GO Version](https://img.shields.io/github/go-mod/go-version/xeefei/x-panel.svg?style=for-the-badge)](#)
[![Downloads](https://img.shields.io/github/downloads/xeefei/x-panel/total.svg?style=for-the-badge)](https://github.com/xeefei/x-panel/releases/latest)
[![License](https://img.shields.io/badge/license-GPL%20V3-blue.svg?longCache=true&style=for-the-badge)](https://www.gnu.org/licenses/gpl-3.0.en.html)

> **声明：** 此项目仅供个人学习、交流使用，请遵守当地法律法规，勿用于非法用途；请勿用于生产环境。

> **注意：** 在使用此项目和〔教程〕过程中，若因违反以上声明使用规则而产生的一切后果由使用者自负。

**如果此项目对你有用，请给一个**:star2:

##
PS：〔天耀科技〕站长：https://t.me/TY_749
PS：〔天耀科技〕交流群：https://t.me/TYwl_857
PS：〔天耀科技〕海外商城：https://sc.0kle.cc
##
PS：〔天耀科技〕支付平台：https://pay.0kle.cc
PS：〔天耀科技〕AI中转站：https://ai.0kle.cn
PS：〔天耀科技〕教程博客：https://bk.0kle.cn
##
PS：〔天耀科技〕服务器网站：https://idc.0kle.cn

------------
本文教程：
------------
## ✰如何从其他x-ui版本迁移到〔X-Panel面板〕？✰
#### 1、若你用的是伊朗老哥的3X-UI，是可以直接〔覆盖安装〕的，因为数据库文件等位置是没有改变的，所以直接覆盖安装，并不会影响你〔原有节点及配置〕等数据；安装命令如下：
```
bash <(curl -Ls https://raw.githubusercontent.com/xeefei/x-panel/master/install.sh)
```
#### 2、若你之前用的是Docker方式安装，那先进入容器里面/命令：docker exec -it 容器id /bin/sh，再执行以上脚本命令直接【覆盖安装】即可，
#### 3、若你用的是之前F佬的x-ui或者其他分支版本，那直接覆盖安装的话，并不能确保一定就能够兼容？建议你先去备份〔数据库〕配置文件，再进行安装〔X-Panel面板〕。


------------
## 安装之前的准备
- 购买一台性能还不错的VPS，可通过站长自己的服务器网站购买PS：〔天耀科技〕服务器网站：https://idc.0kle.cn
- PS：若你不想升级系统，则可以跳过此步骤。
- 若你需要更新/升级系统，Debian系统可用如下命令：
  ```
  apt update
  apt upgrade -y
  apt dist-upgrade -y
  apt autoclean
  apt autoremove -y
  ```
- 查看系统当前版本：
  ```
  cat /etc/debian_version
  ```
- 查看内核版本：
  ```
  uname -r
  ```
- 列出所有内核：
  ```
  dpkg --list | grep linux-image
  ```
- 更新完成后执行重新引导：
  ```
  update-grub
  ```
- 完成以上步骤之后输入reboot重启系统

------------
## 【搬瓦工】重装/升级系统之后SSH连不上如何解决？
- 【搬瓦工】重装/升级系统会恢复默认22端口，如果需要修改SSH的端口号，您需要进行以下步骤：
- 以管理员身份使用默认22端口登录到SSH服务器
- 打开SSH服务器的配置文件进行编辑，SSH配置文件通常位于/etc/ssh/sshd_config
- 找到"Port"选项，并将其更改为您想要的端口号
- Port <新端口号>，请将<新端口号>替换为您想要使用的端口号
- 保存文件并退出编辑器
- 重启服务器以使更改生效

------------
## 安装 & 升级
- 使用〔X-Panel面板〕脚本一般情况下，安装完成创建入站之后，端口是默认关闭的，所以必须进入脚本选择【22】去放行端口
- 要使用【自动续签】证书功能，也必须放行【80】端口，保持80端口是打开的，才会每3个月自动续签一次

- 【全新安装】请执行以下脚本：
```
bash <curl -Ls https://raw.githubusercontent.com/TYKJ749/X-Panel/main/install.sh)
```
#### 如果执行了上面的代码但是报错，证明你的系统里面没有curl这个软件，请执行以下命令先安装curl软件，安装curl之后再去执行上面代码，
```
apt update -y&&apt install -y curl&&apt install -y socat
```

```
VERSION=v26.2.15 && bash <curl -Ls "bash <curl -Ls https://raw.githubusercontent.com/TYKJ749/X-Panel/main/install.sh" $VERSION
```
------------
## 若你的VPS默认有防火墙，请在安装完成之后放行指定端口
- 放行【面板登录端口】
- 放行出入站管理协议端口
- 如果要申请安装证书并每3个月【自动续签】证书，请确保80和443端口是放行打开的
- 可通过此脚本的第【21】选项去安装防火墙进行管理，如下图：
![9](./media/9.png)
- 若要一次性放行多个端口或一整个段的端口，用英文逗号隔开。
#### PS：若你的VPS没有防火墙，则所有端口都是能够ping通的，可自行选择是否进入脚本安装防火墙保证安全，但安装了防火墙必须放行相应端口。


## Languages

- English（英语）
- Farsi（伊朗语）
- Simplified Chinese（简体中文）
- Traditional Chinese（繁体中文）            
- Russian（俄语）
- Vietnamese（越南语）
- Spanish（西班牙语）
- Indonesian （印度尼西亚语）
- Ukrainian（乌克兰语）
- Turkish（土耳其语）
- Português (葡萄牙语)

------------
## 项目特点

- 系统状态查看与监控
- 可搜索所有入站和客户端信息
- 深色/浅色主题随意切换
- 支持多用户和多协议
- 支持多种协议，包括 VMess、VLESS、Trojan、Shadowsocks、Dokodemo-door、Socks、HTTP、wireguard
- 支持 XTLS 原生协议，包括 RPRX-Direct、Vision、REALITY
- 流量统计、流量限制、过期时间限制
- 可自定义的 Xray配置模板
- 支持HTTPS访问面板（自备域名+SSL证书）
- 支持一键式SSL证书申请和自动续签证书
- 更多高级配置项目请参考面板去进行设定
- 修复了 API 路由（用户设置将使用 API 创建）
- 支持通过面板中提供的不同项目更改配置。
- 支持从面板导出/导入数据库


  - 您需要在Xray配置中手动设置〔访问日志〕的路径。

</details>

