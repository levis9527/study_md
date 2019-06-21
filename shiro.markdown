## shiro学习笔记

1. shiro可以不依赖容器，javaSE和javaEE都能使用，javaEE下主要配合过滤器或者拦截器等使用。

2. `AuthorizationInfo`和`AuthenticationInfo`的区别，`AuthenticationInfo`表示用户角色，如主管，管理员，root超级用户等，`AuthorizationInfo`表示权限，比如删除、添加、审核，总结就是`Author`对应的是人，而`Authen`对应的是动作。

3. 最简易的操作，先创建令牌token: `UsernamePasswordToken token = new UsernamePasswordToken(username, password);`
然后执行登录
```
SecurityUtils.setSecurityManager(securityManager); // 注入SecurityManager
Subject subject = SecurityUtils.getSubject(); // 获取Subject单例对象
subject.login(token);
```

4. shiro的核心是SecurityManager，它负责安全认证和授权。shiro自身已经实现了很多细节，`SecurityUtils`只有3个方法，分别是`getSUbject`,`getSecurityManager`和`setSecurityManager`，`Subject`可以理解为当前在线的对象，也有人说理解为项目，总之就是处理权限检查，登录登出等一系列操作，是核心操作对象，主要方法`login`接收一个`token`对象，根据用户提供的登录信息构建`token`然后获取`subject`调用`login(token)`登录。

5. `shiro`无法去判断用户是否合法，使用者自己定义用户验证逻辑，可以用户自行设计`Realm`，也可以使用系统自带的`Realm`，比如`IniRealm`以及`jdbcRealm`，不过大多数情况下，会使用自定义jdbcRealm，自带的Realm没那么灵活。

6. `Realm`的核心是实现`Realm`接口，但是为了开发方便，通常会采用继承`shiro`已经实现部分功能的`Realm`类，比如`AuthorizingRealm`, `JdbcRealm`等，实际使用中，实现自己的`Realm`可以参考官方提供的`JdbcRealm`的写法，毕竟算是一个官方的demo了。

7. 如果实现`AuthorizingRealm`的话，那么主要需要自己处理逻辑的就是`doGetAuthorizationInfo`和`doGetAuthenticationInfo`方法，`doGetAuthorizationInfo`返回`SimpleAuthorizationInfo`对象，该对象封装用户的角色信息以及权限信息，一个用户是可以对应多个角色的，一个角色也可以对应多个。`doGetAuthenticationInfo`返回用户信息认证信息，也就是处理登录逻辑，系统会先调用该方法，如果失败不会继续去查看用户是否有权限，总之就是`Shiro`会先根据用户name和密码判断登录用户是否合法，然后再对用户进行授权。

8. `shiro`可以自己管理会话，可以不依赖任何web容器的实现，为了方便，也可以选择使用容器提供的session的实现。

9. 一般`shiro`用于web时会使用数据库储存用户角色权限等信息，数据库设计一般包含5张表**用户表**（name，password，sale）、**角色表**（角色名称，角色描述）、**权限表**（权限名称，权限描述）、**用户-角色关联表**（用户id，角色id）、**角色-权限关联表**（角色id，权限id），以上2个关联表都是1对多的关系，关联表可以设置复合主键防止重复记录出现。

10. 
