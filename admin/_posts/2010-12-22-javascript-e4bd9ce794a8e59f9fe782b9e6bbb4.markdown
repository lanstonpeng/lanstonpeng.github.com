---
author: lanstonpeng
comments: true
date: 2010-12-22 15:44:01+00:00
layout: post
slug: javascript-%e4%bd%9c%e7%94%a8%e5%9f%9f%e7%82%b9%e6%bb%b4
title: javascript 作用域点滴
wordpress_id: 180
tag:
- javascript
---


	
  1. var name = 'lanston';

	
  2. function echo() {

	
  3. alert(name);

	
  4. }

	
  5. function env() {

	
  6. var name = 'eve';

	
  7. echo();

	
  8. }

	
  9. env();



	
  * JS权威指南中有一句很精辟的描述:　”JavaScript中的函数运行在它们被定义的作用域里,而不是它们被执行的作用域里.”<!-- more -->


具体来说涉及到函数的作用域链的问题以及js的编译（正确来说是预编译）问题，大家可以google一下，内容很多，较为复杂。

上面的例子输出是为lanston

再举一个例子：

	
  1. var name="lanston";

	
  2. function checkfun(){

	
  3. alert(name);

	
  4. var name="othername";

	
  5. }


这里输出的是undefined

你在函数内部任何一个地方定义的变量其作用域都是整个函数体。而在 alert 的时候函数的内部变量 v 已经定义了，并且覆盖掉了同名的全局变量的定义，只是还没有被初始化，所以 alert 出来的是 "undefined"

继续例子：

	
  1. function factory() {

	
  2. var name = 'lanston';

	
  3. var intro = function(){

	
  4. alert('I am ' + name);

	
  5. }

	
  6. return intro;

	
  7. }

	
  8. function app(para){

	
  9. var name = para;

	
  10. var func = factory();

	
  11. func();

	
  12. }

	
  13. app('eve');


看看这里的输出吧，如果你想到是lanston而不是其他的话，那很有可能你已经明白了。
