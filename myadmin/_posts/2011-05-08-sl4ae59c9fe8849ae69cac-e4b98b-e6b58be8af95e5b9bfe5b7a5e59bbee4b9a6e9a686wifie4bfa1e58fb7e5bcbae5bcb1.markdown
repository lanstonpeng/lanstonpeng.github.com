---
author: lanstonpeng
comments: true
date: 2011-05-08 13:49:22+00:00
layout: post
slug: sl4a%e5%9c%9f%e8%84%9a%e6%9c%ac-%e4%b9%8b-%e6%b5%8b%e8%af%95%e5%b9%bf%e5%b7%a5%e5%9b%be%e4%b9%a6%e9%a6%86wifi%e4%bf%a1%e5%8f%b7%e5%bc%ba%e5%bc%b1
title: sl4a土脚本 之 测试广工图书馆wifi信号强弱
wordpress_id: 499
categories:
- 未分类
tag:
- '"geek"'
- Android
- python
---

上次白白花了一节课的时间在图书馆走上走下，#@#$!%,图书馆那个wifi信号就是弱的很杯具的说.....  于是就写了一个很土的脚本，借此绘制一个信号强度大小的图以供各位分享....

    
    """Get wifi info of the GDUT lib"""
    __author__ = 'Lanston_Peng'
    __license__ = 'VTMER'
    
    import android
    import time
    def say_where():
      location = droid.getLastKnownLocation().result
      addresses = droid.geocode(location['latitude'], location['longitude'])
      print address
    def get_wifi_info():
      state=droid.checkWifiState()
      if state:
        info=droid.wifiGetConnectionInfo().result["rssi"]
      else:
        info="Can't connect"
      print state
      print info
    
    if __name__ == '__main__':
      droid = android.Android()
      for i in range(40*60):
        say_where()
        get_wifi_info()
        time.sleep(5)


<!-- more --> 当你测试累了的时候，又刚好碰上一本好书之后再加上你又想购买而不是借阅，最后再加上你是一个节俭的人，那么下面的土脚本附加函数就有用了

    
    #本脚本参考了sl4a的官方文档,稍稍做了改动，到琅琅比比价那里搜书
    #PS:推荐使用QR扫描，因为原生的那个不是很work out的
    import android
    droid = android.Android()
    code = droid.scanBarcode()
    isbn = int(code['result']['SCAN_RESULT'])
    url = "http://www.langlang.cc/SearchAll.aspx?c=&kwd=%d&x=0&y=0" % isbn
    droid.startActivity(‘android.intent.action.VIEW’, url)


因为后天要考汇编，土脚本就先搁置在这里，图片等有间再整理出来（实际的数据很是杯具，定位是很不准确，所以要绘制图片需要更多的人力劳动，有时间再改进）

---update---

经过测试，貌似7楼的 lib5 信号最好，就是接近那些领导办公室那里，你懂的
