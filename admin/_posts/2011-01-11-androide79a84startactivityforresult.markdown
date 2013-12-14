---
author: lanstonpeng
comments: true
date: 2011-01-11 14:23:12+00:00
layout: post
slug: android%e7%9a%84startactivityforresult
title: Android的startActivityForResult()
wordpress_id: 229
categories:
- 未分类
tag:
- Android
---

每天的测试都在小地方卡住了,我只是想现在练好些基本功到时可以实现自己的想法而已....

好了,今天不记录其他的就是一个startActivityForResult()

类似在web开发中,当我们在做表单的时候,当跳过另一个页面之后回到来填写表单的页面时,我们更多地希望刚才的信息还在

而这里,类似的,可以在不同的Activity种传送数据,但其本质都是通过intent传输的<!-- more -->

但是通过使用这个方法,可以调控好不同的Activity的返回值,在一个onActivityResult()方法种统一管理,

因为返回数据的Activiy种设置了setResult方法种指定了resultCode,

在需要获取值的Activity中复写的onActivityResult的方法中


### protected void onActivityResult(int requestCode,int resultCode,Intent data)


可以看到,其中的requestCode代表我启动的Activity时的编号


Intent intent=new Intent(mycheck.this,cc.class);




startActivityForResult(intent, 8);




返回时:




setResult(cc.this.RESULT_OK, intent);   //RESULT_OK为一个int常量




于是,在 **onActivityResult**方法中可以通过一个switch来选择我的数据




当然,你可以在其他的Activity种调用startActivity来进行数据暂时的保存等工作,但是这里的




方式更显优雅.




