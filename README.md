# kael
Linux 平台下部署管理 Java Web(war包) / J2SE(jar包) 项目的工具包。


## 你现在所处的环境是否适合使用 kael ?
- 如果你所在的公司是一个创业公司。  
- 如果你所在的团队是公司里的一个小团队，公司并没有一个统一且完善的运维平台供各团队（部门）使用。
- 你是一个运维，每天有大量的重复性工作：
   - 安装一个基础的 Java 运行环境。
   - 将 Java 发布包（jar/war）包上传至服务器，并部署启动。
   - 一台机器上部署多个 Java 项目，你经常要处理不同的项目之间相互影响的问题。
   - 在某些糟糕的情况下，你需要回退至某个历史版本。
- 如果你自己尝试做一个小项目（或者是一个测试项目，或个人项目），需要快速部署到 Linux 下。

如果你处在以上情况（不仅限于此），没有容器化 docker 或不想那么你可以尝试一下 kael 来帮助你摆脱烦恼。


## 组件介绍
kael 由几个不同作用的主要组件构成，以下为不同组件的基本功能介绍：
- **kael-pre-install**。安装软件包的基础运行环境，如安装程序 nginx、tomcat、jdk，创建程序运行用户，规划程序运行的环境目录（程序包发布目录、日志运行目录、常用工具包目录等）。
- **update**。软件运维全生命周期：打包、上传、分发、发布、启停。
- **mservice**。独立 jar 包启停工具。（最初是团队转向微服务架构时，为了管理使用spring boot/spring cloud开发的jar包）
