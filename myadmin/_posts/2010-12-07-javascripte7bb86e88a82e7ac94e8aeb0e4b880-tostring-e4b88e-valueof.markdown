---
author: lanstonpeng
comments: true
date: 2010-12-07 11:22:06+00:00
layout: post
slug: javascript%e7%bb%86%e8%8a%82%e7%ac%94%e8%ae%b0%e4%b8%80-tostring-%e4%b8%8e-valueof
title: javascript细节笔记(一)--toString 与 valueOf
wordpress_id: 116
categories:
- 未分类
tag:
- javascript
---

function check(val){ this.p=val } check.prototype.valueOf=function(){alert(this.p+'valueof')} check.prototype.toString=function(){alert(this.p+'toString');}

valueOf主要在对象数值计算时被隐式调用，
toString则在对象的字符串运算中被隐式调用，
譬如:
var b=new check(9);
var c=new check(10);
>b+c //弹出两个 valueOf 的 alert
>alert(b)  //先弹出  toString 的 alert，因为其隐式调用了toString
              //，再弹出调用的alert的框，显示为undefined
