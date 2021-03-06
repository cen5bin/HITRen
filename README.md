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

##2. 好友关系逻辑
- 增加好友分组: [AddConcernlistGroupServlet.java][5], 参数: `uid`,`gname`
- 重命名好友分组: [RenameConcernlistGroupServlet.java][6],参数:`uid`,`gname1`,`gname2`
- 关注一个好友到分组: [ConcernUserServlet.java][7], 参数:自己的`uid`,要关注的好友`uid1`,要放的分组`gnames`
- 将一些好友复制到新的分组: [CopyUsersToGroupsServlet.java][8], 参数: `uid`,`users`,`gnames`
- 将一些好友从分组中删除: [DeleteUsersFromGroupServlet.java][9], 参数: `uid`,`users`,`gname` 
- 将一些好友从一个分组移动到另外的一些分组: [MoveUsersFromGroupToGroupsServlet.java][10], 参数: `uid`,`users`,	当前所在分组`gname`,目标分组`gnames`
- 下载好友关系信息: [DownloadRelationshipInfoServlet.java][11], 参数: `uid`, `seq`
- 删除关注的好友: [DeleteConcernedUserServlet.java][12], 参数: `uid`, `uid1`
- 拉进黑名单: [MoveUsersToBlacklistServlet.java][13], 参数: `uid`, `users`
- 从黑名单恢复: [RecoverUsersFromBlacklistServlet.java][14], 参数: `uid`, `users`
- 删除好友分组: [DeleteConcernlistGroupServlet.java][15], 参数: `uid`,`gname`,删除后，该分组中所有的好友都会移到default分组中

##3. 社交功能逻辑
- 发短状态: [SendShortMessageServlet.java][16], 参数: `uid`, `message`:状态内容, `auth`:表示是否设置可见范围，0表示不设置，1表示设置, `gnames`:如果`auth=1`，则必须传这个字段，否则不用传
- 点赞: [LikeTheMessageServlet.java][19], 参数: `uid`, `mid`: 被点赞的状态
- 取消点赞: [CancelLikeTheMessageServlet.java][20], 参数： `uid`, `mid`:被取消点赞的状态
- 评论状态: [CommentMessageServlet.java][21], 参数: `uid`评论者, `mid`: 被评论的状态, `type`:评论类型，0表示直接评论状态，1表示回复某人, 如果`type`是1，则有字段`reuid`表示被回复的uid,`content`表示回复内容 
- 分享状态: [ShareMessageServlet.java][22], 参数: `uid`分享者, `mid`被分享的状态，`content`分享时的描述, `gnames`分享给这些分组的好友看，数组为空表示分享给所有好友看
- 下载timeline:[DownloadTimelineServlet.java][23], 参数: `seq`timeline的seq
- 下载状态数据:[DownloadMessagesServlet.java][24], 参数: `mids`



---
##项目构成
- 配置文件：
	- 路径： WEB-INF/conf
	- [memcache.conf][17]: memcached的配置文件，内容是部署的服务器ip和端口
	- [openfire.conf][18]: openfire服务器的配置文件，包含了服务器的基本信息，详见文件内容
- 包
	- cn.edu.hit.constant: 各种常量，主要是mongodb中的字段名
	- cn.edu.hit.dao: 和底层数据操作有关的类，包括mongodb的操作和memcached的操作
	- cn.edu.hit.kit: 工具类，包括文件路径的获取，时间的获取以及log
	- cn.edu.hit.logic: 逻辑代码，处理服务器中的各种逻辑
	- cn.edu.hit.model: 数据模型，用来表示数据
	- cn.edu.hit.openfire: 操作openfire的函数，包括在openfire中新建用户，发送推送消息等
	- cn.edu.hit.servlet.messagelogic: 社交功能中关于状态的servlet
	- cn.edu.hit.servlet.relationshiplogic: 社交模块中的好友关系处理servlet
	- cn.edu.hit.servlet.usersimplelogic: 用户登录、注册、信息修改等等


[1]:HITRenServer/src/cn/edu/hit/servlet/usersimplelogic/LoginServlet.java
[2]:HITRenServer/src/cn/edu/hit/servlet/usersimplelogic/RegisterServlet.java
[3]:HITRenServer/src/cn/edu/hit/servlet/usersimplelogic/DownloadUserInfoServlet.java
[4]:HITRenServer/src/cn/edu/hit/servlet/usersimplelogic/UpdataUserInfoServlet.java

[5]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/AddConcernlistGroupServlet.java
[6]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/RenameConcernlistGroupServlet.java
[7]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/ConcernUserServlet.java
[8]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/CopyUsersToGroupsServlet.java
[9]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/DeleteUsersFromGroupServlet.java
[10]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/MoveUsersFromGroupToGroupsServlet.java
[11]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/DownloadRelationshipInfoServlet.java
[12]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/DeleteConcernedUserServlet.java
[13]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/MoveUsersToBlacklistServlet.java
[14]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/RecoverUsersFromBlacklistServlet.java
[15]:HITRenServer/src/cn/edu/hit/servlet/relationshiplogic/DeleteConcernlistGroupServlet.java
[16]:HITRenServer/src/cn/edu/hit/servlet/messagelogic/SendShortMessageServlet.java
[17]:HITRenServer/WebContent/WEB-INF/conf/memcache.conf
[18]:HITRenServer/WebContent/WEB-INF/conf/openfire.conf
[19]:HITRenServer/src/cn/edu/hit/servlet/messagelogic/LikeTheMessageServlet.java
[20]:HITRenServer/src/cn/edu/hit/servlet/messagelogic/CancelLikeTheMessageServlet.java
[21]:HITRenServer/src/cn/edu/hit/servlet/messagelogic/CommentMessageServlet.java
[22]:HITRenServer/src/cn/edu/hit/servlet/messagelogic/ShareMessageServlet.java
[23]:HITRenServer/src/cn/edu/hit/servlet/messagelogic/DownloadTimelineServlet.java
[24]:HITRenServer/src/cn/edu/hit/servlet/messagelogic/DownloadMessagesServlet.java
