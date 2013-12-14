---
author: lanstonpeng
comments: true
date: 2011-01-10 13:03:28+00:00
layout: post
slug: android%e7%9a%84ontouch%e5%92%8conclick%e4%bb%a5%e5%8f%8a%e6%a8%a1%e6%8b%9f%e5%99%a8%e7%9a%84%e9%82%a3%e4%ba%9b%e4%ba%8b
title: Android的OnTouch和OnClick以及模拟器的那些事
wordpress_id: 220
categories:
- 未分类
tag:
- Android
---

[](http://www.lanstonpeng.tk/files/2011/01/Screenshot1.png)[](http://www.lanstonpeng.tk/files/2011/01/Screenshot-2.png)[](http://www.lanstonpeng.tk/files/2011/01/Screenshot-3.png)本来在测试一下代码的,谁知让这两个方法给卡住了

关键代码如下:


ImageButton ibtn=new ImageButton(this);




ibtn.setImageResource(R.drawable.icon);




ibtn.setOnClickListener(new OnClickListener() {




@Override




public void onClick(View v) {




// TODO Auto-generated method stub




Toast.makeText(myproject.this, "OnClick Event", Toast.LENGTH_LONG).show();




Log.d("t", "OnClickEvent");




}




});<!-- more -->




ibtn.setOnTouchListener(new OnTouchListener() {




@Override




public boolean onTouch(View v, MotionEvent event) {




// TODO Auto-generated method stub




Toast.makeText(myproject.this, "onTouch Event", Toast.LENGTH_LONG).show();




Log.d("t", "OnTouchEvent");




**return false;**




/*switch(event.getAction()){




case MotionEvent.ACTION_DOWN:{




}




case MotionEvent.ACTION_UP: {




//触摸后触发




}




*/




}




});




以上代码显示为图一




[![](http://www.lanstonpeng.tk/files/2011/01/Screenshot1.png-300x168.png)](http://www.lanstonpeng.tk/files/2011/01/Screenshot1.png)[](http://www.lanstonpeng.tk/files/2011/01/Screenshot-1.png)[](http://www.lanstonpeng.tk/files/2011/01/Screenshot-1.png)




图一




[![](http://www.lanstonpeng.tk/files/2011/01/Screenshot-1.png-300x168.png)](http://www.lanstonpeng.tk/files/2011/01/Screenshot-1.png)




图二




当我将return false 改为true时,Click事件就不触发了,看了看SDK里面说的







##### Returns





	
  * True if the listener has consumed the event, false otherwise.





即返回true表明onTouch已经"消费"(简单来说就是完成了你手指点上去的事件了,不用再触发其他相关事件了,于是,这里不再触发Onclick事件了)

但是这里产生了一个问题:为什么OnTouch触发两次呢?

带着问题,监听了其两个参数

public boolean onTouch(View v, MotionEvent event) {

switch(event.getAction()){

case MotionEvent.ACTION_DOWN:{

Toast.makeText(myproject.this, "onTouch Event", Toast.LENGTH_LONG).show();

Log.d("t", "OnTouchEvent_Down");

}

case MotionEvent.ACTION_UP: {

Toast.makeText(myproject.this, "onTouch Event", Toast.LENGTH_LONG).show();

Log.d("t", "OnTouchEvent_UP");

} }

return false;

}

[![](http://www.lanstonpeng.tk/files/2011/01/Screenshot-2.png-300x168.png)](http://www.lanstonpeng.tk/files/2011/01/Screenshot-2.png)[](http://www.lanstonpeng.tk/files/2011/01/Screenshot-3.png)[](http://www.lanstonpeng.tk/files/2011/01/Screenshot-3.png)


图三




以上代码说明了当我手指点下去的时候,就在日志里面打印 "OnTouchEvent_Down",当我松开手指的时候就打印"OnTouchEvent_UP",但是....




看图:我的鼠标(手指)点下去,注意:我没有放开,可以看到,UP都打印了,奇怪了....





[![](http://www.lanstonpeng.tk/files/2011/01/Screenshot-3.png-300x168.png)](http://www.lanstonpeng.tk/files/2011/01/Screenshot-3.png)

图四

当事件全部触发完毕的时候,可以看到有两次的UP,我觉得这是模拟器的错误吧,我没搜索到答案虽然....





