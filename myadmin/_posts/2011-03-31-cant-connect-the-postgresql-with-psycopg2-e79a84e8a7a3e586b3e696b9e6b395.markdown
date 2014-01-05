---
author: lanstonpeng
comments: true
date: 2011-03-31 14:21:36+00:00
layout: post
slug: cant-connect-the-postgresql-with-psycopg2-%e7%9a%84%e8%a7%a3%e5%86%b3%e6%96%b9%e6%b3%95
title: 'psycopg2.OperationalError: could not connect to server: No such file or directory
  的解决方法'
wordpress_id: 441
categories:
- 未分类
tag:
- Database
- linux
- python
---

感谢＠[Tometzky](http://stackoverflow.com/users/15862/tometzky) 和psycopg2的作者


## **问题的提出：**


当我试图用psycopg2连接postgreSQL的时候出现了异常

    
    >>conn=psycopg2.connect(database="mydb", user="postgres", password="123",port=5432)</code>




## 

`

    
    
    >>Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
    psycopg2.OperationalError: could not connect to server: No such file or directory
        Is the server running locally and accepting
        connections on Unix domain socket "/var/run/postgresql/.s.PGSQL.5432"?


`
<!-- more -->


##### 要说明的几点：



    
    
    <ol>
    	<li><span style="color: #ff6600;">My postgreSQL is running</span></li>
    	<li><span style="color: #ff6600;">My listeningport is 5432 for sure</span></li>
    	<li><span style="color: #ff6600;">>>psql -l 是显示如下</span></li>
    </ol>
    
    
      List of databases
             Name      |  Owner   | Encoding | Collation  |   Ctype    |   Access privileges
        ---------------+----------+----------+------------+------------+-----------------------
         checkdatabase | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
         mydb          | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
         postgres      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
         template0     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                       |          |          |            |            | postgres=CTc/postgres
         template1     | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                       |          |          |            |            | postgres=CTc/postgres





恩，这里存在的问题的是
psycopg2 expects Postgres socket to be in `/var/run/postgresql/`
 but when you install Postgres from source it is by default it in `/tmp/`.

    
    <span style="font-family: monospace;">的即psycopg2默认在/var/run/postgresql 寻找Postgresql端口,但是因为我是通过源码安装的，所以这个socket存在于我的/tmp下面</span>




### 解决方法：



    
    <span style="color: #ff6600;">指定socket路径</span>


`



    
    <code>conn=psycopg2.connect(
      database="mydb",
      user="postgres",
      host="/tmp",
      password="123"
    )</code>


最后，轻抚[这里](http://stackoverflow.com/questions/5500332/cant-connect-the-postgresql-with-psycopg2)访问提问地址
