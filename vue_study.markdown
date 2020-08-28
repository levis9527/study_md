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