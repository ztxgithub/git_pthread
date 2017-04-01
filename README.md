# pthread 多线程使用

## 线程使用问题

- 每个线程创建以后都应该调用 pthread_detach 函数，只有这样在线程结束的时候资源(线程的描述信息和stack,局部变量栈的容量)才能被释放

## 线程的基本知识

- 获取当前线程的id

``` c

pthread_t pthread_self(void)

```

返回值和int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                          void *(*start_routine) (void *), void *arg)中的 *thread是一样的
			
  			
- 当线程结束时释放对应的资源

``` c		  
int pthread_detach(pthread_t thread)；

返回值：0-成功 失败
		
```

**当pthread_detach重复调用已经释放过的pthread_t会出现问题**