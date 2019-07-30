## activiti学习笔记

1. 加载配置创建流程引擎
```
    ProcessEngineConfiguration conf = ProcessEngineConfiguration.createStandaloneProcessEngineConfiguration();
    conf.setJdbcDriver("com.mysql.jdbc.Driver");
    conf.setJdbcUrl("jdbc:mysql://localhost:3306/activiti?useUnicode=true&characterEncoding=utf8");
    conf.setJdbcUsername("root");
    conf.setJdbcPassword("root");
    
    conf.setDatabaseSchemaUpdate("drop-create");
    ProcessEngine engine = conf.buildProcessEngine();
```
`conf.setDatabaseSchemaUpdate("")`方法接收一个String，可以传自带的枚举类也可以自己手写，常用参数为"true","false","drop-create","create-create"，生产环境使用默认参数就行，意思是不检测是否存在表，没有就报错，省去检测表的流程。

2. 通过engine对象获取各种需要用到的对象，整合spring等框架时，一般会采用注入，但是还是要了解底层的实现，核心对象有`runtimeService`,`formService`,`taskService`, `historyService`,`identityService`等。

3. 部署流程，`repositoryServicecreateDeployment().addClasspathResource("onboarding.bpmn20.xml").name("onboarding_name").tenantId("tenantId").deploy()`，一般情况下，一个bpmn文件只需要部署一次，部署后数据库会存储该记录，之后直接使用就ok。

4. 启动任务，比如提交请假申请`runtimeService.startProcessInstanceByKey("second_approve");`参数为流程的key值，还有其他参数以及同类方法，都是以startProcessInstance开头的方法，可以开始时携带参数启动流程，详情参照doc。

5. 流程部署信息管理大概为：发布流程/查看流程定义/删除流程/查看流程附件，而流程执行管理大概为：启动流程/查看任务（公有或者私有）/认领claim userId和taskId/办理任务complete(taskId, param)/查看任务状态。

6. 办理任务调用的方法为`taskService.complete(taskId, param)`，其中param为参数封装，无参数可以调用少一个参数的方法，taskId为当前任务的id，提前可以根据`formService.getTaskFormData(taskId)`获取该任务包含的表单信息，传给前端填写表单信息。

7. activiti有9个service：
>  * `DynamicBpmnService`管理动态bpmn流程状态，提  供对流程定义和部署存储库的访问、
>  * `EngineService`可以通过`getProcessEngineConfiguration`获取，可以通过这个获取所有service服务
>  * `FromService`表单服务，访问表单数据，呈现以及展示表单信息，比如获取任务处理需要填写的表单信息，请假需要填写的请假天数原因等，审核需要填写的审核信息
>  * `HistoryService`历史服务，主要是管理已经处理过的task等持久化历史记录信息
>  * `IdentityService`身份服务，管理用户信息，添加用户用户组等信息
>  * `ManagementService`管理服务，用于后台管理引擎，具有很高的权限，可以执行command
>  * `RepositoryService`库服务，提供部分对流程存储库的访问操作
>  * `RuntimeService`运行时服务，主要用来启动流程实例，另外提供部分获取运行时状态变量的api
>  * `TaskService`任务服务，提供访问任务task的服务，算是最核心的服务之一了，比如执行任务，分配任务等操作

8. 表单引擎

