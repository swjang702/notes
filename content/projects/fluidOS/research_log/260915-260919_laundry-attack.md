# Overview

## (Quote)
```
- **The laundering attack (R3/O2):** construct an adversarial urgency signal that cycles a
task through the tier to beat Bound 2's fairness-to-others. If full-repayment doesn't close
it, the design has a hole.
    - R3: Ledger rule (promotion/demotion).
    - Open decision O2: does urgent service accrue lag debt at the normal rate (full repayment) or at a discounted rate (urgency partially “forgiven”)?
Full repayment is the conservative default and the provable one; start there.

* Bound 2 (normal-class response time). For a normal task's job of work e arriving at t:
response ≤ e / (wi/Wnormal · (1−β) · C) + Δlag where Δlag is the (interval-independent) lag
bound of EEVDF under piecewise-constant references — i.e., EEVDF's existing guarantee,
restated in time units against a (1−β)-capacity machine. Degradation in β is graceful and
exact: the normal class loses the reserved fraction and nothing more. Per-job form (the e
term rides along) is the honest heavy-tail posture, per Devi–Anderson's x + ek.
```
---
``` Previous summary
We hypothesize that a "laundering attack" can compromise the fairness guarantees of the EEVDF scheduler.
Specifically, we define this attack as the injection of incessant, adversarial urgent signals designed to artificially induce lag debt on benign tasks.
To validate this, we utilized `bpftrace` to hook `dequeue_task_fair()` and trace the `vlag` of scheduling entities.
Our empirical analysis yields three key observations:
First, the sum of `vlag`s over a given period does not converge to zero.
Second, there is a statistically significant difference in the average `vlag` between benign tasks and those under attack.
Finally, and most notably, we discovered anomalous `vlag`s that bypass the scheduler's clamping limits.
Even though EEVDF is theoretically designed to bound a task's lag to a calculated value (typically +-3.8M ns in our testbed), these outliers clearly violate that constraint.
```

## Topic: Laundering attack

## Goal of this work: Find answers to the questions
- Construct a theoretically valid foundation for our hypothesis and test.

## Final data


----

# Think (Mon)

## Questions to dive into
- What does the pair of enqueue/dequeue mean?
    -> I think I should know the flow of eevdf scheduling
    -> Why do you choose dequeue_task_fair to get a vlag?
    - How and When are metrics(vd, vruntime, ve, vlag) calculated?

# Status quo


## Hypotheses


----

# Input (Tue)

## What to know/study


----

# Output (Wed&Thr)

### The flow of EEVDF Scheduling
- Claude artifact: https://claude.ai/artifact/B7xecXMzjVwwMvdoXTqoBj
- Scheduling flow tracer: `sunwoojang@fedora:~/fluidos/laundering$ sudo bpftrace ./eevdf_trace.bt ls`

### Odds and ends
- To confirm base_slice: `sudo cat /sys/kernel/debug/sched/base_slice_ns`

### enqueue comes first rather than context_switch
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
- Diagrams and call graphs describing the flow of EEVDF
- A simple tool tracing scheduling behaviors of an execution with bpftrace

## Final prose 📄
To fully understand operations of EEVDF, we draw flow diagrams and call graphs of core functions.
The EEVDF scheduler executes by the order: wait/fork (creation sched entity), enqueue to a per-cpu runqueue, picking up to run, running&ticking, resched or dequeue.
As this is a core flow of EEVDF scheduling policy, CPU migration (context switching) and timer interrupt, of course, are occurs asyncrounously between the flows.
For example, based on the result of our simple tracer to executing `ls` command, the entrypoint of scheduling is the fork() from bash, where \_\_sched\_fork() and wake_up_new_task() are invoked.
While following the flow, CPU migration can be happened, which follows by dequeue, context switching (losing owning CPU), setting new CPU, enqueue, picking run, context switching (take the CPU), and ticking again.

### Revision
To understand how EEVDF operates, we constructed flow diagrams and call graphs.
A scheduling entity proceeds through the following stages: creation at fork (or wakeup from sleep), enqueue onto a per-CPU runqueue, selection for execution, execution with periodic tick accounting, and finally preemption or dequeue. CPU migration occurs asynchronously and may interleave with any of these stages. And vlag is computed against the source CPU's V at dequeue and restored against the destination's V in place_entity().
For example, tracing the execution of `ls` shows that scheduling begins with bash's fork(), which calls sched_fork() (and within it \_\_sched\_fork()) to initialize the child's scheduling entity, followed by wake_up_new_task() to place and enqueue it. Meanwhile, bash calls wait() and is dequeued as it sleeps. The child may migrate to another CPU during this flow: a queued task is dequeued from the source runqueue, reassigned to the destination CPU by set_task_cpu(), and enqueued there, where it is eventually selected and switched in.


## Questions to dive next
- Relationships and its own struct : task_struct - rq - sched_entity
- ⚡️Why is not sum of lag over a given peirod zero? (I think avg. lag should be zero)
- About fairness
    -> How to know if EEVDF's fairness is beaten?
    -> When to be broken of fairness in scheduling?
- Which external hardware interrupt should be use?
- workload: schbench + hardware interrupt. but with while infinite loop, lag increased.
    -> Is it truly lag debt or irq-related? If not, it might be just CPU load within eevdf? How do we distingquish between them?
- ⚡️What is khugepaged?? Its vlag was over the limit. ⭐️
- What is CBS?
- Where do I feel the fluid-state system of EEVDF in the code base or its relationships?
- Deep dive into oil theory (referring to insight.md)
- What makes the difference between **urgency** in FluidOS and **deadline** in EEVDF?
- ⭐️ About the flow diagram and call graphs, I still can't draw it own my own.
    - Which behavior is first? enqueue or context switching?

## Improvement of research (log)

