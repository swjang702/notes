# Overview

## Topic: Laundering Attack (Cont'd)

## Goal of this work: Find answers to the questions about laundering attack
- Construct a theoretically valid foundation for our hypothesis and test.

## Final data


----

# Think (Mon)

## Questions to dive into
- What does the pair of enqueue/dequeue mean?
    -> I think I should know the flow of eevdf scheduling
    -> Why do you choose dequeue_task_fair to get a vlag?
    - [Q6.2] How, when, and where are metrics(vd, vruntime, ve, and vlag) calculated? [`Implementation`]

----

# Input (Tue)

## What to know/study


----

# Output (Wed&Thr)

### The flow of EEVDF Scheduling
- Claude artifact: https://claude.ai/artifact/B7xecXMzjVwwMvdoXTqoBj
- Scheduling flow tracer: `sunwoojang@fedora:~/fluidos/laundering$ sudo bpftrace ./eevdf_trace.bt ls`
--> NEED TO UPDATE: draw it on my own

### Odds and ends
- To confirm base_slice: `sudo cat /sys/kernel/debug/sched/base_slice_ns`

### Scheduling and CPU Migration: enqueue comes first rather than context_switch
For the task being **switched in**, enqueue always precedes the context switch. pick_next_task() can only select from the runqueue, and context_switch() only runs on what was picked:

try_to_wake_up()                       ← or wake_up_new_task() at fork
  select_task_rq_fair()                ← choose CPU (migration happens here)
  activate_task() → enqueue_task_fair()
      place_entity()                   ← set vruntime from vlag, set deadline
      __enqueue_entity()               ← insert into rbtree
  wakeup_preempt()                     ← maybe set TIF_NEED_RESCHED
        ...
__schedule()
  pick_next_task() → pick_eevdf()      ← eligible + earliest deadline
  context_switch()                     ← last step

For the task being **switched out**, the order depends on why it's leaving:

reason	                    sequence
blocks (sleep, I/O, wait())	dequeue → pick next → context switch
preempted, still runnable	pick next → context switch; no dequeue at all
migrated while running	    context switch out → dequeue (source) → set_task_cpu() → enqueue (destination) → pick → context switch in


----

# Analyze (Fri)


----

# Sum up (Sat)
- [Q1.1.1'.1.1.2.1] [Anomaly] Why did the `ps` pick up ahead of enqueue?
  - [A1.1.1'.1.1.2.1] To trace accurately it again with a simple bpf tracer??
    -> Why do you want trace? -> to see how eevdf works.
    -> Why do you want to see? -> to fully understand it.
    -> humm. OK. What do you want to see? -> First of all, simple version, varying of lag, deadline, vruntime, and picking behavior.
    -> Ok. To get them, which functions should you look into?

## Final prose 📄
To fully understand operations of EEVDF, we draw flow diagrams and call graphs of core functions.
The EEVDF scheduler executes by this order: wait/fork (creation sched entity), enqueue to a per-cpu runqueue, picking up to run, running&ticking, resched or dequeue.
As this is a core flow of EEVDF scheduling policy, CPU migration (context switching) and timer interrupt, of course, are occurs asyncrounously between the flows.
For example, based on the result of our simple tracer to executing `ls` command, the entrypoint of scheduling is the fork() from bash, where \_\_sched\_fork() and wake_up_new_task() are invoked.
While following the flow, CPU migration can be happened, which follows by dequeue, context switching (losing owning CPU), setting new CPU, enqueue, picking up to run, context switching (take the CPU), and ticking again.

## Questions to dive next
- [Q1.1.1'.1.1.1.2] What is the khugepaged, whose vlag was over the limit?⭐️
- [Q8] What is CBS?
- [Q6.3] Where do I feel the fluid-state system of EEVDF in the code base or its relationships?

