---
author: lanstonpeng
comments: true
date: 2012-02-18 15:21:20+00:00
layout: post
slug: wake-up-5-xx-am-to-code
title: 'Wake up 5.XX am to code '
wordpress_id: 631
categories:
- 未分类
tag:
- idea
- javascript
- rails
---

Recently,I decided to redesign PangTingMe--a project I was started while I first learned javascript,I was first inspired by a post from HN,the guy wake up 5 am to start his personal project.So,I try it on my own!

[![](http://files.blogcn.com/wp06/M00/05/9F/wKgKDE8_wGoAAAAAAACZ1DcHKrs293.png)](http://files.blogcn.com/wp01/M00/04/F2/wKgKC08_wGkAAAAAAAGYTRF1Wnw835.png)check it out from github
[**Reindeer**](http://lanstonpeng.github.com/Reindeer/)
[](http://lanstonpeng.github.com/Reindeer/)and check for the static demo :
[**PangTing.me**](http://pangting.me)

_ A small tech summary of building the prototype of  PangTingMe:_
About the server side:
I used Rails to build a simple RESTful Service,return JSON format data by different URL
It's simple but I learned a lot these days,rails is awesome!
About the client side:
This is where heavy works happen,I make myself a small MVC front-end architeture
The whole logic can be divided to 4 main object

    
    --DataContorller
    --UI
    --Functionality
    --pangting


I defined some basic URL router in Funtionality<!-- more -->

    
    du.config={
    	router:{
    		domain:"http://localhost:3000/",
    		course:{
                            ......
    			gettable:"courses/top/#day",
    			getallbyday:"courses/all/#day",
    			getprogress:"courses/progress/#courseid",
    			..........
    			addProgressComment:"courses/addprogresscomment",
    			updateNum:"courses/updateNum",
    			updateProgress:"courses/updateprogress",
    			updateCourse:"courses/updatecourse"
                            .........
    		}
    	},


and as you can expected,the DataController is the Controller in MVC pattern,It only provide the UI(View) the data,nothing else it'll care

    
    DataContorller.CourseController
    Object
      addCourse: function (data,callback){
      addProgressComment: function (data,callback){
      addRemark: function (data,callback){
      addReview: function (data,callback){
      getAllReviewByCourseId: function (options){
       ...........
      updateNum: function (options,callback){
      updateProgress: function (data,callback){


Of course,the UI is the View,I bind data and the component event in it ,and the pangting object is something like the main function
Additional Tech/Tools Used:

    
    --Templating by Mustache
    --BootStrap
    --Biolerplate
    --Heavily on HTML5
    --QUnit


Like the author ,I also chose AgileZen for quick and small project management
[![](http://files.blogcn.com/wp06/M00/05/9F/wKgKDE8_no8AAAAAAADQ43r-gu8311.png)](http://files.blogcn.com/wp04/M00/03/E7/wKgKDE8_no4AAAAAAAOK1xVwgwU648.png)
**The above Tech Details are not of the most significant**
It's a little bit hard to get up at the very first moment,but when I get used to it , it's all right then , maybe I'm still young enough ,lol,and I kept sporting ,I sleep for around 5.25 hours a day.
I found myself **really enjoying** my personal project.
The moment I was listening to my custom music and coding,I was extremelly exciting,truth to be told,it is.
But there's also damn things happened,I get frusted while debuging ,It's a hard time~
After these whole new try in 19 days, I found something really interesting:
** nothing can stop you realizing what you want to do if you deadly love it!**
I know it's true before,but when you really gonna to do ,you'll get an entire new and remarkable feeling,So,the key is that do what you really and things always go well
Tools I thank for:
--Sublime Text2 / Gvim
--Douban.fm
--Node

TO-DO:

    
    --finished some details of the prototype
    --improve the UX
    --complete the webwoker
    --use Pusher to make stream page
    --refactor a bit of the architeture
    ......


[OT]:The moment I listened to music in TangNing with someone is priceless
