---
author: lanstonpeng
comments: true
date: 2012-01-12 15:30:44+00:00
layout: post
slug: html5-filesystem-api-that-html5rocks-not-told-you
title: HTML5 FileSystem API that HTML5Rocks didn't tell you
wordpress_id: 620
categories:
- 未分类
tag:
- html5
- javascript
---

很久之前在HTML5Rocks里面看到的一个Terminal Demo ，当时有点震惊，不是因为其它的，是因为感觉到其实自己也是可以实现的，不像[Javascript PC Emulator](http://bellard.org/jslinux/)那样，强大到无奈的地步,具体的实现可以看看他的[Technical Notes](http://bellard.org/jslinux/tech.html),因为期末要做操作系统的课程设计，所以我在[HTML5 Terminal](http://www.html5rocks.com/en/tutorials/file/filesystem/terminal.html)的基础上作了一些基础性的修改以及命令的增加。

Ok,Let's be back.

I think you guys who're interested in [HTML5 File API](http://dev.w3.org/2009/dap/file-system/pub/FileSystem/)should have read [this](http://www.html5rocks.com/en/tutorials/file/filesystem/) in [html5 rocks](http://www.html5rocks.com),I've done so,but when you dive into it,you probably found it can't meet your aims.

**How to update my file not just appending data ?**

We can use  [truncate](http://www.w3.org/TR/file-writer-api/#widl-FileWriter-truncate) ,this spec is to change your file's length,that means when you want to update file ,you "cut" the content of your file to length 0 or some other length you want and write your new content,here's my code snippet of implementing the
_echo newcontent > myfile _:

    
    cwd_.getFile(cwd_.fullPath+fileName,{create:false},function(fileEntry){
    		fileEntry.createWriter(function(fileWriter){
    				fileWriter.onwriteend=function(trunc){
    				     var bb=new WebKitBlobBuilder();
    				     bb.append(content);
    				     fileWriter.write(bb.getBlob());
    				     fileWriter.onwriteend=null;//or we may recursively trigger the FileCallback
    		                };
    		               fileWriter.seek(0);
    		               fileWriter.truncate(0);
    		},errorHandler_);
    },errorHandler_);


<!-- more -->we can see that it's quite simple here,note that we should set fileWriter.onwriteend to null or we may trigger it recursively since we write something into a file in the writeend event

