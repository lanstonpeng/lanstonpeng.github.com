---
author: lanstonpeng
comments: true
date: 2012-01-06 08:04:03+00:00
layout: post
slug: backbone-js%e4%b8%8eknockout-js-view%e5%9f%ba%e4%ba%8emodelviewmodel%e6%9b%b4%e6%96%b0%e6%96%b9%e5%bc%8f%e5%ae%9e%e7%8e%b0%e6%80%9d%e6%83%b3
title: Backbone.JS与Knockout.JS  View基于Model/ViewModel更新方式实现思想
wordpress_id: 622
categories:
- 未分类
tag:
- javascript
---

引言：最近遇到一个问题，关于变量监测，即当我可以注册一handler到该变量值的改变的事件上，想到Backbone,KO,但是他们这种我姑且称为 **主动设置** 方式，实际用到生产环境当中，先介绍这种方式，再介绍我想要的效果，姑且称为 **被动设置** 方式，主要用在测试环境

先来看看ko的MVVM模式,
**Model:**

    
    var model={name:'lanstonpeng'}  //Usually from Server-Side


**ViewModel:**

    
    var viewModleConstructor=function(name){
      this.name=ko.<strong>observable</strong>(name);
    };
    var obj=new viewModleConstructor(model.name);


**View:**

    
    <div data-bind="{value:name}"></div>


Activate KO:

    
    ko.applyBindings(obj);


当**obj.name(newName)**，那么**view**会对应着改变，同样,Backbone也有着类似的功能，但是实现方式稍有不同，这里也不全部粘贴了，主要是这么一个做法：
在对应model的view上绑定一个事件，譬如**change<!-- more -->
**

    
    this.model.bind("change",this.render,this)


那么，当model改变的时候，如：

    
    model.set({ name: 'lanstonpeng' });


view的**render**方法就会执行
好了，之所以从KO切入，是因为KO看起来更简单，实际上它也就做这个东西，而BackboneJS可以实现这种方式，他的书写方式个人认为基本上是从原理上出发的
In fact,There's no magic in databings,只是从简单的custom Event出发而已
But how?
简单来说，建立一个自定义事件的机制,下面省略removeListener以及一些杂项，从简说明：

` `

    
    <code>var EventContainer=function(){
        this.<strong>_listenerPool</strong>={}
    }
    EventContainer.prototype.addListener=function(type,handler){
        if( !this._listenerPool[type]){
            this._listenerPool[type]=[]
         }
         this._listenerPool[type].push(handler);
    }
    EventContainer.prototype.trigger=function(type,args){
        var handlers=this._listenerPool[type.toString()]
        for(var i=0,len=handlers.length;i ++){
            <strong>handlers[i].apply(this,[args])</strong>
        }
    }</code>


So simple ,isn't it ?
添加事件监听其实就是在内部维护一个的 _listenerPool 的数组，添加相应的handler，触发事件的时候就是找到这些方法，然后依次执行，那么接下来怎么做

` `

    
    <code>var obj=function(){
             EventContainer.call(this);
       }
    obj.prototype=new EventContainer();
    
    obj.prototype.jump=function(meter){
             this.<strong>trigger</strong>("jump",meter);
       }
    o=new obj();
    o.addListener("jump",function(meter){
            console.log("o Jump ",meter);
        });
    o.addListener("jump",function(o){
            console.log("o another jump");
        });
    o.jump(5);</code>


` `
我所做的就是这么多了，在我可以被监听的方法内部触发该事件响应的trigger方法即可，理解上不难。当然，这个是一个非常非常简单的版本，更多的检测扩充，这里仅仅是为了从简说明。
好了，说了这么多，现在要介绍所谓的 **被动设置 **方式了：
在FF中，可能有人会遇到

    
    object.watch(prop, handler)


这个方法，他就是要我想要的效果

    
    a={
      b:1;
    }
    a.watch("b",function(prop, oldval, newval){
      console.log(prop, oldval, newval)
    })


当a.b改变的时候，控制台立马打出相应信息,But,这个方法只是在Gecko中，并非标准的方法,So,let's standardize it:
以下用到一些可能不太常用的方法:

` `

    
    <code>Object.prototype.watch=function(prop,handler){
            var val=this[prop],
                getter=function(){
                    return val;
                    },
                setter=function(newval){
                    handler.call(this,prop,val,newval);
                    return val=newval
                    }
    
            if(Object.defineProperty){
                 Object.defineProperty(this,prop,{
                            get:getter,
                            set:setter
    
                        });
            }else if(Object.prototype.__defineGetter__ && Object.prototype.__defineSetter__){
                        Object.prototype.__defineGetter__.call(this,prop,getter);
                        Object.prototype.__defineSetter__.call(this,prop,setter);
                }
            }</code>


` `
这两个方法有点纠结，defineProperty是ES5的方法，__defineGetter/Setter__已经是比较旧的方法
defineProperty比较强大，涉及到的东西比较多，这里仅仅就设置get，set方法说说，
设置getter与setter也有其简单的方法直接在对象属性前面加上 get 或者 set

    
    
      var obj={
         get name(){......}
      }
    


有过其它一些编程语言的同学应该会遇到过在Model里面设置
getter与setter,譬如在setter里面设置变量超过范围既不可赋值，
那么这两个方法就是做类似的工作，他们将我们要运行的handler插入到指定变量的getter,setter里面，使得我们能达到监听的目的。

Ref:
[MDN defineProperty](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineProperty)
[ MDN __difineGetter__](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Object/defineGetter)
[Backbone.js bind](http://www.csser.com/tools/backbone/backbone.js.html#Events-bind)
[Custom events in JavaScript](http://www.nczonline.net/blog/2010/03/09/custom-events-in-javascript/)
[detect variable change in javascript](http://stackoverflow.com/questions/1759987/detect-variable-change-in-javascript)
