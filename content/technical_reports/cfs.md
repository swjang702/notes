# Linux CFS

## What I know currently
- All tasks share equal CPU time ideally.
- Linux CFS leverage a concept of virtual runtime aka vruntime.


## What I don't know


## What I want to know
~~- entrypoint (e.g., runqueue, cpu)~~
~~- what is the unit of a task?~~
~~- How to know current running task process owning CPU.~~
- What about multi-core processor?
- What is vruntime?


## Hypotheses


## Concept
A task in Linux scheduler is a runnable thread.


### Syscalls Sched
From the manpages, the number of sched syscalls is only fifteen.
```bash
   nice(2)
          Set a new nice value for the calling thread, and return the new nice value.

   getpriority(2)
          Return the nice value of a thread, a process group, or the set of threads owned by a specified
          user.

   setpriority(2)
          Set the nice value of a thread, a process group, or the set of threads owned  by  a  specified
          user.

   sched_setscheduler(2)
          Set the scheduling policy and parameters of a specified thread.

   sched_getscheduler(2)
          Return the scheduling policy of a specified thread.

   sched_setparam(2)
          Set the scheduling parameters of a specified thread.

   sched_getparam(2)
          Fetch the scheduling parameters of a specified thread.

   sched_get_priority_max(2)
          Return the maximum priority available in a specified scheduling policy.

   sched_get_priority_min(2)
          Return the minimum priority available in a specified scheduling policy.

   sched_rr_get_interval(2)
          Fetch  the quantum used for threads that are scheduled under the "round-robin" scheduling pol‐
          icy.

   sched_yield(2)
          Cause the caller to relinquish the CPU, so that some other thread be executed.

   sched_setaffinity(2)
          (Linux-specific) Set the CPU affinity of a specified thread.

   sched_getaffinity(2)
          (Linux-specific) Get the CPU affinity of a specified thread.

   sched_setattr(2)
          Set the scheduling policy and parameters of a specified thread.  This (Linux-specific)  system
          call provides a superset of the functionality of sched_setscheduler(2) and sched_setparam(2).

   sched_getattr(2)
          Fetch  the scheduling policy and parameters of a specified thread.  This (Linux-specific) sys‐
          tem call provides a superset of the  functionality  of  sched_getscheduler(2)  and  sched_get‐
          param(2).
```

In my test code, I confirmed three syscalls, *getpriority, setpriority, and sched_getscheduler*.
Fun fact is a scheduler policy is set per pid. what does it mean? All tasks run in its own policy?

### Entrypoint in the kernel
Where is an entrypoint of scheduling operation in the linux kernel?
Scheduling is initiated by timer interrupt. The timer interrupt calls *sched_tick()* (*scheduler_tick()* in order version) to prepare a next scheduling task, which calculates load average, updates a runqueue, calls resched_curr(rq), delegate to sched_class->task_tick(), and so on.
In short, as `sched_tick()` is the entry point of Linux scheduling, it doesn't work about real scheduling policy but preprocess for it.

*/kernel/sched/core.c*
```bash
/*
 * This function gets called by the timer code, with HZ frequency.
 * We call it with interrupts disabled.
 */
void sched_tick(void)
{
	int cpu = smp_processor_id();
	struct rq *rq = cpu_rq(cpu);
	/* accounting goes to the donor task */
	struct task_struct *donor;

    ...

	if (dynamic_preempt_lazy() && tif_test_bit(TIF_NEED_RESCHED_LAZY))
		resched_curr(rq);
}
```

The next question can be how to know current running task process owning CPU. We can find the answer on the same code.
The `sched_tick()` uses task_struct \*donor variable. In the code, it gets a cpu id from smp_processor_id(), and acquire a runqueue pointer `*rq` from cpu_rq(cpu), and finally the donor set by
`donor = rq->donor;`
From this code, we can know that each cpu has its own runqueue which has a member donor being used in preprocessing of scheduling in interrupt context for a next run task.
Yeap, we learn about the donor task in runqueue. If so, the donor is the current running task in the cpu?
To confirm it, see this code.

*/kernel/sched/sched.h*
```bash
/*
 * This is the main, per-CPU runqueue data structure.
 *
 * Locking rule: those places that want to lock multiple runqueues
 * (such as the load balancing or the thread migration code), lock
 * acquire operations must be ordered by ascending &runqueue.
 */
struct rq {
    ...
	union {
		struct task_struct __rcu *donor; /* Scheduler context */
		struct task_struct __rcu *curr;  /* Execution context */
	};
    ...
}
```

In this, we find that donor is the task! but in scheduler context. We are finding the current **running** task. In a execution context, it looks be `curr` task.
Let us prove it with this command
`linux-6.19.8/kernel/sched$ rg -n 'rq->curr' fair.c core.c sched.h`
Got it! There are some interesting lines.

```bash
core.c
1104:	struct task_struct *curr = rq->curr;

fair.c
717:	struct sched_entity *curr = cfs_rq->curr;
1243:		struct task_struct *running = rq->curr;

sched.h
2322: * rq->curr == rq->donor == p.
```

From this, we now learn that there is a time that rq->curr equals rq->donor, which would be an intersection between Scheduler context and Execution context. And cfs implements its own runqueue cfs_rq and uses struct sched_entity for the curr task.
We wonder which functions call those line.

```bash
core.c
 1095 /*
 1096  * resched_curr - mark rq's current task 'to be rescheduled now'.
 1097  *
 1098  * On UP this means the setting of the need_resched flag, on SMP it
 1099  * might also involve a cross-CPU call to trigger the scheduler on
 1100  * the target CPU.
 1101  */
 1102 static void __resched_curr(struct rq *rq, int tif)
 1103 {
 1104     struct task_struct *curr = rq->curr;
 1105     struct thread_info *cti = task_thread_info(curr);
```

Got ya! Nice to see you again `resched_curr()`! Do you remember this code mentioned earlier in `sched_tick()`? Let's see carefully. The comment and the code say that `rq->curr` is the rq`s current task. Is it enough to be proved? I would yes and keep taking a look other points.
What the function works is just setting a bit, tif.
And it looks a moment when the current task will be switched to an waiting task in rq. i.e., to be rescheduled.

Let's take a look another code in fair.c and sched.h.

```bash
fair.c
 1231 static s64 update_se(struct rq *rq, struct sched_entity *se)
 1232 {
 1233     u64 now = rq_clock_task(rq);
 1234     s64 delta_exec;
 1235
 1236     delta_exec = now - se->exec_start;
 1237     if (unlikely(delta_exec <= 0))
 1238         return delta_exec;
 1239
 1240     se->exec_start = now;
 1241     if (entity_is_task(se)) {
 1242         struct task_struct *donor = task_of(se);
 1243         struct task_struct *running = rq->curr;
 1244         /*
 1245          * If se is a task, we account the time against the running
 1246          * task, as w/ proxy-exec they may not be the same.
 1247          */
 1248         running->se.exec_start = now;
 1249         running->se.sum_exec_runtime += delta_exec;
```

First of all, from this, we know that sched_entity can not be a task!
Second, a current time of rq is acquired by `rq_clock_task(rq)`.

```bash
fair.c
  703 /*
  704  * Specifically: avg_vruntime() + 0 must result in entity_eligible() := true
  705  * For this to be so, the result of this function must have a left bias.
  706  *
  707  * Called in:
  708  *  - place_entity()      -- before enqueue
  709  *  - update_entity_lag() -- before dequeue
  710  *  - entity_tick()
  711  *
  712  * This means it is one entry 'behind' but that puts it close enough to where
  713  * the bound on entity_key() is at most two lag bounds.
  714  */
  715 u64 avg_vruntime(struct cfs_rq *cfs_rq)
  716 {
  717     struct sched_entity *curr = cfs_rq->curr;
  718     long weight = cfs_rq->sum_weight;
  719     s64 delta = 0;
  720
  721     if (curr && !curr->on_rq)
  722         curr = NULL;
  723
  724     if (weight) {
  725         s64 runtime = cfs_rq->sum_w_vruntime;
  726
  727         if (curr) {
  728             unsigned long w = scale_load_down(curr->load.weight);
  729
  730             runtime += entity_key(cfs_rq, curr) * w;
  731             weight += w;
  732         }
  733
  734         /* sign flips effective floor / ceiling */
  735         if (runtime < 0)
  736             runtime -= (weight - 1);
  737
  738         delta = div_s64(runtime, weight);
  739     } else if (curr) {
```

Wow, we happen to reach out a sort of vruntime stuff!
Through skimming, it's about EEVDF due to eligible and lag mentions. And also, it's about some calculating stuff. Probably weight and vruntime. Let's take a look closely later in an EEVDF note.
And we see that EEVDF actually built on existing CFS infrastructure.

Lastly, let us look at sched.h a moment

```bash
2310 /*
2311  * Is p the current execution context?
2312  */
2313 static inline int task_current(struct rq *rq, struct task_struct *p)
2314 {
2315     return rq->curr == p;
2316 }
2317
2318 /*
2319  * Is p the current scheduling context?
2320  *
2321  * Note that it might be the current execution context at the same time if
2322  * rq->curr == rq->donor == p.
2323  */
2324 static inline int task_current_donor(struct rq *rq, struct task_struct *p)
2325 {
2326     return rq->donor == p;
2327 }
2328
2329 static inline bool task_is_blocked(struct task_struct *p)
2330 {
2331     if (!sched_proxy_exec())
2332         return false;
2333
2334     return !!p->blocked_on;
2335 }
2336
2337 static inline int task_on_cpu(struct rq *rq, struct task_struct *p)
2338 {
2339     return p->on_cpu;
2340 }
2341
2342 static inline int task_on_rq_queued(struct task_struct *p)
2343 {
2344     return READ_ONCE(p->on_rq) == TASK_ON_RQ_QUEUED;
2345 }
```

Good. Thankfully, this is the second proof of our assumption that rq->curr is the current running task.
Moreover, here some useful static inline functions. And also we confirm that out hypothesis is true, which is about the moment scheduling context equals execution context. Currently, we don't know what it means exactly, but it might be a pitfall later.


## Tests

- cfs.c : usage of sched-related syscalls
- main.c : user-space program for eBPF
- sched.bpf.c : a bpf program to use tracepoints and important kernel function in connection with sched.

I write a simple C code to learn usage of all sched-related syscalls. Also, to check hooks including tracepoints and kernel functions, I leverage eBPF program. One advantage of this way is that it can also be used to test sched_ext which is bpf level external scheduler in Linux. Thus, I choose eBPF to confirm kernel operations.

### Setup
- Linux 6.19.8

### Results
- One figure to depict Linux CFS operation.
- One graph that takes all processes as X-axis and CPU time sharing as Y-axis.


## Limitations


## Lessons


## Conclusions


## References
[1] Arpaci-Dusseau, Remzi H., and Andrea C. Arpaci-Dusseau. Operating systems: Three easy pieces. Vol. 1. Madison, WI, USA: Arpaci-Dusseau Books, LLC, 2018.

[2] [LLC 2025 - Linux scheduler overview and update, by Linus Walleij](https://youtu.be/T9Q7HrQwz2I?si=LH3v3JuMgB2QpZh8)

[3] https://docs.kernel.org/scheduler/sched-design-CFS.html

[4] Bouron, Justinien, Sebastien Chevalley, Baptiste Lepers, Willy Zwaenepoel, Redha Gouicem, Julia Lawall, Gilles Muller, and Julien Sopena. "The battle of the schedulers:{FreeBSD}{ULE} vs. linux {CFS}." In 2018 USENIX Annual Technical Conference (USENIX ATC 18), pp. 85-96. 2018.
