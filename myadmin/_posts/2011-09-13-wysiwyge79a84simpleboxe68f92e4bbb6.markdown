---
author: lanstonpeng
comments: true
date: 2011-09-13 14:02:22+00:00
layout: post
slug: wysiwyg%e7%9a%84simplebox%e6%8f%92%e4%bb%b6
title: WYSIWYG的simpleBox插件
wordpress_id: 595
categories:
- 未分类
tag:
- idea
- javascript
---

**现状：**平时我看到好的素材来不及看了，经典的一般都会存入书签，一般会放到read it later,evernote 里面，上课的时候接着看，但是，我越来越需要一种高精度的素材收集器，即

我在页面上看到的**所有东西**都可以作为我收集的素材的一部分，从而在多个页面中组成我想要的东西

[![](http://files.blogcn.com/wp03/M00/01/AA/wKgKC05vXbwAAAAAAACX3QtEvyk813.png)](http://files.blogcn.com/wp04/M00/01/F7/wKgKDE5vXbsAAAAAAASX0Wbktz4206.png)我试着让页面中的各个元素都可以单独的可被拖拉，让任意元素都可以“放到”我右边的 simpleBox 里面

**实现：**

**对于 桌面的文件**，使用HTML5的xhr level2可实现上传文件的功能，这个在之前的文章有说到

**对于页面上面的元素（图片，文字，声音，视频）**，可先有一个让其可拖拉的方法

    
    simpleBox.setDrag(document.getElementsByTagName("video"), document.getElementById("drag"),"img",document.getElementsByTagName("audio") )


使用的话就是这么个样子，内部实现的话也仅仅是谨慎细腻活而已，没有什么高技术可言，代码也就不贴出来了，仅仅是在对audio,video标签的可拖拉的地方作了一点点小文章而已

<!-- more -->

    
    .outterInsertDiv {
        padding: 3px;
        border: 1px dashed orange;
        position: absolute;
        background: yellow;
    }
    .outterInsertDiv: after {
        content: '';
        display: block;
        position: absolute;
        top: 0;
        left: 0;
        width: 100 % ;
        height: 100 % ; /*background:yellow;*/
        z - index: 50;
    }



    
    function setVideoDraggable(elem) {
        var parentNode = elem.parentNode,
            mydiv = document.createElement("div"),
            previous = elem.previousElementSibling
            mydiv.className = "outterInsertDiv"
        mydiv.setAttribute("draggable", "true")
        mydiv.appendChild(elem.cloneNode())
        parentNode.removeChild(elem)
        parentNode.appendChild(mydiv)
    }


** 我一直在想，是否有办法让javascript使用File API 读取页面上的文件呢？**

我尝试了许久一直没有结果,突然想到是否可以用iframe作为盒子呢，然后实验失败了（如果大牛您知道的话麻烦告诉小弟俺一下），只能将这部分放手给server那边干了，js主要的活就是**拼接元素的绝对路径**，跟上面的工作类似

去到server那边，技术上没什么创新的，但是说到在布局组织上安排素材却成了一个较大的难题，我打算采用类似Metro风格那种UI，写到后面没什么灵感了

直到后来有灵感了，但仅仅对于image而已，而且仅仅是一个比较旧的方法，当初就真没想到

思路比较简单：

    
    图片--->Canvas---->Raw Data----->Send


首先得有一个隐藏的canvas元素,充当一个数据转换容器

    
    canvas{
        display:none;
    }



    
    var img=document.querySelector("#cpyimg"),
         canvas=document.querySelector("#cav"),
         ctx=canvas.getContext('2d')
    
         canvas.height=parseInt(window.getComputedStyle(img,null).height)
         canvas.width=parseInt(window.getComputedStyle(img,null).width)
    
         ctx.drawImage(img,0,0,canvas.width,canvas.height)
         console.log(canvas.toDataURL()) //因为win中有后缀,后测试如果img没有后缀依旧成功能获取，同时img也可以读取图片，linux没有测试


当然，canvas.toDataURL()之后必须要替换掉前面的

    
    data:image/png;base64,


就这么简单明了,只是学习的时候没有注意总结罢了,当然，这仅仅是针对图片罢了

那么，对于其他文件呢，如何做到共性呢？

估计大家会想到binary data, That's it!

But How ?首先鸣谢Defims的方案，思路也是比较简单，

xhr请求，虽然表明上看是重新向Server拿数据，实际上是从本地cache检索数据，若存在，则从cache拿，否则就重新从Server获取，下面是从chromiume的console台里面看到的数据

    
    Request URL:
       http://localhost:8000/pic
    Request Method:
      GET
    Status Code:
      200 OK <span style="color: #ff9900;">(from cache)</span>


我们可以看到括号这里，那么看到xhr.responseText里面的是binary Data,拥有了binary data之后就好办了，利用XMLHttpRequest(level2) 发给Server 处理就可以了
