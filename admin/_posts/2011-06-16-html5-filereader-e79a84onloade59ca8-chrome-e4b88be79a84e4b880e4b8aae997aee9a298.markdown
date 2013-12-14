---
author: lanstonpeng
comments: true
date: 2011-06-16 12:31:04+00:00
layout: post
slug: html5-filereader-%e7%9a%84onload%e5%9c%a8-chrome-%e4%b8%8b%e7%9a%84%e4%b8%80%e4%b8%aa%e9%97%ae%e9%a2%98
title: HTML5 FileReader 的onload在 chrome 下的一个问题
wordpress_id: 552
categories:
- 未分类
tag:
- javascript
- my try
---

我在 chromium12 打算测试一下HTML5的[File API](http://www.w3.org/TR/file-upload/)，奇怪的是 **onload** 事件没有fire，FF 3.6,Opera11也是好好的

谷了又栈了，其实这是一个很简单的问题，[stack](http://stackoverflow.com/questions/5749530/html5-and-file-api-in-chrome-problem)上一个家伙自问自答，因为我们本地测试的话打开一个html页面是当作一个file，我觉得是因为协议的不同导致某些特性没有“激发”出来,其解决方法就是用http的方式访问这个文件了

如果有装个apache或着什么服务器的话可以直接拖你的文件进入类似htdoc,wwwroot的文件夹中，然后 **localhost:your port ** 或者**192.168.0.1:your** port

这里为没有以上装备的朋友提供一个更加简单的方法，就是：

1)你的Terminal中输入 python -m [** SimpleHTTPServer**](http://docs.python.org/library/simplehttpserver.html)

2)将你的测试文件改为index.html

或者装个nginx在win中，很简单的测试，

当然，你也可以不开个Server，在**[HTML5Rocks](http://www.html5rocks.com/en/tutorials/file/filesystem/)**上的教程由这么一句话****

****You may need the **--allow-file-access-from-files** flag if you're debugging your app from **file://** . Not using these flags will result in a **SECURITY_ERR** or **QUOTA_EXCEEDED_ERR** FileError****

**** ****

**** ****
