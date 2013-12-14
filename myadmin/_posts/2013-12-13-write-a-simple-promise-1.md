---
author: lanstonpeng
comments: true
date: 2013-12-13 23:38:49+00:00
layout: post
title: Write A Simple Promise in 100 Lines Part1 

---

#### The Problems We May Encounter
- Manage asynchronize tasks
    - invoke a callback while a few independent asynchronize function finish  
    - deep async call

#### We start from a story
Tony, a boy who loves playing Pokemon,is only allowed to play after cleaning the desk and washing all the dishes
<pre>
    function washDish(cb){
        setTimeout(cb,1000); //oh boy,how fast Tony wash
    }
    function cleanDesk(cb){
        setTimeout(cb,2000);
    }
    function playPokemon(){
        console.log("Go,Pikachu");
    }
</pre>
We may generate some codes as following
<pre>
    cleanDesk(function(){
        washDish(function(){
            playPokemon();
        });
    });
</pre>
that's ok, and imagine we can write something like this
<pre>
    when_all_done(cleanDesk,washDish).call_this(playPokemon);
</pre> 
It's not a big deal,why we have to write something like that  
before giving the answer,let's see in what circumstance can we not use   

####if we can solve the following list,we don't have to deal with this problem
- manually handle the callback pyramid well   
- get others to get intuitive understanding of your code

You bet,if the code base doesn't scale much and we're clear and smart enough( yeah,we're smart ),we can simply ignore the first piece,But the second point is not so easy to handle,we don't know who will read our code(even we think that the code we wrote is beautiful ) and whether they'll be understood

#### What this simple article might offer you
- Give you an intuitive and step by step way of the implementation of Promise in javascript

####*In a nutshell,  Promise is an abstract pattern helps people to write readable async code and manage them*

--------

####Let the journey begin
There're plenty of implementations and I choose an intuitive one to cope with  

Say that there's a mystery guy called *Guru* who promise us that he'll do whatever we want after Tony's finishing something(still remember Tony?)  

If Tony can return this **promise** from Guru,and while the thing Tony has to to is fulfilled ,the *Guru* will notify us and carry out what's inside that **promise**(how nice Guru) ,feel free to do something else
,let's alter the code a bit
<pre>
    function cleanDesk(cb){
        var guru = guruGenerator();
        setTimeout(cb,1000);
        return guru.promise;
    }
</pre>
Since we the Guru has to know that Tony's finsihing cleaning desk ,and the moment he knows ,he'll let us know,So we may add a little bit code like this  
<pre>
    function cleanDesk(){
        var guru = guruGenerator();
        setTimeout(function(){
            guru.fulfill("Tony's finishing cleaning the nifty desk");
        },1000);
        return guru.promise;
    }
</pre>
Notice that the parameter `cb` in cleanDesk is gone,since we'll assign it in another way
As we hold the delicate *promise* from the Guru, we can put things we want *Guru* to fullfill after the particular thing is done by calling  `when_done_call_this`  
So, we may write something like:
<pre>
    var guruPromise = cleanDesk();//return the promise from Guru
    guruPromise.when_done_call_this(washDish);
</pre> 
what we've done is flattening the callback hell a little bit
####How can we achieve that?
the skeleton looks like this
<pre>
function guruGenerator(){
    var promise = {
        when_done_call_this:function(){}
    };
    return {
        fulfill:function(){},
        promise:promise
    }
}
</pre>
Since we can tell whatever we want after the specified thing is done(e.g `washDish`)
like `guruPromise.when_done_call_this(washDish)`  
The Guru has to memory the things(like the `washDish` here) he has to deal with after the specified thing is done,So , we can add an array inside the Guru's body 
<pre>
function guruGenerator(){
    var memory = [];
    var promise = {
        when_done_call_this:function( things_need_to_do ){
            memory.push(things_need_to_do);
        }
    };
    ...
}
</pre>
And while the guru fulfill that `promise`,he just fetch the "todo list" from his memory and execute
<pre>
    function guruGenerator(){
        var memory = [];
        var promise = {
            when_done_call_this:function( things_need_to_do ){
                memory.push(things_need_to_do);
            }
        };
        return {
            fulfil:function(val){
                memory.forEach(function(thing,idx){
                    thing.call(null,val);
                });
            },
            promise:promise
        }
    }
</pre>
Now,we can make the following code work
<pre>
    guruPromise.when_done_call_this(playPokemon);
    //print "Go,Pikachu" after ~1000ms 
</pre>
The next part ,we'll make the following snippet possible:  
<pre>
guruPromise.when_done_call_this(playPokemon).when_done_call_this(playPokemon);
</pre>
