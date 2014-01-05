---
author: lanstonpeng
comments: true
date: 2013-12-14 23:38:49+00:00
layout: post
title: Write A Simple Promise in 100 Lines Part2 

---

We've known a bit about  why we need Promise and start to build our own version of *Promise*  
Let's continue,first we get the following work 
<pre>
guruPromise.when_done_call_this(playPokemon).when_done_call_this(playPokemon);
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
Since `cleanDesk` takes around 1000ms and `washDish` takes around 1500ms, while `washDish`'s finished, the `cleanDesk`
has already execute what's inside his memory  

The last step is to fix this problem  
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
- No Error Handle Functionality
#### See Also
[callbackhell](http://callbackhell.com/)
