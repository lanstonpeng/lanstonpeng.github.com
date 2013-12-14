---
author: lanstonpeng
comments: true
date: 2011-04-25 16:30:20+00:00
layout: post
slug: pythonchallenge-level13-%e4%bb%a5%e5%8f%8a%e4%bb%8e%e4%b8%ad%e5%ad%a6%e5%88%b0%e7%9a%84%e4%b8%9c%e8%a5%bflinux-%e5%85%b7%e4%bd%93%e6%96%87%e4%bb%b6%e7%b1%bb%e5%9e%8b%e7%9a%84%e8%af%86%e5%88%ab
title: pythonchallenge level13 以及从中学到的东西(linux 具体文件类型的识别)
wordpress_id: 481
categories:
- 未分类
tag:
- linux
- python
---

在感冒与发烧的交加中，level13足够坑爹的说
我承认我的洞察能力有所提升了，但是依旧是被坑了，本关给出一个文件，然后你以2进制打开它。

    
    for in in range(5):
      each=source[i::5]  #看图得出
      open("pic_1"+str(i),"w" ).write(each)



    
    <span style="font-family: Georgia, 'Times New Roman', 'Bitstream Charter', Times, serif; line-height: 19px;"><!-- more -->
    </span>



    
    <span style="font-family: Georgia, 'Times New Roman', 'Bitstream Charter', Times, serif; line-height: 19px;">类似这样，关键代码就出来了</span>


这样就是将那一堆的二进制代码进行分割，然后重组，最后形成几张独立的图片，然后从图片中读出答案：disproportional

[![](http://files.blogcn.com/wp06/M00/00/CE/wKgKDE3Y-XgAAAAAAAEkSQp10R8235.png)](http://files.blogcn.com/wp05/M00/00/8E/wKgKDE3Y-XYAAAAAAAb2XSfn2Wg203.png)






思考：




我在想，为什么linux能识别到我们具体的文件类型呢？（并非简单的 . , d, c ,b 等）




经过gzlug上的几位大神的帮助，原来是这样的




首先，我们可以通过file来识别文件的类型







    
    >>file p_2,jpg
    p_2,jpg: PNG image, 400 x 300, 8-bit/color RGB, non-interlaced


这里可以看到文件的类型
再进一步
通过查看


### **/usr/share/mime**


里面的规范文件
可以发现其实里面都定义了所有文件类型
譬如我们最熟悉的文本文件
打开 text/plain.xml,可以看到下面的东西：


<?xml version="1.0" encoding="utf-8"?>




<mime-type xmlns="http://www.freedesktop.org/standards/shared-mime-info" type="text/plain">




<!--Created automatically by update-mime-database. DO NOT EDIT!-->




<comment>plain text document</comment>




<comment xml:lang="ara">مستند نصي مجرد</comment>




.......................




<comment xml:lang="zh_CN">纯文本文档</comment>




<comment xml:lang="zh_TW">普通文本檔</comment>




<glob pattern="*.txt"/>




<glob pattern="*.asc"/>




<glob pattern="*,v"/>




<glob pattern="*.doc"/>




</mime-type>




继续我们的讨论，那么对于不同的软件（程序）可以打开不同的文件的规范就定义在




### /usr/share/applications




里面的那些desktop文件




当我们打开gedit.desktop可以发现这么一行




MimeType=text/plain




相信做过web开发对这个MimeType的不会陌生吧，即使不知道这个名字，对




诸如text/plain这些还是熟悉的吧




最后附上这个规范的doc:[http://standards.freedesktop.org/shared-mime-info-spec/shared-mime-info-spec-latest.html](http://standards.freedesktop.org/shared-mime-info-spec/shared-mime-info-spec-latest.html)




(BTW:其实在那些xml文件里面也有)
