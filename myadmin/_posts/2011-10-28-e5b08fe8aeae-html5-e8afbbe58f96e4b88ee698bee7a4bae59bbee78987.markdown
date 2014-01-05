---
author: lanstonpeng
comments: true
date: 2011-10-28 05:22:08+00:00
layout: post
slug: '%e5%b0%8f%e8%ae%ae-html5-%e8%af%bb%e5%8f%96%e4%b8%8e%e6%98%be%e7%a4%ba%e5%9b%be%e7%89%87'
title: 小议 HTML5 读取与显示图片
wordpress_id: 605
categories:
- 未分类
tag:
- html5
- javascript
---

[](http://files.blogcn.com/wp06/M00/01/75/wKgKDU6qS_4AAAAAAAA32wmVtGU567.png)在有空的时候回顾了一下之前学的，可以说生成上传图片的缩略图这是一个很普遍的需求了，以下收集两个方法

**1.应用较为广泛的方法**

以下是代码片段，我就直接上图(插件什么的色彩都是那么黯淡)，下面是代码片段

[![](http://files.blogcn.com/wp03/M00/02/D4/wKgKCk6pNlEAAAAAAACbTTTPy0Q382.png)](http://files.blogcn.com/wp03/M00/02/D4/wKgKCk6pNlEAAAAAAACbTTTPy0Q382.png)

` `

好吧，其实是下午敲出来的，因为有半天的空闲时间，所以抓紧时间学一下，上面的代码没有什么特别的地方（而且bug多多的说）,主要是展示核心，这里是采用拖拽图片"上传"，

所以看到这里是e.dataTransfer.files[0]

可以看到img.src的内容为base64的raw data

今天索引式的学习让俺重新认识了Canvas 的**toDataURL()**这个东西，要说这个东西就得牵涉到Blob，又牵涉到File API的东西<!-- more -->

[![](http://files.blogcn.com/wp04/M00/02/95/wKgKDU6pP_0AAAAAAAIQXmZiKOg907.png)](http://files.blogcn.com/wp04/M00/02/95/wKgKDU6pP_0AAAAAAAIQXmZiKOg907.png)

这里的读取图片的方式是采用传统的表单控件上传，所以可以看到是e.target.files[0]

**createObjectURL是建立一个file 对象的URL地址，其生命周期跟document相同**

返回结果:

    
    blob:http%3A%2F%2F127.0.0.1/1450f212-cb1e-4739-a47b-8dd0820c572b


可以看到这里是 blob 开头的，输入这个内容到浏览器的地址栏里面，图片就会显示出来,假设我关掉主页面，那么再次刷新这个blob页面，图片资源就不存在了

当然，可以看到在上面的代码中我在图片onload的时候去除掉这个资源钩子，即便你不关闭页面，输入这个资源地址其也不会显示图片，但这个究竟是消耗多少资源呢这个我没找到，测试也没有什么比较突破的结果，只是为了内存资源的更好的利用，在

不用的时候释放就好了

**几点说明：**

1.这个blob地址（姑且让我这么对其命名）是唯一的，即你对一个图片同时调用多次 createObjectURL 会返回不同的地址

2.chromium不能在本地环境测试


win的话我是用HomeWebServer




arch的话直接python不解释


**延伸思考:**

既然这个Blob地址代表的是一个页面上的一个资源，那么其是否会存在其它好玩的地方呢？

首先，这个资源必须是“动态”导入的，之前我一直在想有没有办法获取页面上面的已经生成的静态内容，一直没有结果，虽然理论上我认为是可行的

说到这里，首先想到的当然是script了

What about [WebWorker](https://developer.mozilla.org/en/Using_web_workers) ?

或许有这么一种情况，我要动态生成代码并且要“后台”运行，这样的话，blob url + webworker 应该会是一种解决方案


[![](http://files.blogcn.com/wp06/M00/01/75/wKgKDU6qS_4AAAAAAAA32wmVtGU567.png)](http://files.blogcn.com/wp06/M00/01/75/wKgKDU6qS_4AAAAAAAA32wmVtGU567.png)




代码比较简单，只是一些api而已，当然，webworker可以读取一个静态的js文件来进行解析，或许会出现上面的一种情况，当然，也有曲线的方法，xhr发送动态js代码到server




server生成js文件，webworker再读取，哈哈，这里涉及到Server端的基于事件编程的东西了,




看回Blob，在控制台里面是这样的





bb.getBlob("image/png")













Blob








	
  1. size: 64

	
  2. type: "image/png"

	
  3. __proto__: Blob

	
    1. constructor: function Blob() { [native code] }

	
    2. webkitSlice: function webkitSlice() { [native code] }

	
    3. __proto__: Object








Blob对象没有暴露更多的东西给我们，基于本人的能力有限，无法对其进行精确的定义，所以就引用MDN上的

A `Blob` object represents a file-like object of raw data. It's used to represent data that isn't necessarily in a JavaScript-native format. The `[File](https://developer.mozilla.org/en/DOM/File)` interface is based on it, inheriting the `Blob`'s functionality and expanding it to support files on the user's system.

我对其简单地理解为一个二进制的容器，允许加入任何内容


