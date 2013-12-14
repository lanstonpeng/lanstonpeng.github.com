---
author: lanstonpeng
comments: true
date: 2010-11-26 09:38:43+00:00
layout: post
slug: python%e5%ad%a6%e4%b9%a0%e7%82%b9%e6%bb%b4-%e5%bc%95%e7%94%a8%e8%ae%a1%e6%95%b0demo
title: python学习点滴 & 引用计数demo
wordpress_id: 40
tag:
- python
---

id()
type()
3种比较类型:
type(L)==type([])
type(L)==list
isinstance(L,list)

对象引用计数   对地址

    
    
    a=1
    b=a
    c=[]
    c.append(b)


这里，对象 1 的引用计数为3
del a
b=5
c[0]=9
这里，对象 1 的引用计数为0
<!-- more -->

a = { }         # a 的引用为 1
b = { }         # b 的引用为 1
a['b'] = b              # b 的引用增 1，b的引用为2
b['a'] = a              # a 的引用增 1，a的引用为 2
del a           # a 的引用减 1，a的引用为 1
del b           # b 的引用减 1,  b的引用为 1

在这个例子中,del语句减少了 a 和 b 的引用计数并删除了用于引用的变量名，可是由于两个对象各包含一个对方对象的引用，虽然最后两个对象都无法通过名字访问了，但引用计数并没有减少到零。因此这个对象不会被销毁，它会一直驻留在内存中，这就造成了内存泄漏。为解决这个问题，Python解释器会定期的运行一个搜索器，若发现一个对象已经无法被访问，不论该对象引用计数是否为 0 ，都销毁它。这个搜索器的算法可以通过 gc 模块的函数来进行调整和控制。
