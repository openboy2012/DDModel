# DDModel
ps:my English isn't 100% fluent,but I am trying to improve it.

##a HTTP-JSON-ORM-Persisent Object Kit.  
This model package the http request and reduce the UIViewController and http code coupling.  
Use the this model you can immediately convert a JSON to entity.  
You can also use custom parse methods 

How to use
----
###get code
1.pod search DDModel.  the lasted version is 0.1.1 (new version waiting more....).  
2.clone the master then copy the files in Classes document to your project.  

###use code
1.import the header 'DDModelKit.h'  
2.initialize a DDModelHttpClient in your launching appDelegate use the method 'startWithURL:'.   
you also can initialized a clinet with the 'startWithURL:delegate:' if you want to custom the http parameteters or the response string, then please immplement the Protocol Methods '- (NSDictionary *)encodeParameters:(NSDictionary *)params;' and '- (NSString *)decodeResponseString:(NSString *)responseString;'  
3.create any entity inherit DDModel Class.
  define the property according the JSON value Property. e.g. {"name":"DeJohn",email:"dongjia_9251@126.com"},your property is name & email, the JSON string will immediately convert to entity.
  create your custom http request methods in the created entity class for get the initialzed entity from server  
  override the 'parseNode:' & 'parseMappings' if you need.
4.please see more in the Demo Project.

中文解释
====
一个封装了HTTP请求、SQLite持久化、实现ORM的Model基类，减少了Http请求与UIViewController的代码耦合，提高代码的可读性。

如何使用
----
### 获得代码
1.用Pod搜索DDModel。最新版本是0.1.1版本（代码版本持续更新中，喜欢的请加星或者follow本人）。  
2.克隆该项目master到本地，然后复制项目中的Classes中的文件到你的项目中去。 

### 代码使用
1. 首先你先导入头文件"DDModelKit.h"  
2. 在AppDelegate的Launch方法中通过"startWithURL:"方法实例一个DDModelHttpClient. 如果你有需要对http的请求参数进行加密的话，请使用"startWithURL:delegate:"方法，并且现实协议方法"- (NSDictionary *)encodeParameters:(NSDictionary *)params;" and "- (NSString *)decodeResponseString:(NSString *)responseString;"
3. 继承DDModel类创建任何你想要的实体类。在实体类里封装任何HTTP请求函数的来获取实例化后的实体。按照JSON字符串的属性来定义类的属性，这样JSON字符串就可以直接转化成实体对象了。如果你想转义字段，请用重载"parseMappings"方法实现。
4. 更多内容请看Demo项目

LICENSE(软件许可)
====

Copyright (c) 2015 DDModel <dongjia_9251@126.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
