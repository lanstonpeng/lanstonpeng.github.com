---
author: lanstonpeng
comments: true
date: 2011-01-12 11:39:37+00:00
layout: post
slug: ubuntu%e4%b8%8b%e8%ae%be%e7%bd%aetelnet%e6%9c%8d%e5%8a%a1%e5%99%a8
title: Ubuntu下设置telnet与ssh服务器
wordpress_id: 235
categories:
- 未分类
tag:
- linux
- my try
---

[](http://www.lanstonpeng.tk/files/2011/01/Screenshot-6.png)
[](http://www.lanstonpeng.tk/files/2011/01/Screenshot-7.png)为了迎接寒假的服务器初配,小生俺在考试前学学

好了,首先查看一下机子是否有telnet服务,使用命令 netstat -l 查看机子的正在监听端口的连接


root@poc-laptop:/etc# netstat -l




激活Internet连接 (仅服务器)




Proto Recv-Q Send-Q Local Address           Foreign Address         State




tcp        0      0 *:ssh                   *:*                     LISTEN




tcp        0      0 localhost.localdoma:ipp *:*                     LISTEN




tcp6       0      0 [::]:ssh                [::]:*                  LISTEN




tcp6       0      0 poc-laptop:ipp          [::]:*                  LISTEN




udp        0      0 *:bootpc                *:*




udp        0      0 *:37081                 *:*




udp        0      0 *:mdns                  *:*




udp        0      0 *:50000                 *:*




udp        0      0 *:50001                 *:*




udp6       0      0 [::]:48790              [::]:*




udp6       0      0 [::]:mdns               [::]:*<!-- more -->


我的ubuntu没有装telnet(telnet这么不安全为什么要装呢?我是菜鸟,我想试试,接下来才是ssh)

![](http://www.lanstonpeng.tk/files/2011/01/Screenshot-6.png-1024x575.png)

[![](http://www.lanstonpeng.tk/files/2011/01/Screenshot-5.png)](http://www.lanstonpeng.tk/files/2011/01/Screenshot-5.png)










上图是我的一个测试,关键是配置好你的文件,上网查了查资料,不难.配置 /etc/xinetd.conf 以及 /etc/xinetd.d/telnet 文件,具体也就不列出来了,




但是我在发送消息的时候,遇到中文就回出现类似乱码的东西,后来在man中发现了: The write utility does not recognize multibyte characters.




(不支持多字节的字符)




好了,到ssh了,它是采用非对称加密的,安全性比ASCII的telnet好多了




本人的ubuntu也没有装上ssh




所以就得敲入  : sudo apt-get install ssh-server ssh-client




来安装了ssh的服务器端与客户端




安装好就直接可以用了,有几点要注意一下:




因为本人没有设置允许登录,Ubuntu安装后，root用户默认是被锁定了的，不允许登录的,于是我在ssh了之后得直接去sudo -i 下










下面是我登录了两个时显示的信息:











poc@poc-laptop:~$ w




19:28:26 up  1:17,  7 users,  load average: 0.67, 0.63, 0.68




USER     TTY      FROM              LOGIN@   IDLE   JCPU   PCPU WHAT




poc      tty7     :0               18:11    1:17m  8:16   0.27s x-session-manag




poc      pts/0    :0.0             18:12   16:59   0.69s 16.27s gnome-terminal




poc      pts/2    :0.0             19:15    4:17   0.29s  0.01s ssh localhost




poc      pts/3    poc-laptop       19:24    4:14   0.45s  0.45s -bash




poc      pts/4    :0.0             19:24    0.00s  0.23s  0.00s w




poc      pts/5    :0.0             19:25   23.00s  0.25s  0.01s ssh localhost




poc      pts/6    poc-laptop       19:28   20.00s  0.44s  0.44s -bash




当然,更加具体的设定在之后的学习中,包括设置防火墙,过滤某些东西等


ssh的配置信息主要在/etc/ssh/sshd_config 配置文件里面,譬如修改里面的PermitRootLogin ,可设置是否允许root登录...







