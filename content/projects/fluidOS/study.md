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

### Kernel Context
There are two contexts: task (process) context and interrupt context.
What actually distinguishes them is whose work is this code doing.
In task context, the kernel is running on *behalf* of *current*.
In interrupt context, the kernel has *hijacked* whichever task happened to be on the CPU.
```
Process context
    Task A
      ↓
   system call
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

The scheduler is passive code — it only runs when something calls `schedule()`. The timer interrupt is what guarantees that happens periodically. Every tick (CONFIG_HZ, typically 250 or 1000) the timer IRQ fires and calls `scheduler_tick()`, which:

- updates the current task's runtime accounting (vruntime/lag under EEVDF, timeslice under SCHED_RR)
- decides whether the task has run long enough
- if so, sets `TIF_NEED_RESCHED` on it

2. Interrupts are also when preemption happens

`TIF_NEED_RESCHED` is only a flag. The actual switch occurs at a **preemption point**, and the main one is `irq_exit()` — on the way out of any interrupt, the kernel checks the flag and calls `schedule()` if set.

So the sequence is: interrupt arrives → handler runs → softirqs run → on exit, check flag → maybe switch tasks.
*Every interrupt is an opportunity for the scheduler to act*, which is why interrupt frequency and scheduling responsiveness are linked.

The other preemption points are return-to-userspace, explicit `cond_resched()`, and — with CONFIG_PREEMPT/PREEMPT_RT — any point where preempt_count drops back to zero.
