# pthread 多线程使用

## 线程使用问题

- 每个线程创建以后都应该调用 pthread_detach 函数，只有这样在线程结束的时候资源(线程的描述信息和stack,局部变量栈的容量)才能被释放

- 在每个线程还没有结束时，main函数不能结束

- 一个进程创建多个线程,那么多个线程将共用这个进程的栈大小(8M)

## 线程的函数接口

- 创建线程

``` c

	int pthread_create(pthread_t *thread, const pthread_attr_t *attr, 
	                    void *(*start_routine) (void *), void *arg);

```

- 获取当前线程的id

``` c

	pthread_t pthread_self(void)

    返回值和pthread_create函数中的 *thread是一样的
    
```
				
- 当线程结束时释放对应的资源

``` c	
	  
	int pthread_detach(pthread_t thread)；
	
	功能:
	    当pthread_detach()函数指定某个特定的线程ID时,该线程ID结束时会自动将资源释放归放给系统,
	    可以不需要调用pthread_join()阻塞等待指定的线程结束并释放资源
	    
	注意:
	    一旦调用pthread_detach()函数后,指定的线程ID不允许再作为参数传到pthread_join()函数中.
	    一个应用程序不断创建没有while的线程时(该线程只执行一次且很快执行完),应该要调用pthread_detach()或者
	    pthread_join()函数.当进程终止时,所有线程的资源都将被释放.
	   当pthread_detach重复调用已经释放过的pthread_t会出现问题

	返回值：
	    0: 成功 
	    EINVAL: 指定的线程不是joinable 线程而是　detach　状态
        ESRCH: 不存在pthread_t指定的ID
	    
	    
	int pthread_join(pthread_t thread, void **retval);
	
	功能：
	    pthread_join()函数等待指定的线程终止.如果线程已经终止,那么pthread_join()会立即返回,
	    但是pthread_join()函数指定的线程必须是可连接的(joinable),如果retval不为NULL,
	    那么pthread_join()将指定线程的退出状态(即指定线程提供给pthread_exit(void *retval)的值) 
	    复制到retval指向的位置。 如果目标线程被取消，则PTHREAD_CANCELED被赋值到retval指向的位置,
	    如果多个线程同时调用pthread_join()且指定的pthread_t是同一个的话会程序会出错.
	    
	用法:
	    调用pthread_join()函数会一直阻塞直到指定的线程执行完
	    
	返回值:
	    0:成功
	    EDEADLK: 线程死锁,例如２个线程相互调用pthread_join(),或者pthread_join()指定的参数是自己
	    EINVAL: 指定的线程不是joinable 线程,另外的线程已经调用pthread_join()指定它了(重复调用同一个线程)
	    ESRCH: 不存在pthread_t指定的ID
	    

		
```

- 线程属性初始化和销毁

``` c		
  
	int pthread_attr_init(pthread_attr_t *attr);

	功能：该函数初始化默认的线程属性值，可以被用于多个的pthread_create函数使用，
	已经调用过的pthread_attr_init函数的线程属性变量不能重复调用pthread_attr_init函数

	返回值：
	     0-成功 

	int pthread_attr_destroy(pthread_attr_t *attr);

	功能：
	  当该线程属性值不再需要时，使用pthread_attr_destroy函数释放,
	而且不会影响之前调用pthread_create函数要用到的该attr线程属性的线程，
	使用已经调用pthread_attr_destroy函数的线程属性会引发未知错误，
	已经调用过的pthread_attr_destroy函数的线程属性变量不能重复调用pthread_attr_destroy函数

	返回值：
	     0-成功 
		
```

- 获取特定线程的完整的属性信息

``` c		
  
	int pthread_getattr_np(pthread_t thread, pthread_attr_t *attr);
	
	参数：
	    thread：要获取特定线程的pthread_t
	    attr：属性信息,调用该函数后,*attr会被赋值
	    
	返回值：
	    0-成功 
	
	说明:
	    不能看main主线程的属性信息,当pthread_getattr_np函数获取的属性信息不再使用时,
	    注意应该要pthread_attr_destroy()该属性信息
		
```

- 获取和设置分离状态属性(get and set the detachstate attribute)

``` c		
  
  	int pthread_attr_setdetachstate(pthread_attr_t *attr, int detachstate);
      	
      	参数：
      	    attr：属性信息,调用该函数后,*attr会被赋值
      	    detachstate：分离状态
      	        PTHREAD_CREATE_DETACHED:分离态,当线程创建时使用该分离属性,
      	                                       则不需要调用pthread_detach()函数也可自动释放资源
      	        PTHREAD_CREATE_JOINABLE: joinable state.
      	        线程创建时属性为NULL,默认时PTHREAD_CREATE_JOINABLE属性
      	    
      	返回值：
      	    0-成功 
      	    EINVAL: 输入参数detachstate为无效的值
      	    
      	注意：
      	    以PTHREAD_CREATE_DETACHED状态创建的线程,不能再调用pthread_detach()函数和pthread_join()函数
  
  
	int pthread_attr_getdetachstate(const pthread_attr_t *attr, int *detachstate);
	
	 	返回值：
          	    0-成功 
		    	
```

- 获取和设置线程资源竞争范围属性(get and set the contention scope attribute)

``` c		
  
  	 int pthread_attr_setscope(pthread_attr_t *attr, int scope);
  	 
  	    描述: 
  	        设置线程资源竞争范围属性,竞争的资源有CPU等
      	参数：
      	    attr：属性信息,调用该函数后,*attr会被赋值
      	    scope：竞争范围
      	        PTHREAD_SCOPE_SYSTEM: 在系统的层面,和相同调度等级的所有进程中的所有线程竞争
      	        PTHREAD_SCOPE_PROCESS: 范围在同一个进程中进行竞争
      	    
      	返回值：
      	    0-成功 失败
      	    EINVAL: 输入参数scope为无效的值
      	    ENOTSUP： PTHREAD_SCOPE_PROCESS不支持该Linux版本
      	    
      	注意:
      	    Linux 支持 PTHREAD_SCOPE_SYSTEM, 不一定支持 PTHREAD_SCOPE_PROCESS模式,需要验证,
      	    如果需要调用pthread_attr_setscope() 函数修改资源竞争范围属性使线程创建时生效,
      	    那一定得使用pthread_attr_setinheritsched()函数将 inherit-scheduler attribute
      	    设置为PTHREAD_EXPLICIT_SCHED.
      	    
      	
	int pthread_attr_getscope(const pthread_attr_t *attr, int *scope);
	
	 	返回值：
          	    0-成功 
          	    
        说明:未设置默认是PTHREAD_SCOPE_SYSTEM属性
		    	
```

- 获取和设置线程继承调度属性(get and set the inherit-scheduler attribute)

``` c		
  
  	  int pthread_attr_setinheritsched(pthread_attr_t *attr, int inheritsched);
  	 
  	    描述: 
  	        该继承调度属性决定了线程在创建pthread_create()的过程中 attr 的属性是继承父线程,还是用自己设置的attr,　
  	        影响的属性范围有 调度策略pthread_attr_setschedpolicy(), 调度等级pthread_attr_setschedparam(), 
  	        以及调度范围 pthread_attr_setscope() ,其他的修改属性不受影响例如 pthread_attr_setdetachstate()函数
      	参数：
      	    attr：属性信息,调用该函数后,*attr会被赋值
      	    inheritsched：在线程创建中使用了attr中的调度相关属性来源方式
      	        PTHREAD_INHERIT_SCHED: 完全继承父线程的调度属性,即使使用pthread_attr_setscope()进行修改也没有
      	        PTHREAD_EXPLICIT_SCHED: 线程创建时由完全由传入参数attr的值决定
      	    
      	返回值：
      	    0-成功 失败
      	    EINVAL: 输入参数inheritsched为无效的值
      	    ENOTSUP： PTHREAD_SCOPE_PROCESS不支持该Linux版本
      	    
      	注意:
      	    Linux 支持 PTHREAD_SCOPE_SYSTEM, 不一定支持 PTHREAD_SCOPE_PROCESS模式,需要验证,
      	    如果需要调用pthread_attr_setscope()函数修改资源竞争范围属性使线程创建时生效,
      	    那一定得使用pthread_attr_setinheritsched()函数将 inherit-scheduler attribute
      	    设置为PTHREAD_EXPLICIT_SCHED.
      	    
      	bugs:As at glibc 2.8, if a thread attributes object is initialized using
                    pthread_attr_init(3), then the scheduling policy of the attributes
                    object is set to SCHED_OTHER and the scheduling priority is set to 0.(默认值)
                    However, if the inherit-scheduler attribute is then set to
                    PTHREAD_EXPLICIT_SCHED, then a thread created using the attribute
                    object wrongly inherits its scheduling attributes from the creating
                    thread.(继承父进程)  This bug does not occur if either the scheduling policy or
                    scheduling priority attribute is explicitly set in the thread
                    attributes object before calling pthread_create(3).
                    如果通过pthread_attr_set*显式调用进行修改,就不会有这样的问题
      	    
      	
	int pthread_attr_getinheritsched(const pthread_attr_t *attr, int *inheritsched);
	
	 	返回值：
          	    0-成功 
          	    
        说明:未设置默认是PTHREAD_INHERIT_SCHED属性
		    	
```

- 获取和设置线程调度策略属性(get and set the scheduling policy attribute)

``` c		
  
  	  int pthread_attr_setschedpolicy(pthread_attr_t *attr, int policy)
  	 
      	参数：
      	    attr：属性信息,调用该函数后,*attr会被赋值
      	    policy：在线程创建中使用了attr中的调度策略属性
      	        SCHED_FIFO: 
      	        SCHED_RR: 
      	        SCHED_OTHER:时间共享调度,适用于不需要实时机制
      	    
      	返回值：
      	    0-成功 
      	    
        注意:
            如果需要调用pthread_attr_setschedpolicy()函数修改资源竞争范围属性使线程创建时生效,那一定得使用
            pthread_attr_setinheritsched()函数将 inherit-scheduler attribute设置为PTHREAD_EXPLICIT_SCHED.

      	    
      	
	int pthread_attr_getschedpolicy(const pthread_attr_t *attr, int *policy);
	
	 	返回值：
          	   0-成功 
          	    
        说明:未设置默认是SCHED_OTHER属性
		    	
```

- 获取和设置线程调度等级属性(get and set scheduling parameter attributes attribute)

``` c		
  
  	   int pthread_attr_setschedparam(pthread_attr_t *attr, const struct sched_param *param);
  	 
      	参数：
      	    attr：属性信息,调用该函数后,*attr会被赋值
      	    
      	返回值：
      	    0-成功 
      	    
    
      	
	   int pthread_attr_getschedparam(const pthread_attr_t *attr, struct sched_param *param);
	
	 	返回值：
          	   0-成功 
          	       	
```

- 获取和设置guard size属性

``` c		
  
  	   int pthread_attr_setguardsize(pthread_attr_t *attr, size_t guardsize);
  	 
  	    描述: 
  	        作为保护线程堆栈大小的额外空间,如果guardsize大于0,则该guardsize 字节附加在线程堆栈后面来保护堆栈.
      	参数：
      	    attr：属性信息,调用该函数后,*attr会被赋值
      	    guardsize：
      	              0:线程创建时候没有保护空间
      	              默认大小:系统页面大小 4KB
      	    
      	返回值：
      	    0-成功 
   
      	注意:
      	    如果stack address被设置(通过使用pthread_attr_setstack() or pthread_attr_setstackaddr()),
      	    那么guardsize设置就没有用
      	    
      	    
	 int pthread_attr_getguardsize(const pthread_attr_t *attr, size_t *guardsize);

	
	 	返回值：
          	    0-成功 失败
        	
        							
```


- 对齐内存

``` c		
  
  	  int posix_memalign(void **memptr, size_t alignment, size_t size);
  	 
  	    描述: 
  	        该函数分配了size Byte内存,并将地址保存在 *menptr中,这个内存分配的地址一定是alignment的倍数,
  	        参数alignment一定是2的幂且是 sizeof(void *)的倍数.
  	        
  	    返回值:
  	          0:成功
  	          EINVAL:alignment不是2的幂次方,或者不是void指针的倍数
  	        

        	   							
```

- 获取和设置stack size属性

``` c		
  
  	   int pthread_attr_setstack(pthread_attr_t *attr, void *stackaddr, size_t stacksize);
  	 
      	   
      	 参数:
      	    stackaddr:申请的内存地址,该地址要对齐,最好用 posix_memalign函数将其对齐
      	               在a page boundary (sysconf(_SC_PAGESIZE))
      	    stacksize:最好是pagesize的整数倍
      	    
      	     
      	返回值：
      	    0-成功 
      	    EINVAL：stacksize 小于 PTHREAD_STACK_MIN (16384) bytes.  或者 如果 stackaddr or
                                 stackaddr + stacksize is not suitably aligned.
                                 
        
        注意：
            如果该attr用于创建多个线程,则调用则一定要保证分配的地址不一样
      	
      	    
      	    
	 int pthread_attr_getguardsize(const pthread_attr_t *attr, size_t *guardsize);

	
	 	返回值：
          	    0-成功 
        	
        							
```