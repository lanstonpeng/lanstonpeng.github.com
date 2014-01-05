---
author: lanstonpeng
comments: true
date: 2011-04-13 12:53:47+00:00
layout: post
slug: identity-%e4%b8%8e-sequence
title: identity 与 sequence
wordpress_id: 466
categories:
- 未分类
tag:
- Database
---

之前一直在用M$的Sql Server ，一般在设置id自动增长的时候会在类似这样做
create table Poll(
id int primary key identity(1,1)
)
或者直接点击那些可恶的按钮什么的，设置什么标识规范
一直没有为此继续追问下去了

直到最近在用PostgreSQL，什么都得敲代码，什么都得在shell里面完成（虽然有想过装个pgAdmin啦）
当我查看我的数据库的时候，才发现里面的东西究竟是如何的

    
     public | polls_poll                        | table    | postgres
     public | polls_poll_id_seq                 | sequence | postgres



    
    mysite=# select * from polls_poll_id_seq
    mysite-# \g
       sequence_name   | last_value | start_value | increment_by |      max_value      | min_value | cache_value | log_cnt | is_cycled | is_called
    -------------------+------------+-------------+--------------+---------------------+-----------+-------------+---------+-----------+-----------
     polls_poll_id_seq |          2 |           1 |            1 | 9223372036854775807 |         1 |           1 |      32 | f         | t
    (1 row)


这个自动增长就这么直白在出现了眼前了

**需要注意的是，identity和sequence是不同的东西，但是功能还是差不多的(base on 我现阶段的知识[2011-4])，只是sequence可以作用于整个数据库，而identity所指定是仅仅限制在你所指定的这个表格当中而已**
