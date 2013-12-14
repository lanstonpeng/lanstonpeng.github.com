---
author: lanstonpeng
comments: true
date: 2011-01-10 13:49:06+00:00
layout: post
slug: '%e5%85%b3%e4%ba%8eandroid%e4%b8%ad%e7%9a%84id-cannot-be-resolved-or-is-not-a-field'
title: 关于Android中的:[id] cannot be resolved or is not a field
wordpress_id: 226
categories:
- 未分类
tag:
- Android
---

今晚遇到的小问题不少啊~

我只想在考试前敲敲代码轻松一下而已....

言归正传,今天想试试starActivityForResult()

谁知在setContentView(id)时卡住了

看看import的东西,发现导入了android.R,实践证明,去掉即可.

因为我导入的是系统的R,而非我的R,我也不知道为啥写下这篇东西
