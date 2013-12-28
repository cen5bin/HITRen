HITRen
======
##0. 基础
- 客户端请求数据的方法，利用url来请求相应的servlet，同时需要传递相应的参数，所需参数在以下条目中悉数介绍
- servlet命名规范：每个servlet对应的java文件的文件名去掉结尾处的servlet即可，如登录需要请求`LoginServlet`，该servlet的名称为`Login`
- 参数命名：单词为复数形式的都是数组，如gnames，数组中元素的数据类型以该单词的单数形式为准，如uids，则每个元素都是uid的类型；所有`id`都是`int`型，`seq`也为`int`型，其他无特别说明的就是字符串
- 返回值：每个servlet都是返回一个json数据
	- 字段`SUC`是`bool`型，表示操作成功与否
	- `INFO`字符串，表示附加说明，具体每个servlet都不同
	- `DATA`，json格式，表示实际返回的数据

##1. 用户简单逻辑
- 登录: [LoginServlet.java][1] 客户端需要传参数`email`和`password`
- 注册: [RegisterServlet.java][2] 客户端需要传参数`email`和`password`
- 下载用户基本信息: [DownloadUserInfoServlet.java][3] 客户端需要传参数`uid`,`seq`
- 更新用户信息: [UpdataUserInfoServlet.java][4] 客户端需要传参数是一个json对象，包括用户的所有基本信息

##2. 好友关系管理
- 增加好友分组: [AddConcernlistGroupServlet.java][5], 参数: `uid`,`gname`
- 重命名好友分组: [RenameConcernlistGroupServlet.java][6],参数:`uid`,`gname1`,`gname2`
- 关注一个好友到分组: [ConcernUserServlet.java][7], 参数:自己的`uid`,要关注的好友`uid1`,要放的分组`gnames`
- 将一些好友复制到新的分组: [CopyUsersToGroupsServlet.java][8], 参数: `uid`,`users`,`gnames`
- 将一些好友从分组中删除: [DeleteUsersFromGroupServlet.java][9], 参数: `uid`,`users`,`gname` 
- 将一些好友从一个分组移动到另外的一些分组: [MoveUsersFromGroupToGroupsServlet.java][10], 参数: `uid`,`users`,	当前所在分组`gname`,目标分组`gnames`
- 下载好友关系信息: [DownloadRelationshipInfoServlet.java][11], 参数: `uid`, `seq`
- 删除关注的好友: [DeleteConcernedUserServlet.java][12], 参数: `uid`, `uid1`, `gnames`









[1]:HITRenServer/src/cn/edu/hit/servlet/LoginServlet.java
[2]:HITRenServer/src/cn/edu/hit/servlet/RegisterServlet.java
[3]:HITRenServer/src/cn/edu/hit/servlet/DownloadUserInfoServlet.java
[4]:HITRenServer/src/cn/edu/hit/servlet/UpdataUserInfoServlet.java
[5]:HITRenServer/src/cn/edu/hit/servlet/AddConcernlistGroupServlet.java
[6]:HITRenServer/src/cn/edu/hit/servlet/RenameConcernlistGroupServlet.java
[7]:HITRenServer/src/cn/edu/hit/servlet/ConcernUserServlet.java
[8]:HITRenServer/src/cn/edu/hit/servlet/CopyUsersToGroupsServlet.java
[9]:HITRenServer/src/cn/edu/hit/servlet/DeleteUsersFromGroupServlet.java
[10]:HITRenServer/src/cn/edu/hit/servlet/MoveUsersFromGroupToGroupsServlet.java
[11]:HITRenServer/src/cn/edu/hit/servlet/DownloadRelationshipInfoServlet.java
[12]:HITRenServer/src/cn/edu/hit/servlet/DeleteConcernedUserServlet.java