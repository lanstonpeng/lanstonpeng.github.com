---
author: lanstonpeng
comments: true
date: 2011-01-09 11:48:46+00:00
layout: post
slug: android%e7%bb%83%e4%b9%a0%e4%b9%8bintent%e7%9a%84action
title: Android练习之Intent的Action
wordpress_id: 210
tag:
- Android
---

考马克思之前决定练习一下再复习

Intent作为Activity之间以及与系统接口的中间物,你可以显式地指定Intent的Action等,也可以在mainfest.xml里面设置Intent-filter让Android系统内部实现过滤后调用

以下列出关键代码:


new	OnClickListener(){




@Override




public void onClick(View v){




if( true ){




//  Toast.makeText(myproject.this,et.getText().toString(),Toast.LENGTH_SHORT).show();




**Intent i=new Intent(Intent.ACTION_DIAL,**




**Uri.parse("tel:"+num));**




startActivity(i);}




else




Toast.makeText(myproject.this,"Please input the number",Toast.LENGTH_SHORT).show();}});


看到橙色字体部分,Intent的构造函数,

[Intent](http://developer.android.com/reference/android/content/Intent.html#Intent(java.lang.String, android.net.Uri))([String](http://developer.android.com/reference/java/lang/String.html) action, [Uri](http://developer.android.com/reference/android/net/Uri.html) uri)


Create an intent with a given action and for a given data url.




指定intent的Action为**ACTION_DIAL,
<!-- more -->
**







#### public static final [String](http://developer.android.com/reference/java/lang/String.html) ACTION_DIAL




Since: [API Level 1](http://developer.android.com/guide/appendix/api-levels.html#level1)










Activity Action: Dial a number as specified by the data. This shows a UI with the number being dialed, allowing the user to explicitly initiate the call.




Input: If nothing, an empty dialer is started; else `[getData()](http://developer.android.com/reference/android/content/Intent.html#getData())` is URI of a phone number to be dialed or a tel: URI of an explicit phone number.




Output: nothing.








Constant Value: "android.intent.action.DIAL"




即为使用Uri作为参数,拨打该Uri所指向的号码




还有其他非常丰富的Action




类似ACTION_VIEW(显示信息)等




当然,你可以不用这种封装好的形式,像**Intent.ACTION_DIAL**不过是封装好了东西,查查SDK的文档([http://developer.android.com/reference/android/content/Intent.html#ACTION_DIAL](http://developer.android.com/reference/android/content/Intent.html#ACTION_DIAL))




你就会发现它的值为  "android.intent.action.DIAL"




当然,我这里只是说说罢了,肯定是用封装好的形式了




这里只是Intent的冰山一角罢了




关键还是学会搜索~




**
**






