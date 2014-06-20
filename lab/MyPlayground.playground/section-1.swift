// Playground - noun: a place where people can play

import Cocoa

//var str = "Hello, playground"
//var arr:Array = [0,0,0]

var numbers = [20, 19, 7, 12]

numbers.map({
    (number:Int) -> Int in
        let result  = 3 * number
        return result
    })

var o:Int?
o = 3

var dic = ["a":1]
let b = dic["b"]?

//var dataSource: Dictionary<String, String>[][] = [[], []]

let index:Int? = 1
numbers[index!]