# Study
## IRQ
IRQ means Interrupt ReQuest.
top half: hard irq
bottom halves:
- softirq
- tasklet
- workqueue

Who calls IRQ?
: Nothing in the kernel calls an interrupt handler. devices raise the request.
So, hardware initiates, the kernel dispatches, your handler runs.
When is IRQ called?
: a time whenever devices want.

### Context
There are two contexts: task (process) context and interrupt context.
What actually distinguishes them is whose work is this code doing.
In task context, the kernel is running on *behalf* of *current*.
In interrupt context, the kernel has *hijacked* whichever task happened to be on the CPU.
```
Process context
    Task A
      ↓
   system call (by trap)
      ↓
   kernel code
      ↓
   return to Task A


Interrupt context
    Task A
      ↓
    IRQ!
      ↓
interrupt handler
      ↓
    Task A
```

### What's the relationship between IRQ and Scheduler?
1. Interrupts drive the scheduler

The scheduler is passive code — it only runs when something calls `schedule()`. The timer interrupt is what guarantees that happens periodically. Every tick (CONFIG_HZ, typically 250 or 1000) the timer IRQ fires and calls `sched_tick()`, which:

- updates the current task's runtime accounting (vruntime/lag under EEVDF, timeslice under SCHED_RR)
- decides whether the task has run long enough
- if so, sets `TIF_NEED_RESCHED` on it

2. Interrupts are also when preemption happens

`TIF_NEED_RESCHED` is only a flag. The actual switch occurs at a **preemption point**, and the main one is `irq_exit()` — on the way out of any interrupt, the kernel checks the flag and calls `schedule()` if set.

So the sequence is: interrupt arrives → handler runs → softirqs run → on exit, check flag → maybe switch tasks.
*Every interrupt is an opportunity for the scheduler to act*, which is why interrupt frequency and scheduling responsiveness are linked.

The other preemption points are return-to-userspace, explicit `cond_resched()`, and — with CONFIG_PREEMPT/PREEMPT_RT — any point where preempt_count drops back to zero.

### What is the interrupt?
An interrupt is a control transfer.
Interrupts are the mechanism by which the OS retains authority over hardware it has handed to a user program.
An interrupt is a signal.

```C
/**
 * irq_enter - Enter an interrupt context including RCU update
 */
void irq_enter(void)
{
	ct_irq_enter();
	irq_enter_rcu();
}
```
```C
/**
 * irq_exit - Exit an interrupt context, update RCU and lockdep
 *
 * Also processes softirqs if needed and possible.
 */
void irq_exit(void)
{
	__irq_exit_rcu();
	ct_irq_exit();
	 /* must be last! */
	lockdep_hardirq_exit();
}
```

### How to trigger an interrupt
`sudo dd if=/dev/hwrng of=/dev/null bs=64 count=1`
This command occur an interrupt of `cat /proc/interrupts` in terms of CPU0
```
53: ... GICv2m-PCI-MSIX-0000:00:08.0   1 Edge      virtio4-input
```
This is about /dev/hwrng.

`cat /dev/hwrng` is flood of interrupt # 53!

I got you! in trace_pipe when enabling event/irq
```
 572452           <idle>-0       [000] d.h1.  8236.490081: irq_handler_entry: irq=53 name=virtio4-input
 572453           <idle>-0       [000] d.h1.  8236.490082: irq_handler_exit: irq=53 ret=handled
```

### What resources are associated with interrupt
#### Memory related
I guess
`/sys/kernel/tracing/events/dma*`
`/sys/kernel/tracing/events/gpu_mem`
`/sys/kernel/tracing/events/kmem*`
`/sys/kernel/tracing/events/mmap*`
, which show nothing worth at a benign test with ftrace.





