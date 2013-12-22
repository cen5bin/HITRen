HITRen
======
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











[1]:HITRenServer/src/cn/edu/hit/servlet/LoginServlet.java
[2]:HITRenServer/src/cn/edu/hit/servlet/RegisterServlet.java
[3]:HITRenServer/src/cn/edu/hit/servlet/DownloadUserInfoServlet.java
[4]:HITRenServer/src/cn/edu/hit/servlet/UpdataUserInfoServlet.java
[5]:HITRenServer/src/cn/edu/hit/servlet/AddConcernlistGroupServlet.java
[6]:HITRenServer/src/cn/edu/hit/servlet/RenameConcernlistGroupServlet.java
[7]:HITRenServer/src/cn/edu/hit/servlet/ConcernUserServlet.java
[8]:HITRenServer/src/cn/edu/hit/servlet/CopyUsersToGroupsServlet.java
[9]:HITRenServer/src/cn/edu/hit/servlet/DeleteUsersFromGroupServlet.java

