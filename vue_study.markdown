# VUE 学习记录笔记

## 插槽
插槽可以理解为调用组件方向组件传参的一种模式  

数据以及html等会传入组件，组件接收到值后会把他放在`<slot>default</slot>`里面渲染  
XX组件代码：
```html
<div v-bind:t="text">
	<slot>默认值</slot> <!-- 组件插槽，调用方标签之间的内容 -->
	<p>组件其他代码{{t}}</p>
</div>
```
调用方代码：
```html
<div>
	<XX text="context">
		<p>组件里面所有内容都会写入插槽（包括p标签）</p>
	</XX>
</div>
```

如果调用组件方标签闭合区没有内容，那么渲染插槽内的默认值  
```html
<div v-bind:t="text">
	<div>
		默认值 <!-- 没有传内容的话，slot会使用默认值填充 -->
		<p>组件其他代码</p>
	</div>
</div>
```
如果组件没有`<slot>`标签，那么调用方传的所有数据都会被丢弃  

如果传入组件的数据需要分类处理，那么就应该试用具名插槽，组件方`<slot name='foo'>default</slot>`，调用方使用`<template v-slot:foo>context</template>`
组件代码：
```html
<div v-bind:t="text">
	<slot name='foo'>default foo</slot>
	<p>组件其他代码</p>
	<slot name='bar'>default bar</slot>
</div>
```
调用方代码：
```html
<div>
	<XX text="context">
		<template v-slot:foo> <!-- 这个里面的内容全部插入到name为foo的slot里面 -->
			Override foo
		</template>
		default slot <!-- 这里面的内容会插入默认插槽，没有默认插槽会丢弃这部分内容 -->
	</XX>
</div>
```


模板内容都是在当前父级作用域编译，也就是说调用方插槽里面的内容都是编译完成传给模板里的slot，所以在插槽里面使用模板里面的数据，是无法访问的，在插槽里面无法访问text，只能访问本页作用域的内容

如果需要在插槽里面访问组件里面的数据，那么需要插槽配合使用`v-bind`，然后在调用方使用插槽域prop  
组件：
```html
<div>
	<slot v-bind:foo="user"> <!-- slot绑定user对象，让插槽可以使用prop调用user -->
		{{user.name}}
	</slot>
</div>
```
调用方：
```html
<div>
	<XX>
		<template v-slot:foo="slotProp"> <!-- slotProp是一个prop对象，可以使用组件里面的数据 -->
			{{slotProp.user.nickName}}
		</template>
	<XX>
</div>
```

插槽转换为可复用模板，基于prop实现可定制渲染内容  
```html
<ul>
	<li v-for="todo in todoList" v-bind:key="todo.id">
		<slot name="todo" v-bind:todo="todo">
			<!-- 默认实现 -->
			{{todo.text}}
		</slot>
	</li>
</ul>
```
调用方定制slot渲染内容
```html
<div>
	<todoList v-bind:todo="todos">
		<!-- 这里v-slot可以使用解构写法，v-slot:todo="{ todo }"直接解构出todo对象 -->
		<template v-slot:todo="slotProp">
			<span v-if="slotProp.todo.isComplete">√</span>
			{{slotProp.todo.text}}
		</template>
	</todoList>
</div>
```
------

## vue-router
vue-router是vue官方的路由管理器，深度集成vue核心，用来管理单页面项目应用的路由，模块化项目  

### 基础
vue-router使用简单概括就是把组件和路由关联起来，然后告诉vue-router在哪里渲染就行  

```html
<div id="app">
	<!-- router-link可以用来导航，他会默认渲染成一个a标签 -->
	<router-link to="/foo">跳转到foo</router-link>
	<!-- 路由匹配的组件在下面渲染 -->
	<router-view></router-view>
</div>
```
```javascript
// 1. 定义路由
import Foo from "./components/Foo.vue"
import Bar from "./components/Bar.vue"
// 2. 定义路由
const routes = [
	{path: "/foo", component: Foo},
	{path: "/bar", component: Bar}
]
// 3. 创建router实例
const router = new VueRouter({
	routes: routes
})
// 4. 创建和挂载根实例
const app = new Vue({
	router: router,
	render: h => h(App)
}).$mount("#app")
// 注意，在任何组件里面都能使用this.$router访问路由器，也可以使用this.$route访问当前路由
export default{
	computed:{
		username(){
			return this.$route.params.username
		}
	},
	methods:{
		goback(){
			window.history.length > 1 ? this.$router.go(-1) : this.$router.push("/")
		}
	}
}
```

### 动态路由匹配
有时候需要把某些模式的路由全部匹配到同一个组件，比如/user/1和/user/2等全部匹配到user组件，但是又不能写死，因为后面的id是动态的，
那么我们可以使用动态路径参数来渲染
```javascript
import User from "./components/User"
const router = new VueRouter({
	routes: [
		{path: "/user/:id", component: User}
	]
})
// 路径中使用冒号的参数会被设置到this.$route.params.id
export default{
	computed:{
		user_id(){
			return this.$route.params.id // 可以获取路由里面冒号占位设置的参数
		}
	}
}
```
从/user/1跳转到/user/2时，原来的组件实例会被复用，会导致生命周期钩子不会被再次调用，复用组件，需要对路由参数作出响应的话，可以watch一下`$route`对象，
或者使用beforeRouteUpdate导航守卫
```javascript
export default{
	watch:{
		this.route(to, from){
			// 处理变化，处理生命周期相关函数调用
		}
	},
	beforRouteUpdate(to, from , next){
		// 类似拦截器，处理生命周期相关数据
		// 然后调用next()，一定记得哟啊调用nerxt()
	}
}
```
路由匹配可以采用类似正则的方式匹配，比如`path: "\*"`匹配所有的路由，可以把他放在最后用来处理匹配404，使用通配符时，`this.$route.params`会添加一个`pathMatch`参数，
表示被通配符匹配的部分，比如`/user-\*`，路由为/user-admin时，pathMatch的值为admin   
路由优先级，前面的大于后面的，先定义的优先级比较高

### 嵌套路由
实际应用中，通常需要多层嵌套组件组合，比如App组件里面放User或者其他组件，User组件里面放Profile或者Posts等组件，需要路由嵌套来表达这种关系  
使用起来很简单，如下
```html
<div id="app"><!-- app入口 -->
	<router-view></router-view>
</div>

<!-- User.vue -->
<div>
	<p>User id is {{this.$route.params.id}}</p>
	<p>router</p>
	<router-view></router-view>
<div>
```
```javascript
const router = new VueRouter({
	routes: [
		{
			path: "/user/:id",
			component: User,
			children: [ // 路由嵌套
				{
					path: "profile",
					name: "profileName", // 用名称标记路由，方便调用
					component: Profile,
					alias: "pf" // 访问/user/:id/pf会和访问/user/:id/profile一样，取一个别名
				},
				{
					path: "posts",
					component: Posts
				},
				{
					path: "", // 需要提供一个空白的路由给/user/id使用，不然/user/id会是一个空白
					component: UserHome
				},
				{
					path: "b",
					redirect: "profile" // 表示访问/user/:id/b时会跳转到/user/:id/profile，不会触发/b的路由守卫
				}
			]
		}
	]
})
```

### 编程式导航
除了使用`<router-link>`创建a标签来定义导航跳转之外，可以使用router实例进行路由跳转，比如加在某个div的点击事件上面  
使用起来也比较容易，调用this.$router对象就行了
```javascript
router.push("/home") // 字符串
router.push({path: "/home"}) // 对象
router.push({path: "/home", query: {id: 2}}) // /home?id=2
router.push({path: "/user", params: {userId: 2}}) // 不会渲染成/user/2，params参数会被丢弃
router.push({name: "user", params: {userId: 2}}) // 可以渲染成/user/2，name在routes里面定义
router.push({path: "/user/${userId}"}) // 可以渲染成/user/2
```
`router.replace`可以改变当前路由，但是不会在history添加新记录，无法调用router.go(-1)后退   
具体调用`<router-link :to="XX" replace>`或者`router.replace("XX")`   
vue-router的`router.go(-1)`, `router.push("X")`, `router.replace("X")`和`window`对象的相关方法基本一样

### 命名视图
视图是可以存在多个同级别的，比如一个组件下面有2个`<router-view></router-view>`
```html
<div>
	APP
	<router-view></router-view> <!-- 默认组件，name为default -->
	<router-view name="r_a"></router-view> <!-- 名称为r_a的组件 -->
	<router-view name="r_b"></router-view> <!-- 名称为r_b的组件 -->
</div>
```
```javascript
const router = new VueRouter({
	routes: [
		{
			path: "/",
			components: {
				default: Foo, // 乳沟未传name，渲染default组件
				r_a: Bar,
				r_b: Baz
			}
		}
	]
})
```

### 路由组件传参
在组件使用route对象会使其与所对应的路由形成高度耦合，而使组件只能在某些特定的url上使用，缺少灵活性，
这里使用props将组件和路由解耦  
```javascript
const User = {
	props: ["id"], // 采用props接收路由传过来的参数
	template: "<div>{{ id }}</div>"
}
const router = new VueRouter({
	routes: [
		{
			path: "/user/:id",
			components: {
				default: User,
				sidebar: Sidebar
			},
			props: {
				default: true, // 设置为true表示id参数会发送到组件的props同名变量里面
				sidebar: false // 设置为false时
			},
			props: (route) => ({query: route.query.q}), // 函数模式，可以让props返回一个函数
		}
	]
})
```

### HTML5 History模式
history模式主要是为了使url变得相对更好看一点，不会出现#号   
使用history时，url类似`http://a.b.c/user/id`，显得更正常   
history模式需要后端配合，需要在访问不存在的链接时不要返回404而是返回index.html   
后端匹配的例子：
```nginx
location / {
	try_files $uri $uri/ /index.html; // 链接依次去匹配，出现404的时候最终会匹配到index.html
}
```
如果这样，后端就不会返回404页面了，那么需要在路由中给个兜底的匹配，匹配所有前后端都没有找到连接的页面
```javascript
const router = new VueRouter({
	mode: "history", // 表示使用history模式
	routes: [
		{
			path: "*", // 这个匹配必须放在最后
			component: NotFoundComponent
		}
	]
})
```
------

### 导航守卫
导航表示路由正在发生变化，vue-router提供植入路由导航各个阶段的机会，供使用者操作   
**参数或查询的改变不会触发进入或者离开的导航守卫**，需要watch`$route`对象来处理变化，或者使用beforeRouteUpdate来处理变化来做组件的初始化工作   
```javascript
const router = new VueRouter({
	routes: [
		{
			path: "foo",
			component: Foo,
			beforeEach: (to, from, next) => {
				// 路由独享的守卫，这个路由调用前执行
			}
		}
	]
})
// 全局前置守卫
router.beforeEach((to, from, next) => {
	// to即将要进入的目标 from导航要离开的目标 next进入下一个页面的方法，类似部分后端框架的invoke
	// next方法有多种调用方式，
	next() //进入下一个钩子
	next(false) // 中断当前导航，如果浏览器的url改变了，那么会重置到from路由对应的地址
	next("/") next({path: "/"}) // 可以传不同的参数，类似name,replace等，所有router.push可以传的都能传
	next(error) // 如果error时Error实例，导航会被终止并传递给注册过的router.onError()回调
	// 确保next在给定的守卫中有且只有一次带哦用，例子如下
	if (to.name !== 'Login' && !isAuthenticated){
		next({name: 'Login'})
	} else {
		next()
	}
})
// 全局后置钩子
router.afterEach((to, from) => {
	// 没有next函数，因为已经跳转过来了，不能再拦截
})
const Foo = {
	template: `...`,
	beforeRouteEnter(to, from, next) {
		// 在渲染该组件对应的路由被confirm之前调用
		// 不能获取组件实例的this（此方法执行时，组件实例还未创建）
		next(vm => {
			// 可以通过vm对象访问组件实例，不能直接使用this
		})
	},
	beforeRouteUpdate(to, from, next) {
		// 当前路由改变但是该组件被复用时调用，类似/user/:id的情况下面，/user/1变成/user/2
		// 因为会渲染同样的Foo组件，所有组件生命周期函数不会调用，需要在这个钩子里面处理路由改变的逻辑
		// 可以获取组件实例的this
		this.name = to.params.name // to.query.name
		next()
	},
	beforeRouteLeave(to, from) {
		// 导航离开时调用，可以获取组件的this
		// 可以在用户离开前提醒用户（比如有部分表单数据未保存，提示用户保存继续下一步）
		const answer = window.confirm("Do you really want to leave this page")
		if (answer) {
			next()
		} else {
			next(false)
		}
	}
}
```

### 导航元信息与过渡动画
定义路由时可以配置meta字段
```javascript
const router = new VueRouter({
	routes: [
		{
			path: "foo",
			component: Foo,
			children: [
				{
					path: "bar",
					component: Bar,
					// 添加meta变量
					meta: {requiresAuth: true}
				}
			]
		}
	]
})

router.beforeEach((to, from, next) => {
	if (to.matched.some(record => record.meta.requiresAuth)) {
		if (!auth.loggeIn()) {
			next({
				path: "/login",
				// 跳转到login页面并且加上redirect，方便登录成功后跳转到原来的页面
				query: {redirect: to.fullPath}
			})
		} else {
			next()
		}
	} else {
		next() // 确保一定调用next
	}
})
```
`<router-view>`是基本的动态组件，可以使用`<transition>`组件添加一些动态效果   
```html
<transition>
	<router-view></router-view> <!-- 所有路由都有过渡效果 -->
</transition>

<!-- 动态过渡效果，绑定组件的transitionName属性 -->
<transition :name="transitionName">
	<router-view></router-view> <!-- 所有路由都有过渡效果 -->
</transition>
<!-- 组件内js代码 -->
watch:{
	this.$route (to, from) {
		const toDepth = to.path.split('/').length
		const fromDepth = from.path.split('/').length
		// 动态给过渡效果，如果目标链接深度变小，动画向右，否则向左
		this.transitionName = toDepth < fromDepth ? 'slide-right' : 'slide-left'
	}
}
```
```javascript
const Foo = {
	// 只在这个组件上生效，也就是transition写在组件内部
	template: `
		<transition name="slide">
			<div class="foo">......</div>
		</transition>
	`
}
```

### 数据获取（导航完成前获取和导航完成后获取）
进入某个路由，需要从服务器获取数据，根据获取数据的时机不同可以分为导航完成前获取和导航完成后获取   
模板代码：
```html
<template>
	<div v-if="loading">
		Loadding
	</div>
	<div v-if="error">
		{{error}}
	</div>
	<div v-if="post">
		<h2>{{post.title}}</h2>
		<p>{{post.body}}</p>
	</div>
</template>
```
导航完成后获取：
```javascript
export default {
	data () {
		return {
			loading: false,
			post: null,
			error: null
		}
	},
	created () {
		// created在组件创建后调用，也就是导航完成之后调用
		this.fetchData()
	},
	watch: {
		// 监听$route对象，如果有变化调用fetchData方法
		"$route": "fetchData"
	},
	methods: {
		fetchData() { // 共用方法
			this.loading = true
			this.error = this.post = null
			// 获取数据，传入id和回调函数
			getPost(this.$route.params.id, (err, post) => {
				this.loading = false
				if (err) {
					this.error = err.toString()
				} else {
					this.post = post
				}
			})
		}
	}
}
```
导航完成之前获取：
```javascript
// 导航完成前获取数据，也就是在上一个页面时获取下一个页面的数据，最好时显示一些获取进度条等信息，如果出错页记得全局处理一下
export default {
	data: function() {
		return {
			post: null,
			error: null
		}
	},
	beforeRouteEnter: function (to, from, next) {
		getPost(to.params.id, (err, post) => {
			mext(vm => { // 可以使用vm访问setData方法
				vm.setData(err, post) // 不能使用this.setData，因为this还不存在
			})
		})
	},
	beforeRouteUpdate: function (to, from, next) {
		this.post = null
		getPost(to.params.id, (err, post) => {
			this.setData(err, post) // 直接调用this.setData
			next() // 不要网机next()
		})
	},
	methods: {
		setData: function (err, post) {
			if (err) {
				this.error = err.toString()
			} else {
				this.post = post
			}
		}
	}
}
```

### 滚动与路由懒加载
使用前端路由，切换到新的路由时，想要滚动到页面顶部或者保持原来的滚动位置，类似于重新加载页面一样，可以使用vue-router自定义路由切换时如何滚动   
**注意，这个功能只在支持history.pushState的浏览器中可用**   
代码如下：
```javascript
const router = new VueRouter({
	routes: [
		{
			path: "/",
			component: Home,
			meta: {scrollToTop: true}
		},
		{
			path: "/foo",
			component: Foo,
			meta: {scrollToTop: false}
		}
	],
	scrollBehavior: function(to, from, savedPosition) {
		// return 期望滚动到的位置 {x:0, y:0}
		return {x:0, y:0}
	},
	scrollBehavior: function(to, from, savedPosition) {
		// savedPosition只有在通过浏览器的原生方法触发时才有效
		if (savedPosition) { // savedPosition不为空时表示调用的原生前进后退方法，那么使用浏览器的逻辑定位滚动条，否则跳转到顶部
			return savedPosition
		} else {
			return {x:0, y:0}
		}
	},
	scrollBehavior: function(to, from, savedPosition) {
		// 模拟滚动到锚点
		if (to.hash) { // 目标路由有hash时跳转到hash
			return {selector: to.hash}
		}
	},
	// 完整例子
	scrollBehavior: function(to, from, savedPosition) {
		if (savedPosition) { // 如果是浏览器前进后退触发的，使用浏览器的默认逻辑
			return savedPosition
		} else {
			const position = {}
			if (to.hash) { // 如果有hash值，那么设置hash，采用hash逻辑
				position.selector = to.hash

				if (to.hash === "#anchor2") { // hash完全匹配的话滚动100
					position.offset = {y: 100}
				}
				// 如果路由hash匹配到是一个数字或者文档滚动的在此hash内容内，直接跳转完成滚动设置
				if (/^#\d/.test(to.hash) || document.querySelector(to.hash)) {
					return position
				}
				return false // 都匹配不到返回false
			}
			// 异步滚动处理
			return new Promise(resolve => {
				// 如果目标route有meta属性而且scrollToTop为true，那么滚动条设置到x0y0
				if (to.matched.some(m => m.meta.scrollToTop)) {
					position.x = 0
					position.y = 0
				}
				this.app.$root.$once("triggerScroll", () => {
					resolve(position)
				})
			})
		}
	}
})
```
打包构建应用时，javascript包会非常大，影响页面加载速度，如果把不同组件的代码按需加载，在访问路由的时候再去加载相对应的组件，那样会更有用户体验   
```javascript
const Foo = () => Promise.resolve(......)
import("./Foo.vue") // 这个返回Promise
// 结合起来就是
const Foo = () => import("./Foo.vue")

// 可以把组件按组分块
// 有时候需要把组件打包在同一个一部块中(chunk)，需要使用命名块就行，使用一个特殊的注释语法，需要webpack > 2.4
const Foo = () => import(/*webpackChunkName: "group-foo"*/ "./Foo.vue")
const Bar = () => import(/*webpackChunkName: 'group-bar'*/ "./Bar.vue")
```
