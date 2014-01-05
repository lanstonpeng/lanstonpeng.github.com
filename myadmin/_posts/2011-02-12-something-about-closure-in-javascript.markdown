---
author: lanstonpeng
comments: true
date: 2011-02-12 02:40:32+00:00
layout: post
published: false
slug: something-about-closure-in-javascript
title: Something about closure in javascript
wordpress_id: 302
tag:
- javascript
---

今天想用setTimeout()来做一个傻傻的动画，就是移动一下而已




sb代码事例：



    
    
    <div>function mysildeDown(elem) {</div>
    <div>var fullw = parseInt(getStyle(elem, 'width'));</div>
    <div>elem.style['width'] = 0;</div>
    <div>for (var i=0; i < 100; i++) {</div>
    <div>setTimeout(function () {</div>
    <div>elem.style['width'] = (i / 100) * fullw + 'px';</div>
    <div>}, (i + 1) * 10 );</div>
    <div>}</div>
    <div>}</div>
    <div>}</div>




<!-- more -->setTimeout是维护着一个queue, 当全部的function都set好的时候，他的第一个function才会执行




显然，在这段sb的代码中创建了一个closure




可以看到，那个Anonymous function 就是setTimeout的第一个参数，他是一个inner function,读取




mysildeDown的local variable i,在loop里面




sb的我天真地认为每个 Anonymous function 的i都是不同的，即0，1，2，3 。。。。。




本质就在于我不懂setTimeout的工作原理




我是这样理解的：




每个Anonymous function 都有一个pointer，指向这个function还有outter function 的局部变量,而这些局部变量都被每个




Anonymous function所共享着,因为是动态决定其值的，这这就造成了i都为99




How to settle?




既然要达到不同i值，沿着这个思路，想到，能否打断这种动态联系呢？




那么，我们可以通过warp一层函数并且运行，当这个函数运行完毕之后就自己注销了，那么，我们就可以达到阻断了closure与外层函数变量的




动态联系了。




less sb code:



    
    
    <div>function mysildeDown(elem){</div>
    <div>var fullw=parseInt(getStyle(elem,'width'));</div>
    <div>elem.style['width']=0;</div>
    <div>for(var j=0;j<100;j++){</div>
    <div><strong>(function(i){</strong></div>
    <div>setTimeout(function(){</div>
    <div>elem.style['width']= (i/100)*fullw+'px';</div>
    <div>},(i+1)*10)</div>
    <div><strong>})(j);</strong></div>
    <div>}</div>
    <div>}</div>




如黑体所示，setTimeout外层再wrap一个，这样，setTimeout里面的第一个参数的所享用的就是传进来的变量j，为一静态量


。
