# pthread 多线程使用

## 线程相关知识

- 一个线程可以独立与main函数运行,是因为有自己的资源

```shell
    1.Stack pointer(栈指针)
    2.Registers(寄存器)
    3.优先级属性
    4.Set of pending and blocked signals
    5.线程特有的数据
```

- Why Pthreads?

```shell
    1.Light Weight:轻量级,线程的创建和管理比进程开销更小(资源和启动的时间)
```
   
## 线程使用问题

```shell
    1. 每个线程创建以后都应该调用 pthread_detach 函数，只有这样在线程结束的时候资源
        (线程的描述信息和stack,局部变量栈的容量)才能被释放

    2. 在每个线程还没有结束时，main函数不能结束(不能调用retrun或则_exit()),可通过在main中最后写pthread_exit(NULL),
       阻塞等待其他线程创建好完成.

    3. 一个进程创建多个线程,那么多个线程将共用这个进程的栈大小(8M)以及其他资源

    4.创建线程时要注意最多的线程数量和线程栈大小
    
    5. 
        pthread_t 并不适合用做线程的标识符
        glibc 将　pthread_t 当成结构体指针，指向一块动态分配的内存，这部分内存是反复使用．
    　　只保证同一进程内，同一时间各个线程 id 不同，不能保证同一进程内先后线程有不同的 id (第一个线程运行完后，再运行
    　　第二个线程，它们的 pthread_t 可能相同)．　多个进程间的线程 id 也可能相同
    
            例如：
                   pthread_t t1;
            　　　　pthrad_create(&t1, NULL, Func, NULL);
                   pthread_join(t1, NULL);
                   
                   pthread_t t2;
           　　　　 pthrad_create(&t2, NULL, Func, NULL);
                   pthread_join(t2, NULL);
                   
                   // t1 的值可能等于 t2 的值
                   
    6. 使用 gettid() 系统调用返回值作为线程 id(可以考虑使用 muduo::CurrentThread::tid() 进行封装)
        理由如下：
            (1) 类型为 pid_t , 是个小整数，便于在日志中打印
            (2) 直接表示内核的任务调度 id, /proc/tid 或则 /proc/pid/task/tid
            (3) 在其他的系统工具也能定位到某一具体的线程，例如 top 可以按线程列出任务，可以找出 CPU 使用率最高的
            　　 线程 id.
            (4) 0 为非法值，第一个进程的 pid 是 1
            
    7.线程数最好 CPU 的数量一致，最好在程序的初始化阶段创建全部工作线程，在程序的运行期间不再创建和销毁，
    　可以使用 muduo::ThreadPool 和 muduo::EvnetLoop
    
    8.最好不用强行在外部终止线程的做法，这样会导致线程没来的及清除资源，也没机会及时释放锁的占用
    9. __thread 是GCC内置的线程局部存储设施, __thread变量每一个线程有一份独立实体，各个线程的值互不干扰
       __thread 使用规则: 只能修饰POD类型(类似整型指针的标量，不带自定义的构造、拷贝、赋值、析构的类型，
                                      二进制内容可以任意复制 memset,memcpy,且内容可以复原)，
                        不能修饰class类型，因为无法自动调用构造函数和析构函数，可以用于修饰全局变量，函数内的静态变量，
                        不能修饰函数(包括主函数)的局部变量 或者 class的普通成员变量，
                        且__thread变量值只能初始化为编译器常量(值在编译器就可以确定 例如const int i=5)
                        
       
        const int i=5;
        __thread int var=i;
        
        //__thread int var=5;//
        //以上两种方式效果一样
       
        void* worker1(void* arg);
        void* worker2(void* arg);
        int main(){
            pthread_t pid1,pid2;
            __thread int temp=5;  // 错误, 函数内的局部变量不能申明为 __thread
            static __thread  int temp=10;// 正确, 修饰函数内的static变量
            pthread_create(&pid1,NULL,worker1,NULL);
            pthread_create(&pid2,NULL,worker2,NULL);
            pthread_join(pid1,NULL);
            pthread_join(pid2,NULL);
            cout<<temp<<endl;//输出10
            return 0;
        }
        void* worker1(void* arg){
            cout<<++var<<endl;//输出 6  var 被定义为 __thread ,代表各个线程之间变量是独立的
        }
        void* worker2(void* arg){
            sleep(1);//等待线程1改变var值，验证是否影响线程2
            cout<<++var<<endl;//输出6
        }


```

## 编码技巧

- 创建一个线程,如果要给线程传多个参数,则将这多个参数构成一个自定义的结构体,再将它传给线程

- 需要调用pthread_join()函数时最好显式设置属性为joinable,并创建.为了移植性,并不是所有的系统都保证默认创建线程是joinable.

## 线程的函数接口

- 创建线程

``` c

	int pthread_create(pthread_t *thread, const pthread_attr_t *attr, 
	                    void *(*start_routine) (void *), void *arg);
	                    
	返回值:
	    0:成功

```

- 线程取消

``` c

    概念:
        1. 线程取消的方法是向目标线程发Cancel信号,但如何处理Cancel信号则由目标线程自己决定,或者忽略(当禁止取消时),
           或者立即终止（当在取消点或异步模式下）、或者继续运行至Cancelation-point（取消点，下面将描述）,
           总之由不同的Cancelation状态决定。
        
        2. 线程接收到CANCEL信号的缺省处理（即pthread_create()创建线程的缺省状态）是继续运行至取消点再处理（退出）,
           或在异步方式下直接退出.一个线程处理cancel请求的退出操作相当于pthread_exit(PTHREAD_CANCELED).
           当然线程可以通过设置为PTHREAD_CANCEL_DISABLE来拒绝处理cancel请求
        
        3. 线程的取消与线程的工作方式（joinable或detached）无关
        
        4.根据POSIX标准,pthread_join(),pthread_testcancel()、pthread_cond_wait()、 pthread_cond_timedwait()、
          sem_wait()、sigwait()等函数以及read()、write()等会引起阻塞的系统调用都是Cancelation-point，
          而其他pthread函数都不会引起Cancelation动作
    注意:
        当pthread_cancel()返回时,线程未必已经取消,可能仅仅将请求发送给目标线程,而目标线程目前没有到达取消点(
        需要调用pthread_join(),pthread_testcancel()等函数),
        如果要知道线程在何时中止,就需要在取消它之后调用pthread_join().有一个例外是当线程被detach后,不能这样处理：      
      
    (1)      
        int pthread_cancel(pthread_t thread)
        
        功能:
            发送终止信号给目标thread线程,发送成功并不意味着thread会终止。
            
        参数 thread: 目标thread线程
        返回值
            0:成功
            非0:失败
            
        注意:
            这个是在其他线程中调用,要对目标线程进行消除
	    
    (2)
        int pthread_setcancelstate(int state, int *oldstate) 
            
        功能:
            设置本线程对Cancel信号的反应
            
        参数 
            state: PTHREAD_CANCEL_ENABLE (默认设置) 收到信号后设为CANCLED状态
                   PTHREAD_CANCEL_DISABLE 忽略CANCEL信号继续运行
            oldstate:如果不为NULL则存入原来的Cancel状态以便恢复
        返回值
            0:成功
            非0:失败
            
        注意:
             这个是在目标线程进行调用
        
    (3)
         int pthread_setcanceltype(int type, int *oldtype) 
            
        功能:
            设置本线程取消动作的 执行时机
            
        参数 
            type: PTHREAD_CANCEL_DEFFERED  收到信号后继续运行至下一个取消点再退出
                  PTHREAD_CANCEL_ASYCHRONOUS 立即执行取消动作（退出）
            oldstate:如果不为NULL则存入运来的取消动作类型值。
        返回值
            0:成功
            非0:失败
            
        注意:
             一般不进行设置, 这个是在目标线程进行调用,
             即使设置为PTHREAD_CANCEL_ASYCHRONOUS,也要在pthread_cancel()调用后,
             再次调用引起Cancelation-point的函数
            
    (4)
        void pthread_testcancel(void) 
            
        功能:
            检查本线程是否处于Canceld状态(是否目标线程收到取消信号pthread_cancel)，如果是,则进行取消动作，
            否则直接返回
            
        注意:
             这个是在目标线程进行调用. 在这样的循环体的必经路径上应该加入pthread_testcancel()调用
             
    (5)
        int pthread_kill(pthread_t thread, int sig) 
            
        功能:
        
        参数 
            thread: 目标thread线程
            sig:  0 : 检测一个线程是否还活着
            
        返回值:
            0:成功
                  

```

- 获取当前线程的id

``` c

	pthread_t pthread_self(void)
	
    返回值和pthread_create函数中的 *thread是一样的
```

- 判断线程ID是否相等

``` c

	int pthread_equal(pthread_t t1, pthread_t t2);
	
    返回值 
        非零值: 2个线程ID相等
        零值:   2个线程ID不相等

    
    
```

- pthread_once(只执行一次操作)

```c
    int pthread_once(pthread_once_t *once_control, void (*init_routine)(void))
    
    功能:
        使用初值为 PTHREAD_ONCE_INIT 的 pthread_once_t 变量保证 init_routine() 函数在 
        本进程仅执行一次.
        在多线程编程环境下,尽管 pthread_once() 调用会出现在多个线程中,init_routine() 函数仅执行一次，
        究竟在哪个线程中执行是不定的，是由内核调度来决定。
        
        pthread_once() 行为和 pthread_create() 不一样，会同步调用函数，pthread_once()之后的语句会被阻塞
        直到 pthread_once()　注册函数运行完
        
    参数:
        *once_control : 初始值为　PTHREAD_ONCE_INIT
        init_routine　: 要运行的函数
     
    返回值:
         0: 成功
        
    注意:
        如果 pthread_once_t 的初值不是 PTHREAD_ONCE_INIT（Linux Threads定义为0）， pthread_once() 
        的行为就会不正常。
        
         pthread_once() is not a cancellation point(不是取消点)

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
	    但是pthread_join()函数指定的线程必须是可连接的(joinable)不能是detached态,如果retval不为NULL,
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
      	    ENOTSUP： 输入参数inheritsched为无效的值
      	    
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
      	
      	    
      	    
	  int pthread_attr_getstack(const pthread_attr_t *attr, void **stackaddr, size_t *stacksize);

	
	 	返回值：
          	    0-成功 
        	
        							
```

- 获取和设置stack size(系统帮助分配内存，自己不用管)

``` c		
  
  	   int pthread_attr_setstacksize(pthread_attr_t *attr, size_t stacksize);
  	 
      	   
      	 参数:
      	    attr：属性信息,调用该函数后,*attr会被赋值
      	    stacksize:最好是pagesize的整数倍
      	    
      	     
      	返回值：
      	    0-成功 
      	    EINVAL：stacksize 小于 PTHREAD_STACK_MIN (16384) bytes.  或者 如果 stackaddr or
                                 stackaddr + stacksize is not suitably aligned.
                                
      
	  int pthread_attr_getstacksize(const pthread_attr_t *attr, size_t *stacksize);

	
	 	返回值：
          	    0-成功 
        	
        							
```

- 线程清理处理程序

``` c		
                 
      
  	   void pthread_cleanup_push(void (*routine)(void *), void *arg);
  	   
             描述：
                线程可以建立多个清理处理程序。处理程序记录在栈中，也就是说它们的执行顺序与它们注册时的顺序相反(栈的先入后出)
    	 
        	   
             参数:
                void (*routine)(void *) : 函数名
                arg:传入注册函数的参数
        	    
        	     
       
         
            注意：
                  只有当以下几种情况注册的函数才会被调用
                      (1):调用pthread_exit.
                      (2):作为对取消线程请求(pthread_cancel)的响应
                      (3):以非0参数调用pthread_cleanup_pop.
                      
                  如果只是简单的return,该注册函数不会被调用
        	
      	    
      	    
	   void pthread_cleanup_pop(int execute)
	   
	        描述：调用该函数时将pthread_cleanup_push压入的注册函数弹出,根据execute参数的值看执不执行注册函数.
	   
	        参数: 
	            0: 不执行清理函数
	            非零: 执行清理函数
	            

	
	 	返回值：
          	    0-成功 
          	    
          	    
       注意：
                   phtread_cleanup_push 与 phread_cleanup_pop要成对儿的出现，否则会报错(不管最后注册函数有没有被调用,
                    但phread_cleanup_pop函数一定要和phtread_cleanup_push函数数量一致，否则编译不通过)
           
                    
       pthread_cleanup_push(pthread_mutex_unlock, (void *) &mut);
       pthread_mutex_lock(&mut);
       /* do some work */
       pthread_mutex_unlock(&mut);
       pthread_cleanup_pop(0);
       
       如果线程处于PTHREAD_CANCEL_ASYNCHRONOUS状态，上述代码段就有可能出错，
       因为CANCEL事件有可能在pthread_cleanup_push()和pthread_mutex_lock()之间发生(这样会调用注册函数),
       或者在pthread_mutex_unlock()和pthread_cleanup_pop()之间发生,从而导致清理函数unlock一个并没有加锁的mutex变量，造成错误。
       因此应该暂时设置成PTHREAD_CANCEL_DEFERRED模式。
        	
        							
```

## 线程的同步问题

### 线程同步之互斥量(mutex)

#### 互斥锁的概念

``` c	

    它是最基本的同步工具，用于保护临界区（共享资源）,以保证在任何时刻只有一个线程能够访问共享的资源。

```
#### 互斥锁的接口

- 互斥量初始化和销毁

``` c	

    #include <pthread.h>
    
    int pthread_mutex_init(pthread_mutex_t *mutex, const pthread_mutexattr_t *attr);
    
    pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
    
    描述:
        对于动态分配的互斥量由于不能直接赋值进行初始化就只能采用pthread_mutex_init()函数进行初始化，
        pthread_mutex_init()的第二个参数是互斥量的属性,如果采用默认的属性设置,可以传入NULL.
        如果初始化成功,则 mutex 为unlocked状态
        
    参数:
        mutex : pthread_mutex_t的指针,要被赋值
        attr : mutex属性值,一般为NULL
        
    返回值:
        0:成功
        错误:
            EAGAIN: 系统缺少必要的资源(除了内存)来初始化这个互斥量
            ENOMEM: 内存不足
            EBUSY: 
            EINVAL: attr 属性无效
    注意:
        不能对相同mutex进行重复pthread_mutex_init()调用.
    
    
    int pthread_mutex_destroy(pthread_mutex_t *mutex);
    
    描述:
        当不在需要使用互斥量时，需要调用pthread_mutex_destroy()销毁互斥量所占用的资源.
        
    返回值:
        0:成功
        错误:
            EBUSY: 互斥量还在使用(lock状态), while being used in a pthread_cond_wait() or
                    pthread_cond_timedwait()) by another thread.
            EINVAL: 指定的mutex无效 
    注意:
        在调用pthread_mutex_destroy()函数后,不能再使用mutex,否则会出现不可预知的错误.如果还想使用mutex,则
        需要重新初始化该互斥量 pthread_mutex_init(). 要调用pthread_mutex_destroy()函数时,一定要确保
        mutex 的状态为 unlocked, 如果 mutex 还在使用(处于locked状态),调用pthread_mutex_destroy()函数
        会出问题.
    
```

- 互斥量使用(加锁和解锁)

``` c	

   #include <pthread.h>
   
   int pthread_mutex_lock(pthread_mutex_t *mutex);
   int pthread_mutex_trylock(pthread_mutex_t *mutex);
   int pthread_mutex_unlock(pthread_mutex_t *mutex); 
    
    描述:
        使用互斥量时采用的是默认的互斥量属性, pthread_mutex_trylock()是非阻塞等待,不管互斥量可不可以使用
        pthread_mutex_trylock()都是立即返回,成功返回0.
        
    参数:
        mutex :
        
    注意:
       互斥量的正确使用流程应该是：线程占用互斥量,然后访问共享资源,最后释放互斥量。(你占用互斥量的时候就应该是临界资源可用)
       而不应该是：线程占用互斥量，然后判断资源是否可用，如果不可用，释放互斥量，然后重复上述过程。这种行为称为轮转或轮询,
       是一种浪费CPU时间的行为.
        
    返回值:
        0:成功
        错误:
           
    
```

### 读写锁

#### 基本原理

``` c	
    当有一个线程已经持有互斥锁时,互斥锁将所有试图进入临界区的线程都阻塞住.
    但是考虑一种情形,当前持有互斥锁的线程只是要读访问共享资源,而同时有其它几个线程也想读取这个共享资源,
    但是由于互斥锁的排它性,所有其它线程都无法获取锁,也就无法读访问共享资源了,
    但是实际上多个线程同时读访问共享资源并不会导致问题.
    
    在对数据的读写操作中，更多的是读操作，写操作较少，
    例如对数据库数据的读写应用。为了满足当前能够允许多个读出,但只允许一个写入的需求，线程提供了读写锁来实现。
    
    读写锁的特点如下：
    1）如果有其它线程读数据，则允许其它线程执行读操作，但不允许写操作。
    2）如果有其它线程写数据，则其它线程都不允许读、写操作。
    
    读写锁分为读锁和写锁，规则如下：
    1）如果某线程申请了读锁，其它线程可以再申请读锁,但不能申请写锁。
    2）如果某线程申请了写锁，其它线程不能申请读锁,也不能申请写锁。
    
```
#### 接口函数

- 初始化读写锁

``` c		

    条件变量的创建：
    1.静态创建方式初始化读写锁变量   pthread_rwlock_t my_rwlock = PTHREAD_RWLOCK_INITIALIZER;
    
    2.动态方式初始化读写锁变量 
    
    int pthread_rwlock_init(pthread_rwlock_t *rwlock, const pthread_rwlockattr_t *attr); 
    
    描述:
        用来初始化 rwlock 所指向的读写锁。
    
    参数：
        rwlock：指向要初始化的读写锁指针
        attr：读写锁的属性指针.
              如果 attr 为 NULL 则会使用默认的属性初始化读写锁，否则使用指定的 attr 初始化读写锁
              
    返回值:
    		成功：0 (读写锁的状态将成为已初始化和已解锁)
    		失败: 非 0 错误码
        
```

- 申请读锁

``` c		
    
    int pthread_rwlock_rdlock(pthread_rwlock_t *rwlock ); 
    
    描述:
        以阻塞方式在读写锁上获取读锁（读锁定）.如果没有写者持有该锁,并且没有写者阻塞在该锁上，则调用线程会获取读锁。
        如果调用线程未获取读锁，则它将阻塞直到它获取了该锁。一个线程可以在一个读写锁上多次执行读锁定.
        线程可以成功调用 pthread_rwlock_rdlock() 函数 n 次,
        但是之后该线程必须调用 pthread_rwlock_unlock() 函数 n 次才能解除锁定.
    
    参数：
       rwlock：读写锁指针
              
    返回值:
    		成功：0 
    		失败: 非 0 错误码
    		
    		
    int pthread_rwlock_tryrdlock(pthread_rwlock_t *rwlock);
    
    描述:
        用于尝试以非阻塞的方式来在读写锁上获取读锁。如果有任何的写者持有该锁或有写者阻塞在该读写锁上,则立即失败返回.
        
    参数：
       rwlock：读写锁指针
              
    返回值:
            成功：0 
            失败: 非 0 错误码
        
```

- 申请写锁

``` c		
    
    int pthread_rwlock_wrlock(pthread_rwlock_t *rwlock ); 
    
    描述:
        在读写锁上获取写锁（写锁定）.如果没有写者持有该锁,并且没有写者读者持有该锁，则调用线程会获取写锁。
        如果调用线程未获取写锁，则它将阻塞直到它获取了该锁
    
    参数：
       rwlock：读写锁指针
              
    返回值:
    		成功：0 
    		失败: 非 0 错误码
    		
    		
    int pthread_rwlock_trywrlock(pthread_rwlock_t *rwlock); 
    
    描述:
        用于尝试以非阻塞的方式来在读写锁上获取写锁。如果有任何的读者或写者持有该锁，则立即失败返回。
        
    参数：
       rwlock：读写锁指针
              
    返回值:
            成功：0 
            失败: 非 0 错误码
        
```

- 解锁

``` c		
    
    int pthread_rwlock_unlock(pthread_rwlock_t *rwlock); 
    
    描述:
        无论是读锁或写锁，都可以通过此函数解锁
    
    参数：
       rwlock：读写锁指针
              
    返回值:
    		成功：0 
    		失败: 非 0 错误码
    	
        
```

- 销毁读写锁

``` c		
    
    int pthread_rwlock_destroy(pthread_rwlock_t *rwlock);
    
    描述:
        用于销毁一个读写锁，并释放所有相关联的资源（所谓的所有指的是由 pthread_rwlock_init() 自动申请的资源） 
    
    参数：
       rwlock：读写锁指针
              
    返回值:
    		成功：0 
    		失败: 非 0 错误码
    	
        
```

- 读写锁注意事项

```shell
    1.一般不建议使用读写锁，理由如下
            (1) 在后期维护阶段，很容易将误将读锁的临界区进行修改
            (2) 读写锁的开销要比 mutex 要大(因为要维护 reader 的数量)，如果临界区很小，则读写锁不一定比
            　　　mutex 快
            
```


### 同步的基础知识

- 条件变量

``` c		

    条件变量是利用线程间共享的全局变量进行同步的一种机制,一个线程要等待"条件变量成立"而阻塞,另一个线程
    能够使条件变量成立.条件变量的使用总是和互斥锁结合在一起
    
    每个条件变量总是和一个互斥量相关联,条件本身是由互斥量保护的,
    线程在改变条件状态之间必须要锁住互斥量. 条件变量相对于互斥量最大的优点在于允许线程以无竞争的方式等待条件的发生.
    当一个线程获得互斥锁后，发现自己需要等待某个条件变为真，如果是这样，该线程就可以等待在某个条件上，
    这样就不需要通过轮询的方式来判断添加，大大节省了CPU时间。
    互斥量是用于上锁，条件变量用于等待；
      							
```

- 条件变量的创建和注销

``` c		

    条件变量的创建：
    1.静态创建方式初始化条件变量  pthread_cond_t  cond = PTHREAD_COND_INITIALIZER
    
    2.动态方式初始化条件变量 
    int pthread_cond_init(pthread_cond_t *cond, pthread_condattr_t *cond_attr)
    
    参数：
        cond:条件变量被赋值
        cond_attr：通常为NULL. 因为LinuxThreads中没有实现
      		
      											
      											
   条件变量的注销
   
    int pthread_cond_destroy(pthread_cond_t *cond)  
     
    描述：
        
```

- 条件变量的使用

``` c		

    描述:
        对条件变量的阻塞等待, 函数返回后要进行具体内容的判断(可能会出现pthread_cond_wait被意外唤醒)

    int pthread_cond_wait(pthread_cond_t *cond, pthread_mutex_t *mutex)   
    
    描述:
        等待条件变为真
        pthread_cond_wait()函数用于阻塞等待条件被触发(另外线程调用pthread_cond_signal()函数).
        该函数传入两个参数,一个条件变量一个互斥量,而且必须是一一对应,不能调用pthread_cond_wait()函数时
        用多个不同的mutex对应同一个cond,否则会出问题的.
        函数将条件变量和互斥量进行关联,互斥量对该条件进行保护,传入的互斥量必须是已经锁住的.
        调用pthread_cond_wait()函数后，会原子的执行以下两个动作：
                将调用线程放到等待条件的线程列表上，即进入睡眠(阻塞状态)；
                对互斥量进行解锁；
                
         注意: 在开始调用pthread_cond_wait()函数后,且还没返回(一直在阻塞状态),这个情况下会对互斥量进行暂时解锁,
         在pthread_cond_wait()函数成功返回后,则互斥量的状态时 locked 状态. 
        由于这两个操作时原子操作,这样就关闭了条件检查和线程进入睡眠等待条件改变这两个操作之间的时间通道.
        这样就不会错过任何条件的变化。
        当pthread_cond_wait()返回后,互斥量会再次被锁住.
        
    返回值:
        0:成功
        
        
    int  pthread_cond_timedwait(pthread_cond_t  *cond, pthread_mutex_t  *mutex,   
                                const struct timespec *abstime) ;
                                
    描述:
        限时等待条件为真
        pthread_cond_timedwait()函数和pthread_cond_wait()的工作方式相似,只是多了一个等待时间.
        
        struct timespec{  
        time_t  tv_sec    //Seconds.  
        long    tv_nsec   //Nanoseconds.  
        };  
        
        函数要求传入的时间值是一个绝对值,不是相对值,例如，想要等待3分钟，必须先获得当前时间，然后加上3分钟.
        
        如果时间到后，条件还没有发生，那么会返回ETIMEDOUT错误。
        
    返回值:
        0: 成功
    
        
  向等待条件的线程发送唤醒信号
  (These two functions are used to unblock threads blocked on a condition variable.):
  
    注意:
        一定要在改变条件状态后，再给线程发送信号.一定要坚持使用广播发送pthread_cond_broadcast().
        
    int pthread_cond_signal(pthread_cond_t *cond);
    
    描述:
        唤醒一个等待条件的线程
        
    返回值:
        0: 成功
        
        
    int pthread_cond_broadcast(pthread_cond_t *cond);
    
    描述:
        唤醒等待该条件的所有线程
        
    返回值:
         0: 成功
        
```

- 注意

```c
    1.当　pthread_cond_wait() 函数返回时要考虑到虚假唤醒(即使没有线程broadcast 或者signal条件变量，wait也可能偶尔返回)
            实例:
                 
                线程一:    
                    pthread_mutex_lock(mtx);
                    while(deque.empty())        //　这边一定要进行 while 判断而不是 if,防止有虚假唤醒的情况
                        pthread_cond_wait(...);
                    deque.pop_front();
                    pthread_mutex_unlock(mtx);
                 
                线程二:
                    pthread_mutex_lock(mtx);
                    deque.push_back(x);
                    pthread_cond_signal(...);
                    pthread_mutex_unlock(mtx)
        

```

#### 信号量控制

##### 信号量的基本概念

``` c		

    线程的信号量与进程间通信中使用的信号量的概念是一样, 它是一种特殊的变量，它可以被增加或减少，
    但对其的关键访问被保证是原子操作.如果一个程序中有多个线程试图改变一个信号量的值，系统将保证所有的操作都将依次进行。

    而只有0和1两种取值的信号量叫做二进制信号量,在这里将重点介绍.而信号量一般常用于保护一段代码,
    使其每次只被一个执行线程运行。我们可以使用二进制信号量来完成这个工作。
      							
```

##### 信号量接口

- 创建信号量

``` c		

    int sem_init(sem_t *sem, int pshared, unsigned int value);  
    
    描述:
        sem_init() 初始化 sem 的匿名信号量. value 参数指定信号量的初始值。
        如果是进程内的线程共享,信号量sem要放置在所有线程都可见的地址上(如全局变量，或者堆上动态分配的变量)。
        如果是进进程之间共享,信号量sem要放置在共享内存区域(shm_open(3)、mmap(2) 和 shmget(2))。
        (因为通过 fork(2) 创建的孩子继承其父亲的内存映射，因此它也可以见到这个信号量。)
        所有可以访问共享内存区域的进程都可以使用sem_post(3)、sem_wait(3) 等等操作信号量。
        初始化一个已经初始的信号量其结果未定义.
    
    参数：
        sem: 信号量指针,要被赋值
        pshared：指明信号量是由进程内线程共享,还是由进程之间共享
                 0:进程内的线程共享
                 非零值: 进程之间共享
                 
        value : 信号量的初始值
   
    返回值:
        成功: 0
        失败: -1 ,并把 errno 设置为合适的值, errno值如下:
        
                EINVAL: value超过 SEM_VALUE_MAX。
                ENOSYS: pshared 非零,但系统还没有支持进程共享的信号量。
        						
```

- 控制信号量

``` c		

    int sem_wait(sem_t * sem);   
    
    描述:
        信号量减一操作.
        sem_wait函数也是一个原子操作,它的作用是从信号量的值减去一个“1”,
        但它永远会先等待该信号量为一个非零值才开始做减法.也就是说，如果你对一个值为2的信号量调用sem_wait(),线程将会继续执行.
        这信号量的值将减到1。
        如果对一个值为0的信号量调用sem_wait()，这个函数就会阻塞等待直到有其它线程增加了这个值使它不再是0为止.
        如果有两个线程都在sem_wait()中等待同一个信号量变成非零值，那么当它被第三个线程增加 一个“1”时,
        等待线程中只有一个能够对信号量做减法并继续执行.另一个还将处于阻塞等待状态。
   
    返回值:
        成功: 0
        失败: -1 ,并把 errno 设置为合适的值, errno值如下:
        
                EINTR: 这个调用被信号处理器中断
                EINVAL: sem 不是一个有效的信号量
                
                
    int sem_post(sem_t * sem);
    
    描述:
        sem_post函数的作用是给信号量的值加上一个“1”，它是一个“原子操作"
        即同时对同一个信号量做加“1”操作的两个线程是不会冲突的；
        而同时对同一个文件进行读、加和写操作的两个程序就有可能会引起冲突。
        信号量的值永远会正确地加一个“2”－－因为有两个线程试图改变它
        	
    返回值:
        成功: 0
        失败: -1 ,并把 errno 设置为合适的值, errno值如下:
        
                EINVAL: sem 不是一个有效的信号量
                EOVERFLOW: 信号量允许的最大值将要被超过
```

- 清理信号量

``` c		

   int sem_destroy (sem_t *sem);  
    
    描述:
    这个函数也使用一个信号量指针做参数,归还自己申请的一切资源.在清理信号量的时候如果还有线程在等待它,用户就会收到一个错误.
   
    返回值:
        成功: 0
        失败: -1 
                           
```

### 多线程下变量-原子操作 __sync_fetch_and_add

```c

    type __sync_fetch_and_add (type *ptr, type value);
    type __sync_fetch_and_sub (type *ptr, type value);
    
    参数：
            ptr：type只能是int long  ，long long（及对应unsigned类型）
    
    在多线程中,要对临界资源进行互斥(原子操作)
    
    type __sync_fetch_and_add (type *ptr, type value) 
    等于
         　pthread_mutex_lock(&count_lock);
          global_int++;
          pthread_mutex_unlock(&count_lock);
          
    但是　type __sync_fetch_and_add (type *ptr, type value) 效率比互斥锁要高
    
     __sync_fetch_and_add()函数与　 __sync_add_and_fetch()函数的区别：
     
        count = 4
        count = __sync_fetch_and_add(&count, 1)    返回值是4 ,跟　i++类似
        
        count = 4
        count = __sync_add_and_fetch(&count, 1)    返回值是５ ,跟　++i类似
```

## 乐观锁和悲观锁

```shell
    1. 悲观锁(Pessimistic Lock): 每次去拿数据的时候都认为别人会修改，所以每次在拿数据的时候都会上锁，
                               这样别人想拿这个数据就会阻塞直到它拿到锁. Java synchronized 就属于悲观锁的一种实现
    2. 乐观锁(Optimistic Lock): 每次去拿数据的时候都认为别人不会修改，所以不会上锁，但是在提交更新的时候会判断一下在此期间别人
                               有没有去更新这个数据。乐观锁适用于读多写少的应用场景，这样可以提高吞吐量。
            乐观锁实现的 2 中方式:
                A. 使用数据版本(Version)记录机制实现(常用)。为数据增加一个版本标识，通过为数据库表增加一个数字类型的 “version” 字段
                　　来实现。当读取数据时，将 version 字段的值一同读出，数据每更新一次，对此 version 值加一。
                   当我们提交更新的时候，判断数据库表对应记录的当前版本信息与第一次取出来的 version 值进行比对，
                   如果数据库表当前版本号与第一次取出来的 version 值相等，则予以更新，否则认为是过期数据。
                B. 使用时间戳(timestamp), 在更新提交的时候检查当前数据库中数据的时间戳和自己更新前取到的时间戳进行对比，
                   如果一致则OK，否则就是版本冲突
                   
```

## 分布式锁

```shell
    1. 分布式锁: 分为基于 Redis 和基于 Zookeeper
    2. 基于 Redis 的分布式锁
            在任意时刻，只有一个客户端可以获得锁(排他性), Redis 的锁服务的做法是通过超时时间来释放锁, 所以 
            客户端最终一定可以获得锁.
    3. Redis 分布式锁服务的问题
           (1) Redis 的锁服务超时释放锁导致的问题．例如，A 服务先得到锁，但 A 服务因为 IO 等待阻塞了，而此时因为锁超时
           　　导致被释放(A 服务还不知道)，这时 B 服务成功的获得锁，要对其管理的资源进行操作，刚好此时 A 服务右就绪，继续
           　　处理数据，这时候对应的数据就乱了
           (2) 解决方案一: 乐观锁机制(需要一个版本号排它)，该锁的版本号是由 Redis 提供的
                           当 A 服务获得锁时，会得到一个锁的版本号(Version:76),该锁的版本号是由 Redis 提供的，
                           A 服务因为 IO 等待阻塞了，而此时因为锁超时致被释放,B 服务成功的获得锁,
                           B 服务得到更高的该锁的版本号(Version:77), 此时对资源进行操作需要
                           验证锁的版本号是不是比之前要高，如果要高则运行进行操作，如果低的话则不允许操作．
```