HITRen
======
#1. 用户简单逻辑
- 登录: `LoginServlet.java` 客户端需要传参数`email`和`password`
- 注册: `RegisterServlet.java` 客户端需要传参数`email`和`password`
- 下载用户基本信息: `DownloadUserInfoServlet.java` 客户端需要传参数`uid`,`seq`
- 更新用户信息: `UpdataUserInfoServlet.java` 客户端需要传参数是一个json对象，包括用户的所有基本信息

#2. 好友关系管理
- 增加好友分组: `AddConcernlistGroupServlet.java`, 参数: `uid`,`gname`
- 重命名好友分组: `RenameConcernlistGroupServlet.java`,参数:`uid`,`gname1`,`gname2`
- 关注一个好友到分组: `ConcernUserServlet.java`, 参数:自己的`uid`,要关注的好友`uid1`,要放的分组`gnames`
- 将一些好友复制到新的分组: `CopyUsersToGroupsServlet.java`, 参数: `uid`,`users`,`gnames`