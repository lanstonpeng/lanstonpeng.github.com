---
author: lanstonpeng
comments: true
date: 2011-01-25 12:30:18+00:00
layout: post
slug: android%e7%bb%83%e4%b9%a0%e4%b9%8bsqlite
title: Android练习之Sqlite
wordpress_id: 266
tag:
- Android
---

Android 上装有一个轻量级数据库，它支持 SQL 语言，并且只利用很少的内存就有很好的性能，Android中每一个App都可以使用Sqlite

以下引用IBM上的一段话:


SQLite 基本上符合 SQL-92 标准，和其他的主要 SQL 数据库没什么区别。它的优点就是高效，Android 运行时环境包含了完整的 SQLite。




SQLite 和其他数据库最大的不同就是对数据类型的支持，创建一个表时，可以在 CREATE TABLE 语句中指定某列的数据类型，但是你可以把任何数据类型放入任何列中。当某个值插入数据库时，SQLite 将检查它的类型。如果该类型与关联的列不匹配，则 SQLite 会尝试将该值转换成该列的类型。如果不能转换，则该值将作为其本身具有的类型存储。比如可以把一个字符串（String）放入 INTEGER 列。SQLite 称这为“弱类型”（manifest typing.）。




此外，SQLite 不支持一些标准的 SQL 功能，特别是外键约束（FOREIGN KEY constrains），嵌套 transcaction 和 RIGHT OUTER JOIN 和 FULL OUTER JOIN, 还有一些 ALTER TABLE 功能。




除了上述功能外，SQLite 是一个完整的 SQL 系统，拥有完整的触发器，交易等等。





## 如何创建数据库？




最简单的方法是：




创建一个继承SQLiteOpenHelper
实现其onCreate,OnUpgrade 回调方法
这个类就类似于平时我们的SqlHelper类




在使用的时候，
首先要new 一个刚才我们实现的那个类
然后通过getReadableDatabase()或者getWritableDatabase()
方法取得可读／可写的数据库
另外，也可以通过SQLiteDatabase的static方法
openOrCreateDatabase(String path, SQLiteDatabase.CursorFactory factory)
等获取／创建




<!-- more -->






public class sqlitehelper extends SQLiteOpenHelper {




public sqlitehelper(Context context, String name, CursorFactory factory,




int version) {




super(context, name, factory, version);




// TODO Auto-generated constructor stub




}




public sqlitehelper(Context context,String name){




this(context,name,null,2);




}




public  void onCreate (SQLiteDatabase db)




{




//	Toast.makeText(sqlliteActivity.class,"something", Toast.LENGTH_LONG);




//	Log.d("check", "creating");




//System.out.println("creating a database");




db.execSQL("create table mytable( name varchar(10))");




}




public  void onUpgrade (SQLiteDatabase db, int oldVersion, int newVersion)




{




}




}













sqlitehelper sqlhelper =new sqlitehelper(sqlliteActivity.this, "mydatabase");




SQLiteDatabase sd=sqlhelper.getReadableDatabase();




Toast.makeText(sqlliteActivity.this, "creating" , 1).show();







可以看到，实际实现起来不难的




此外，可以用Context创建一个Sqlitedatabase,











abstract [SQLiteDatabase](http://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.html)


[openOrCreateDatabase](http://developer.android.com/reference/android/content/Context.html#openOrCreateDatabase(java.lang.String, int, android.database.sqlite.SQLiteDatabase.CursorFactory))([String](http://developer.android.com/reference/java/lang/String.html) name, int mode, [SQLiteDatabase.CursorFactory](http://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.CursorFactory.html) factory)


Open a new private SQLiteDatabase associated with this Context's application package.







Context(这里为Activity), SQLiteDatabase db = context.openOrCreateDatabase(DATABASE_NAME, Context.MODE_PRIVATE,null); 




mode这个值跟数据库权限方面有关，具体可以查查API（http://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.CursorFactory.html）




也就有点对应于我们通过上面方法中获取数据库句柄的语句 getReadableDatabase,getWritableDatabase...




关于factory这个我没有研究过。





## 怎么进行数据操作？




你可以通过Android的Api来实现那些熟悉的sql语句，
当然也有我们熟悉的， sqlitedatabase.execSQL("")
直接写上我们熟悉的语句，而不是那些生硬的东西。。。
遗憾的是返回值为void，所以select那些东西只能够摸着头去写了，其实也没什么，都一样的，




乍一看，参数多得吓人，起诉只不过它是将我们的那些sql语句打散再将各个部分作为单独的参数罢了。


对比着web开发
Cursor从名字上是游标，而我的理解是类似于我们之前的
sqldatareader，一行行的读取，甚至能往前移动呢。
Cursor curosr =sd.query("mytable", new String[]{"name"}, "name=?", new String[]{"youku"}, "", "", "");
//查了查API，其实有一个rawquery 挺好用的，省去许多参数，直接写就可以了
while(curosr.moveToNext())
{
String  text=curosr.getString(0);

}
有些地方确实一开始让人不习惯，譬如获取列值一样
平时我们只用xx.getString(列名)就ok了，这里非得你用index，
所以我们只能这样： curosr.getColumnIndex("name"); 去获取他的index


最后，记住关闭的游标与数据库句柄
