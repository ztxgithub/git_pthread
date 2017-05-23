# pthread 多线程使用

## 线程使用问题

- 每个线程创建以后都应该调用 pthread_detach 函数，只有这样在线程结束的时候资源(线程的描述信息和stack,局部变量栈的容量)才能被释放

- 在每个线程还没有结束时，main函数不能结束

## 线程的函数接口

- 创建线程

``` c

	int pthread_create(pthread_t *thread, const pthread_attr_t *attr，void *(*start_routine) (void *), void *arg);

```

- 获取当前线程的id

``` c

	pthread_t pthread_self(void)

```

返回值和int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                          void *(*start_routine) (void *), void *arg)中的 *thread是一样的
			
  			
- 当线程结束时释放对应的资源

``` c	
	  
	int pthread_detach(pthread_t thread)；

	返回值：
	    0-成功 失败
	    
	    
	int pthread_join(pthread_t thread, void **retval);

		
```

**当pthread_detach重复调用已经释放过的pthread_t会出现问题**


- 线程属性初始化和销毁

``` c		
  
	int pthread_attr_init(pthread_attr_t *attr);

	功能：该函数初始化默认的线程属性值，可以被用于多个的pthread_create函数使用，已经调用过的pthread_attr_init函数的线程属性变量
	不能重复调用pthread_attr_init函数

	返回值：0-成功 失败

	int pthread_attr_destroy(pthread_attr_t *attr);

	功能：当该线程属性值不再需要时，使用pthread_attr_destroy函数释放,而且不会影响之前调用pthread_create函数要用到的该attr线程属性的线程，使用已经调用pthread_attr_destroy函数的线程属性会引发未知错误，已经调用过的pthread_attr_destroy函数的线程属性变量不能重复调用pthread_attr_destroy函数

	返回值：0-成功 失败
		
```

- 获取特定线程的完整的属性信息

``` c		
  
	int pthread_getattr_np(pthread_t thread, pthread_attr_t *attr);
	
	参数：
	    thread：要获取特定线程的pthread_t
	    attr：属性信息,调用该函数后,*attr会被赋值
	    
	返回值：
	    0-成功 失败
	
	说明:
	    不能看main主线程的属性信息,当pthread_getattr_np函数获取的属性信息不再使用时,注意应该要pthread_attr_destroy()该属性信息
		
```

- 获取和设置分离状态属性(get and set the detachstate attribute)

``` c		
  
	int pthread_getattr_np(pthread_t thread, pthread_attr_t *attr);
	
	参数：
	    thread：要获取特定线程的pthread_t
	    attr：属性信息,调用该函数后,*attr会被赋值
	    
	返回值：
	    0-成功 失败
	
	说明:
	    不能看main主线程的属性信息,当pthread_getattr_np函数获取的属性信息不再使用时,注意应该要pthread_attr_destroy()该属性信息
		
```