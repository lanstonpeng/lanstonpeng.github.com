---
author: lanstonpeng
comments: true
date: 2011-01-26 07:35:53+00:00
layout: post
published: false
slug: android%e4%b8%ad%e7%9a%84handler
title: Android中的Handler
wordpress_id: 281
categories:
- 未分类
tag:
- Android
---

又是寒冷的一天。。
有过Web开发经验的人都或多或少都知道Handler，但是这里的Handler并非一样的
我的总结是： Android 中的Handler 是主线程与其他线程的桥梁
因为Android平台中，主线程操控着UI，并且是安全的，我们只能通过它进行修改

那么什么时候需要多开一个线程工作呢？
我们知道，如果Activity的不响应时间超过5秒，那么这个Activity就会被系统杀死。
譬如一些网络延时，数据库处理等都可能造成这种情况的出现。那么，我们的Handler就需要出现了

Handler采用的是一种消息队列的机制，当线程加入到消息队列中去的时候，并不代表他run到最后的那个｝中
对于单核CPU来说，他会“合理”地分配资源给给每个“可执行”状态的线程，在dt时间内只有一个线程在运行。
当然，还有很多很多东西会影响的，nice值什么的，虚拟机的内部机制什么的。

在Android平台中，子线程完成了自己的工作后就告诉handler听，显然，这里就完成了线程间的通信
下面我以一个例子进行说明：[![](http://www.lanstonpeng.tk/files/2011/01/Screenshot-11-1024x575.png)](http://www.lanstonpeng.tk/files/2011/01/Screenshot-11.png)

注意看LogCat那个框框<!-- more -->

    
    
    <div>private Thread anothernewThread=new Thread( new Runnable() {</div>
    <div>@Override</div>
    <div>public void run() {</div>
    <div>// TODO Auto-generated method stub</div>
    <div>for(int i=0;i<20;i++){</div>
    <div>try {</div>
    <div>Thread.sleep(1000);</div>
    <div>} catch (InterruptedException e) {</div>
    <div>// TODO Auto-generated catch block</div>
    <div>e.printStackTrace();</div>
    <div>}</div>
    <div>Message msg=new  Message();</div>
    <div>msg.what=i*5;</div>
    <div>Log.d(TAG, "anotherthread working");</div>
    <div>handler.sendMessage(msg);</div>
    <div>}</div>
    <div>}</div>
    <div>}) ;</div>
    <div>private Thread newThread=new Thread( new Runnable() {</div>
    <div>@Override</div>
    <div>public void run() {</div>
    <div>// TODO Auto-generated method stub</div>
    <div>for(int i=0;i<20;i++){</div>
    <div>try {</div>
    <div>Thread.sleep(1500);</div>
    <div>} catch (InterruptedException e) {</div>
    <div>// TODO Auto-generated catch block</div>
    <div>e.printStackTrace();</div>
    <div>}</div>
    <div>Message msg=new  Message();</div>
    <div>msg.what=i*5;</div>
    <div>Log.d(TAG, "new thread working");</div>
    <div>anotherhandler.sendMessage(msg);</div>
    <div>}</div>
    <div>}</div>
    <div>}) ;</div>
    上面分别定义了两个线程



    
    下面是一个Handler的定义，需要覆写handleMessage方法



    
    
    <div>private Handler handler=new Handler(){</div>
    <div>@Override</div>
    <div>public void   handleMessage(Message msg){</div>
    <div>super.handleMessage(msg);</div>
    <div>if(msg.what==95){</div>
    <div>anotherBar.setVisibility(View.GONE);</div>
    <div>}</div>
    <div>else</div>
    <div>{</div>
    <div>anotherBar.setProgress(msg.what);</div>
    <div>}</div>
    <div>}</div>
    <div>};</div>



    
    <a href="http://www.lanstonpeng.tk/files/2011/01/Screenshot-21.png"><img src="http://www.lanstonpeng.tk/files/2011/01/Screenshot-21-1024x575.png" alt="" height="575" class="aligncenter size-large wp-image-285" width="1024"></img></a>



    
    我用两条进度条模拟两个线程



    
    这里看到两条进度不一样，是因为



    
    try {
    	Thread.sleep(1500);
    } catch (InterruptedException e) {
    	// TODO Auto-generated catch block
    	e.printStackTrace();
    }



    
    sleep的时间不同，看到第一张图片你就可以知道，线程那里是“并行”工作的，这里的并行打上双引号表明不是真正意义上的并行，只是我们看起来是罢了，上面有说到



    
    这里也可看到线程之间没有阻塞对方，当然，关于锁的问题可以进一步去研究。
