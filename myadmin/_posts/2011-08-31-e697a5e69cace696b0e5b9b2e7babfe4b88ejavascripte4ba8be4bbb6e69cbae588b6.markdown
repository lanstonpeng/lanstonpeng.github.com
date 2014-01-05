---
author: lanstonpeng
comments: true
date: 2011-08-31 13:42:03+00:00
layout: post
slug: '%e6%97%a5%e6%9c%ac%e6%96%b0%e5%b9%b2%e7%ba%bf%e4%b8%8ejavascript%e4%ba%8b%e4%bb%b6%e6%9c%ba%e5%88%b6'
title: 日本新干线与javascript事件机制
wordpress_id: 578
categories:
- 未分类
tag:
- javascript
---

[![](http://files.blogcn.com/wp03/M00/02/14/wKgKCk5eOegAAAAAAABKDWDvDMc118.jpg)](http://files.blogcn.com/wp05/M00/01/D7/wKgKDU5eOecAAAAAAAGjOVdMLi0207.jpg)

上课在看《geek》的时候看到了日本新干线为了预防列车追尾的措施以及其系统的一些装置的时候，发现新干线列车的停车是一个连锁的反应，我突然就想到了js中的事件冒泡


<ul id="control_center">




<li id="train2"></li>




<li id="train1"></li>




</ul>


当我们对
`document.querySelector("#train1").addEventListener("lighting",function(){stop_and_crash()},false)`
假设我们的train2也同样设置了在 打雷 的时候停车，那么显然，根据事件冒泡的机制，train2的 打雷 事件也会被触发停车
如果我们在control_center里面设置了lighting事件响应函数的话，那么显然，根据事件冒泡的机制，不管是train1还是train2触发打雷事件的话，control_center 都会收到，要实现类似日本列车这种响应事件类型并不难，用类似previousElementSibling就可以了
说到这里，应该会有人联想到对于结点事件的绑定优化，即在ul那里设置一个Handler,监听来自li的相应的事件，但这里我想稍稍探究一下这个机制<!-- more -->

大家都知道，除了bubble，当然还有capture的触发形式了,
需要注意的是，事件的触发顺序是先触发capture的再bubble的

<body id="body">  
<div id="div">  
<span id="span"></span>  
</div>  
<ul id="ul">  
<li id="li1"></li>  
<li id="li2"></li>  
</ul>  
</body>​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​
先设置一点点东西：

    
    ​addEvent(body,"click​​​​​",function(){console.log("body click bubble");},false)​​​​​​​​​​​;
    addEvent(body,"click",function(){console.log("body click capture");},true);
    addEvent(ul,"click",function(){console.log("ul click capture");},true);
    addEvent(ul,"click",function(){console.log("ul click bubble");},false);
    addEvent(li2,"click",function(){console.log("li2 click capture");},true);
    addEvent(li2,"click",function(){console.log("li2 click bubble");},false);


那么，当我点击li2的时候，结果很简单,就是

    
    body click capture
    ul click capture
    li2 click capture
    li2 click bubble
    ul click bubble
    body click bubble


究其事件触发这种模型的底层实现，我想应该是cpu的中断
没有研究过，这里仅仅是猜想罢了
那么，这种机制的实现大概是长个什么样子的？
没错，正如dom的结构一般，最简单最容易想到的就是树了
每次触发某元素事件的时候，
我想都会生成一个相应的响应路径，这里涉及到树的查找问题
执行系统内置函数然（譬如一些渲染什么的）后执行用户定义函数
