---
author: lanstonpeng
comments: true
date: 2011-11-16 06:28:11+00:00
layout: post
slug: '%e5%b0%8f%e8%ae%aejavascript-timer'
title: 小议javascript timer
wordpress_id: 614
categories:
- 未分类
tag:
- javascript
---

最近遇到一些关于javascript动画中的小问题，就是设定每帧的时间间隔，于是就稍稍作了一下小总结
有几种方式去实现：
** 简单的setInterval**

页面逻辑不复杂的时候works well,但是注意到，抛开时间误差这个话题，单单的setInterval 会引起掉帧(Frame),

原理这里不详说,可在下面的Reference中看看资料，理解js事件的执行方式很是重要

简单来说就是setInterval一下子在UI thread 中注册多个triggers，但是你不能确定其是否会被触发到,因为有可能被其他逻辑所覆盖，刚才说到逻辑不复杂也正是这个原因


_Reference:_
[How JavaScript Timers Work](http://ejohn.org/blog/how-javascript-timers-work/)
《javascript 高级编程(2nd)》中关于Timer的这章




一个解决方案：


**setTimeout in setTimeout**

    
    <span style="font-size: medium;">setTimeout(()->
      curWidth=parseInt(ele2.style.width)
      ele2.style.width=++curWidth + "px"
      setTimeout(arguments.callee,10) if curWidth<500
    ,10)</span>


这种方法可以有效避免掉帧（除非有按键精灵,理论上可行），因为其在一次repaint之后才决定下一次的repaint在哪里


The Problem is:<!-- more -->



为了保持帧数**相对**恰当(其实setTimeout in setTimeout已经做得很不错的了)
此外，也有类似下面的解决方案，即在每次seTimeout中计算时间间隔，达到需要的时候就执行callback，这个需要的时候指的是
与期望的时间间隔相近
** Count the timestamp in each setTimeout**

    
    		               <span style="font-size: medium;">
    var start=+new Date(),
    frame=-1,
    p=document.querySelector("#process4"),
    timer=setInterval(change,10)
    function change(){
        var diff=+new Date()-start,
        f=Math.floor(diff/20)
        if(f>frame){
           ++frame //不跳过失去的帧
           //frame=f //跳过失去的帧
           animate()
        }
    }</span>


关于上面这个函数 if 判断里面的东西可能有些卡壳，其实，你稍稍console一些变量，看一遍就知道怎么回事了

关于时间间隔，我们无法得知两次repaint的时候的时间间隔，depends on different Browsers
即很有可能在不同的Browsers中有着不同的动画速度，你根本不知道究竟用什么时间间隔好，导致你可能尽可能减少timestamp

那么，有没有更为高效优雅的方案呢？嗯，有的

**webkitRequestAnimationFrame|| mozRequestAnimationFrame**

    
    <span style="font-size: medium;">raf = window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame
    ele=document.querySelector("#process")
    
    change=(timestamp) ->
     curWidth=parseInt(ele.style.width)
     ele.style.width=++curWidth + "px"
     raf(change) if curWidth <500
    
    raf(change)</span>




大可抛开上面的代码,先看看其中的webkitRequestAnimationFrame


简单来说就这样：

_requests that the browser schedule a repaint of the window for the next animation frame_

其高人之处在于其智能性
在执行动画的时候，它会根据你当前浏览器的工作量来动态改变时间间隔，意味着什么，即你不用担心怎么去schedule你的timestamp了


Refernece:




[MDN:more-efficient-javascript-animations-with-mozrequestanimationframe](http://hacks.mozilla.org/2010/08/more-efficient-javascript-animations-with-mozrequestanimationframe/)
[Stackoverflow](http://stackoverflow.com/questions/196027/is-there-a-more-accurate-way-to-create-a-javascript-timer-than-settimeout)
