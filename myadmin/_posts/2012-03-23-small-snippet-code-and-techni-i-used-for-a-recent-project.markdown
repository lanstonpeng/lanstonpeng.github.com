---
author: lanstonpeng
comments: true
date: 2012-03-23 13:10:20+00:00
layout: post
slug: small-snippet-code-and-techni-i-used-for-a-recent-project
title: Small snippet code and techni I used for a recent project
wordpress_id: 635
categories:
- 未分类
tag:
- html5
- javascript
- server
---

**Function Reduction:**
Here's a situation,I have to play a sound while 2 objects is in a collision,the problem is that there's plenty of objects in collision at the very same time,We want the sound to be played one by one
So,I have to cancle the previous(the excuting function)

    
    function reduceFunc(func,context){
      clearTimeout(func.methodID);
      func.methodID=setTimeout(function(){
        func.call(context);
      },20);
    }


**Garbage Optimization:**
While reset the an array , I tend to make it as usual like

    
    arr=[]


Because everytime we restart a game , every global array will have to be reset to empty,
So , with the aim of reducing the garbage,Instead ,I set

    
    arr.length=0


Similarly,while we have to **new** an object ,I learned from [Box2D](https://github.com/illandril/box2dweb-closure/blob/master/src/common/math/b2Vec2.js)

    
    Box2D.Common.Math.b2Vec2.Get = function(x, y) {
        if (Box2D.Common.Math.b2Vec2._freeCache.length > 0) {
            var vec = Box2D.Common.Math.b2Vec2._freeCache.pop();
            vec.Set(x, y);
            return vec;
        }
        return new Box2D.Common.Math.b2Vec2(x, y);
    };<!-- more -->


We cache some object like Monster , Bubble in an array,while we tend to create an object ,we firstly check the caching array,if there's one related left,we wipe that object and
assign some new values to it,just like what Box2D did

**Mobile && Tablet Optimization:**
Viewport
I simply add the following line

    
     meta name="viewport" content="width=device-width, maximum-scale=1.0, initial-scale=0.9, user-scalable=no"


Manifest
enable offline playing
make your mainfest file and enable the mime type in your server

**WebWorker:**
While we calculate the physical object behaviour,we first make a long math caculation in the **Main Thread**
It didn't block anything at the very beginning ,But as the object's growing and the logic became more complex,some frames will lost as some calculation blocked them,
So,we tend to use webworker to fix it

    
    worker.postMessage({
        cmd:"bubbleNextPosition",
        curX:bubble.x,
        curY:bubble.y,
        vX:bubble.vX,
        vY:bubble.vY
    });


But,there's another problem came out,**webworker** itself is **not** multi thread,So ,while there's plenty of bubble ask webworker to calulate itself,their requests are
in a queue,we won't provide multi workers to work for each bubble,So,we have to send a large JSON represent the whole game's bubble

**Long polling and ...:**
The client side is not so complex to code,simply speaking,rebuild a connection while the previous connection is closed
But the server side is more complicated ,since there's a lot of issue to considerate:
1) Brocasting
About brocasting, in every group of users,we maintain a message queue,and there's a cursor that belongs to each user.

    
    if cursor:
                index = 0
                for i in xrange(len(cls.queue)):
                    index = len(cls.queue) - i - 1
                    if cls.queue[index]["id"] == cursor: break
                recent = cls.queue[index + 1:]
                if recent:
                    callback(recent)
                    return
            cls.waiters.add(callback)


Oops,so stupid ,but I think it's a little bit explicable here,
While the server update this group of users, we check each cursor to decide how many messages should be delivered,
And we use a robust messaging component called [RabbitMQ](http://www.rabbitmq.com/)
2) Guarantee the message is received by the user
As you may expected,Like what TCP did,we send a confirm token to the server ,nothing serious here

Ref:
-->[Is webworker itself multi-thread?](http://stackoverflow.com/questions/9613959/is-webworker-itself-multi-thread)
-->[How to write low garbage real-time Javascript](http://www.scirra.com/blog/76/how-to-write-low-garbage-real-time-javascript?utm_source=javascriptweekly&utm_medium=email)
