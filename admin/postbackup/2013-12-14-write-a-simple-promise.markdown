---
author: lanstonpeng
comments: true
date: 2013-12-26 23:38:49+00:00
layout: post
slug: '%e7%bb%a7%e7%bb%ad%e6%88%91%e7%9a%84%e6%b5%8b%e8%af%95'
title:  Test
categoies:
- 2013
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
before giving the answer,let's see the in what circumstance can we not use 
#####if we can solve the following list,we don't have to deal with this problem
- manually handle the callback pyramid well   
- get others to get intuitive understanding of your code

You bet,if the code base doesn't scale much and we're clear and smart enough( yeah,we'll be/we're ),we can simply ignore the first piece,But the second point is not so easy to handle,we don't know who will read our code(even we think that the code we write is beautiful ) and whether they'll be understood

#### What this simple article might offer you
- Give you an intuitive and step by step way of the implementation of Promise in javascript

####*In a nutshell,  Promise is an abstract pattern helps people to write readable async code and manage them*

--------
####Let the journey begin
There're plenty of implementations and I choose an intuitive one to cope with  

Say that there's a mystery guy called *Guru* who promise us that he'll do whatever we want after Tony's finishing something(still remember Tony?)  

If Tony can return this **promise** from Guru,and while the thing Tony has to to is fulfilled ,the *Guru* will notify us and carry out what's inside that **promise**(how nice Guru) ,feel free to do something else
ok,let's alter the code a bit
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
what we did is flattening the callback hell a little bit
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
[see full code here](http://www.baidu.com)
The next part ,we'll make the following snippet possible:  
<pre>
guruPromise.when_done_call_this(washDish).when_done_call_this(playPokemon);
</pre>
This is so called *chainable*
we've seen this pattern so much in JQuery
`$(ele).hide().show()`  
maybe we can get a little bit hints from how JQuery does  
the `$` method, `hide`,`show` and others that can make chainable are simply just return `this` at the end of the function

So, we may divert such methodology into Guru  

*Every time after Guru's storing what he has to do in his memory,he       just returns the a promise,so that he has the same ability to fulfill     another promise*  

So,let's add a few lines of code
<pre>
    function cleanDesk(){
        var guru = guruGenerator();
        setTimeout(function(){
            guru.fulfill("Tony's finishing cleaning the nifty desk");
        },1000);
        return guru.promise;
    }
    function guruGenerator(){
        var memory = [];
        var promise = {
            when_done_call_this:function( things_need_to_do ){
                var anotherGuru = new guruGenerator();//we generate a new Guru here so that we can return a promise     
                memory.push(things_need_to_do);
                return anotherGuru.promise;
            }
        };
        return {
            fulfill:function(val){
                memory.forEach(function(thing,idx){
                    thing.call(null,val);
                });
            },
            promise:promise
        }
    }
    //let poor Tony play Pokemon twice~
    cleanDesk().when_done_call_this(playPokemon).when_done_call_this(playPokemon);
    //print one "Go,Pikachu" after ~1000ms
    //cleanDesk().when_done_call_this(washDish()).when_donw_call_this(playPokemon);
    //didn't work yet
</pre>

We create another Guru inside the **when_done_call_this** function and return another promise after putting the **things_need_to_do** into the original Guru's memory  
but Tony actually play Pokemon once, what's going wrong?  
as we can see, while the `cleanDesk`'s done , the Guru will tell us by calling `fulfill`,ok,
Since the first `playPokemon` didn't tell the second `playPokemon` that he's already done, the second one doesn't know that he should be called or not, So, follow this hints,we can alter a bit 
<pre>
    function playPokemon(guru){
        console.log("Go,Pikachu");
        guru.fulfill();
    }
    
    function guruGenerator(){
        var memory = [];
        var promise = {
            when_done_call_this:function( things_need_to_do ){
                var anotherGuru = new guruGenerator();
                var callback = function(){
                    things_need_to_do(anotherGuru);
                }
                memory.push(callback);
                return anotherGuru.promise;
            }
        };
        return {
            fulfill:function(val){
                memory.forEach(function(thing,idx){
                    thing.call(null,val);
                });
            },
            promise:promise
        }
    }
    cleanDesk().when_done_call_this(playPokemon).when_done_call_this(playPokemon);
    //after ~1000ms print:
    //Go,Pikachu 
    //Go,Pikachu
    //cleanDesk().when_done_call_this(washDish()).when_donw_call_this(playPokemon);
    //didn't work yet,we make it possible in the next step
</pre>
We update a bit of *playPokemon* , we accept a *Guru* parameter so that we can get the Guru know that Tony has already played Pokemon  
And it works  
wait,are there any new problems here?  
Yes,there's a problem,as `playPokemon` is not an async function,it won't generate any timer,remember the mission of *Promise* written above,we don't have to insert extra codes in these plain function,if so ,we have to update all the plain functions! 

The next big step is finding a way to pack those inside the `guruGenerator`  
Since we can fill `when_done_call_this` with plain or async function wrapped by promise ,we have to distinguish them by a simple `isPromise`  
if `things_need_to_do` is  a *Promise*, we fill the memory with `anotherGuru.fulfill` to the other Guru,So that while the current `things_need_to_do` is done , the other Guru will carry out what's inside his memory;
if `things_need_to_do` is  a  plain function, we just execute it
<pre>
    function isPromise(func){
        return func.when_done_call_this; // we simplify things here
    }
    function guruGenerator(){
        var memory = [];
        var promise = {
            when_done_call_this:function( things_need_to_do ){
                var anotherGuru = new guruGenerator();  
                
                var callback = function(){
                    if( isPromise( things_need_to_do) ){
                        things_need_to_do.when_done_call_this(
                            function(){
                               anotherGuru.fulfill(); 
                            }
                        );
                    }
                    else{
                        things_need_to_do();
                        anotherGuru.fulfill();
                    }
                }
                memory.push(callback);
                return anotherGuru.promise;
            }
        };
        return {
            fulfill:function(val){
                memory.forEach(function(thing,idx){
                    thing.call(null,val);
                });
            },
            promise:promise
        }
    }
    //cleanDesk().when_done_call_this(washDish()).when_done_call_this(playPokemon);
    //cleanDesk done --> washDish done --> Go,Pikachu
    
    //washDish().when_done_call_this(cleanDesk()).when_done_call_this(playPokemon);
    //cleanDesk done --> washDish done 
</pre>


And the last thing is that (what?I'm enough about that)  
As we can see that we change the position of `cleanDesk` and `washDish` ,and Tony's ending not playing Pokemon  
Why?  
Since `cleanDesk` takes around 1000ms and `washDish` takes around 1500ms, while     
because while the Guru promise to do a thing that is already done , it's not necessary to waste the memory of Guru(he's so old,don't blame the Guru),he can just immediately do what he was told to do ,without putting anything into the memory So,let's write down the final version of it,we just add a *isDone* which indicate that if the comming *things_need_to_do* is already done or not
<pre>
function guruGenerator(){
        var memory = [],
            isDone = false;
        var promise = {
            when_done_call_this:function( things_need_to_do ){
                var anotherGuru = new guruGenerator();  
                
                var callback = function(){
                    if( isPromise( things_need_to_do) ){
                        things_need_to_do.when_done_call_this(
                            function(){
                               anotherGuru.fulfil(); 
                            }
                        );
                    }
                    else{
                        things_need_to_do();
                        anotherGuru.fulfil();
                    }
                }
                if(!isDone){
                    memory.push(callback);
                }
                else{
                    callback();
                }
                
                return anotherGuru.promise;
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


#### Things to be covered 

#### See Also
[callbackhell](http://callbackhell.com/)
