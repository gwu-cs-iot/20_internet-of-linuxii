**Objective**
Link the linux kernel library to composite so that composite can use a subset of linux

**Components**
1. We need to be able to compile lkl with composite, this means we need to add lkl as a library and have the correct structure so that lkl will know where all the header files it needs to include are. This requires a decent amount of knowledge of how composite treats libraries as well as how lkl defines its include structure.

2. Host Operations need to be defined so that the linux kernel can run on a host system. 

Taken from https://github.com/lkl/linux/blob/master/arch/lkl/include/uapi/asm/host_ops.h
   ```
   lkl_host_operations - host operations used by the Linux kernel

   These operations must be provided by a host library or by the application
   itself.
  
   @virtio_devices - string containg the list of virtio devices in virtio mmio
   command line format. This string is appended to the kernel command line and
   is provided here for convenience to be implemented by the host library.
  
   @print - optional operation that receives console messages
  
   @panic - called during a kernel panic
  
   @sem_alloc - allocate a host semaphore an initialize it to count
   @sem_free - free a host semaphore
   @sem_up - perform an up operation on the semaphore
   @sem_down - perform a down operation on the semaphore
  
   @mutex_alloc - allocate and initialize a host mutex; the recursive parameter
   determines if the mutex is recursive or not
   @mutex_free - free a host mutex
   @mutex_lock - acquire the mutex
   @mutex_unlock - release the mutex
  
   @thread_create - create a new thread and run f(arg) in its context; returns a
   thread handle or 0 if the thread could not be created
   @thread_detach - on POSIX systems, free up resources held by
   pthreads. Noop on Win32.
   @thread_exit - terminates the current thread
   @thread_join - wait for the given thread to terminate. Returns 0
   for success, -1 otherwise
  
   @tls_alloc - allocate a thread local storage key; returns 0 if successful; if
   destructor is not NULL it will be called when a thread terminates with its
   argument set to the current thread local storage value
   @tls_free - frees a thread local storage key; returns 0 if succesful
   @tls_set - associate data to the thread local storage key; returns 0 if
   successful
   @tls_get - return data associated with the thread local storage key or NULL
   on error
  
   @mem_alloc - allocate memory
   @mem_free - free memory
  
   @timer_create - allocate a host timer that runs fn(arg) when the timer
   fires.
   @timer_free - disarms and free the timer
   @timer_set_oneshot - arm the timer to fire once, after delta ns.
   @timer_set_periodic - arm the timer to fire periodically, with a period of
   delta ns.
  
   @ioremap - searches for an I/O memory region identified by addr and size and
   returns a pointer to the start of the address range that can be used by
   iomem_access
   @iomem_acess - reads or writes to and I/O memory region; addr must be in the
   range returned by ioremap
  
   @gettid - returns the host thread id of the caller, which need not
   be the same as the handle returned by thread_create
  
   @jmp_buf_set - runs the give function and setups a jump back point by saving
   the context in the jump buffer; jmp_buf_longjmp can be called from the give
   function or any callee in that function to return back to the jump back
   point
  
   NOTE: we can't return from jmp_buf_set before calling jmp_buf_longjmp or
   otherwise the saved context (stack) is not going to be valid, so we must pass
   the function that will eventually call longjmp here
  
   @jmp_buf_longjmp - perform a jump back to the saved jump buffer
  ```

Immediately there are some host operations that composite will take care of with relative ease. 
However, composite does not implement a posix interface, therefore we will have to hack and create some of our own host operations in a way that the linux kernel library can use. The first operation I believe we will have to immediately take care of is lkl_longjump and set_jmp. My hypothesis is that these threads are used when we go from a host thread to a non host thread. Or this could mean when we are in a thread that is running inside of composite to a thread that we want to run inside of the linux kernel library. However, the linux environment expects there is a certain amount of metadata about a thread and its stack when it is passed. However, composite does not do this, so it may be difficult to implement these. 

I want component 1 to be completed by checkpoint 1 and component 2 to be completed by checkpoint 2. I think it is really important not to rush the process and prioritize hacky code because it is extremely easy to get buried under the complexity of the linux system. 

I have wrote some initial steps and thoughts about the components and put them as pdfs in this readme.

**Security**

Through this project I am enabling composite to have more application and functionality by providing these libraries. An example of this is how we could get device drivers running on composite. Because composite is scalable and can be run on embedded systems and allows components that used to trust each other to not trust each other anymore and  lkl will be on composite I need to prioritize designing a safe, secure but efficient system. I will be following some of the guidelines on how to build secure internet of things system:

**“Incorporate Security at the design phase” **
I will be using the most recent security features and API’s that composite provides throughout the entire design process. I will also meet with Gabe throughout the process to make sure everything I am doing is not compromising the composite system.

**“Promote security updates and vulnerability management” **
I will be running composite and lkl through a bed of automated test suites that will make sure the lkl and composite communication is both safe and secure. Also, because linux and lkl is updated frequently and is serviced by a host of developers we can be sure we are on an updated system.

**“Build on recognized security practices”**
I will make sure that I am following secure operating system design practices. For example I was thinking about using a global variable for metadata about threads; however, operations and designs might be insecure. So it warrants thinking about my design choices and making sure they follow a secure protocol. 


**“Prioritize security measures according to potential impact”**
I need to make sure that while I am ensuring safe and secure handling of threads within the library, I need to prioritize keeping composite secure by not violating policies that will give lkl ultra high access. 

**Promote Transparency across Iot**
Because composite is open source, my project will be as well. This means that if someone finds that I am violating policies that are making composite less secure they can update the code or let me know. 

**Connect carefully and deliberately **
A lot of lkl is focused around drivers which can be network drivers. This means we need to prioritize that we are making our connections deliberately and with purpose.

I will be doing everything. 
