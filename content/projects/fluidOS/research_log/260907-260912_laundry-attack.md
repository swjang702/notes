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

## Topic: Laundering attack

## Goal of this work: Finding an evidence/case of the laundry attack

## Final data
- A table that shows a difference of the number of calling hooks between the benign and a psuedo-laundering for 9 hooks(sched3/mem3/irq3) ??

| | Benign EEVDF | Psuedo laundering |
| :--- | :---: | :---: |
| Avgerage of Lag | 16.6903 | 432658 |
| Sched hook1 | |  |
| Sched hook2 | |  |
| Sched hook3 | |  |
| Mem hook1 | |  |
| Mem hook2 | |  |
| Mem hook3 | |  |
| IRQ hook1 | |  |
| IRQ hook2 | |  |
| IRQ hook3 | |  |

* tested on no-delay-dequeue feature

Q) why is not sum of lag zero?

- A lag debt of the pseudo laundering attack ?
    -> A graph with the X-axis is time and the Y-axis is lag for several metrics such as benign, laundering, browsing, etc.

| Time | avg. of vlag |
| --- | --- |
| 10 | 432658 |
| 20 | 597988 |
| 30 | 358854 |
| 60 | 514521 |

-->> No lag debt observed.


# Think (Mon)

# Status quo
- We have no urgent tier systems and promotion/demotion where a laundering attack should be done.
  So, we have to use deductive reasoning to prove it. Like leveraging subsumption.

## What to want to get
- Abnormal scheduling (laundry attack) R negative mem operations

## Questions
- Can an adversarial urgency signal beat the Bound 2's fairness?
    - adversarial urgency signals ~= external abnormal interrupts, EEVDF's fairness subsumes FluidOS's fairness. Because of the design, FluidOS atop EEVDF.
    -> How to know if EEVDF's fairness is beaten?
    -> When to be broken of fairness in scheduling?

## Hypotheses
- There is a peudo laundering attack that have an negative impact on EEVDF's fairness.
- If a case that adversarial urgency signal interferes normal tasks' fairness in EEVDF exists, the design of FluidOS will be exploited by laundering attack.

## What to do

## What to test


# Input (Tue)
~~- Read UNC slides about scheduling and laundering attack.~~
- Assimilate my falsification.md
- Understanding the laundering attack in quote
- Define what the laundering attack is.
- Define hooks to trace

## What to know(study)
- What guarantees EEVDF's fairness?
    - If we know this, we can attack it.
~~- How to measure lag of EEVDF~~
~~- Which hooks I should trace~~
- Relationship between sched and mem and irq

### Measuring the lag
- we should be check the lag only when the lag is modified, iff, the return value of update_entity_lag is true.

#### Where the lag is calculated

/kernel/sched/fair.c 818,875
update_entity_lag wraps entity_lag.
```C
/*
 * lag_i = S - s_i = w_i * (V - v_i)
 *
 * However, since V is approximated by the weighted average of all entities it
 * is possible -- by addition/removal/reweight to the tree -- to move V around
 * and end up with a larger lag than we started with.
 *
 * Limit this to either double the slice length with a minimum of TICK_NSEC
 * since that is the timing granularity.
 *
 * EEVDF gives the following limit for a steady state system:
 *
 *   -r_max < lag < max(r_max, q)
 */
static s64 entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 avruntime)
{
	u64 max_slice = cfs_rq_max_slice(cfs_rq) + TICK_NSEC;
	s64 vlag, limit;

	vlag = avruntime - se->vruntime;
	limit = calc_delta_fair(max_slice, se);

	return clamp(vlag, -limit, limit);
}

/*
 * Delayed dequeue aims to reduce the negative lag of a dequeued task. While
 * updating the lag of an entity, check that negative lag didn't increase
 * during the delayed dequeue period which would be unfair.
 * Similarly, check that the entity didn't gain positive lag when DELAY_ZERO
 * is set.
 *
 * Return true if the vlag has been modified. Specifically:
 *
 *   se->vlag != avg_vruntime() - se->vruntime
 *
 * This can be due to clamping in entity_lag() or clamping due to
 * sched_delayed. Either way, when vlag is modified and the entity is
 * retained, the tree needs to be adjusted.
 */
static __always_inline
bool update_entity_lag(struct cfs_rq *cfs_rq, struct sched_entity *se)
{
	u64 avruntime = avg_vruntime(cfs_rq);
	s64 vlag = entity_lag(cfs_rq, se, avruntime);

	WARN_ON_ONCE(!se->on_rq);

	if (se->sched_delayed) {
		/* previous vlag < 0 otherwise se would not be delayed */
		vlag = max(vlag, se->vlag);
		if (sched_feat(DELAY_ZERO))
			vlag = min(vlag, 0);
	}
	se->vlag = vlag;

	return avruntime - vlag != se->vruntime;
}
```

#### Where the update_entity_lag is called
`dequeue_entity (normal path and delayed path both) / requeue_delayed_entity`


### Hooks to trace

#### Sched
- update_entity_lag(), update_curr(), resched_curr()

#### Mem
- should_numa_migrate_memory()
    -> Not being called
- task_numa_work()
    -> Not being called
- update_numa_stats()
    -> Not being called

```by claude
The two "memory operations", concretely

1. Moving memory to the task — should_numa_migrate_memory() (fair.c:2676) is the scheduler-side policy function; the actual page copy happens in mm/migrate.c (migrate_misplaced_folio()). This is the scheduler informing an mm-subsystem decision.
2. Making memory access observable — task_numa_work() (fair.c:4076) is where scheduler code itself calls into mm (change_prot_numa(), fair.c:4266) to unmap/reprotect PTEs, which is genuinely the scheduler mutating page tables to sample access patterns cheaply (via faults) instead of watching every access.

Secondary, lighter integration points

- account_numa_enqueue() / account_numa_dequeue() (fair.c:2343, 2349) — maintain rq->nr_numa_running / rq->nr_preferred_running, which the load balancer consults for NUMA-aware imbalance decisions (separate from vruntime/lag balancing).
- Everything is gated behind static_branch_likely(&sched_numa_balancing) and CONFIG_NUMA_BALANCING; with it off, all these functions are no-ops (see the stub task_tick_numa() at fair.c:4449).

If you want, I can also show how task_numa_migrate() ties back into the load-balancer's active-balance/stop_one_cpu() machinery — that's the actual mechanism that pulls a task onto a different runqueue once NUMA balancing decides to move it.
```

#### IRQ
- update_irq_load_avg()
    -> DONE
- update_hw_load_avg()
    -> non-meaningul
- sched_balance_trigger()


## References
- https://www.cs.unc.edu/~porter/courses/cse506/f12/syllabus.html


# Output (Wed&Thr)
- Trace
- Write a psuedo laundering attack
- sched-related tools:
    ```
    tool	controls
    ---
    taskset	which CPUs
    chrt	scheduling policy and priority
    nice	weight within SCHED_NORMAL
    numactl	CPU and memory node placement
    cset / cgroup cpuset	affinity for a whole group of tasks
    ```

## How to implement
~~- kernel modification directly / kernel module / ftrace(maybe kprobe?) / eBPF~~
    -> Using debugfs `/sys/kernel/debug/sched/debug`, which contains lots of info about eevdf.
       Please refer to `/Documentation/scheduler/sched-debug.rst`.
       another related files are `/proc/<pid>/sched` and `/proc/schedstat`.
       -> But sched debugfs doesn't display lag !! 
          I'm gonna use bpftrace and fexit:dequeue_task_fair first at cheaper.
          `bpftrace -e 'fexit:vmlinux:dequeue_task_fair {printf("%s\n", comm);}'`
    -> Another cheaper try is using debuginfo and perf like below:
       ```
       sudo dnf debuginfo-install kernel
       sudo perf probe --add update_entity_lag
       sudo perf record -e probe:update_entity_lag -a sleep 5
       ```

- Which external hardware interrupt should be use?

## Config of Sched
`/sys/kernel/debug/sched/features`

## Tracing
### bpftrace
`bpftrace -e 'fexit:vmlinux:dequeue_task_fair {printf("%s\n", comm);}'`
`bpftrace -e 'fexit:vmlinux:dequeue_task_fair { @[comm] = count(); }'`
```
bpftrace -e '
fexit:dequeue_task_fair {
    printf("%-16s %-7d vlag=%-12lld vruntime=%llu slice=%llu\n",
           args.p->comm, args.p->pid, args.p->se.vlag,
           args.p->se.vruntime, args.p->se.slice);
}'
```
-> Why do you choose dequeue_task_fair to get a vlag?

- Watching the round trip
The interesting thing isn't the snapshot, it's whether it survives. place_entity() restores it on wakeup, so pair the dequeue with the next enqueue:
```bash
sudo bpftrace -e '
fexit:dequeue_task_fair / args.flags & 1 / {
    @saved[args.p->pid] = args.p->se.vlag;
}
fexit:enqueue_task_fair / @saved[args.p->pid] != 0 / {
    printf("%-16s slept vlag=%lld  woke vlag=%lld  vruntime=%llu\n",
           args.p->comm, @saved[args.p->pid],
           args.p->se.vlag, args.p->se.vruntime);
    delete(@saved[args.p->pid]);
}'
```
-> What does this mean???
-> I think I should know the flow of eevdf scheduling

- FYI
`bpftrace -e 'tracepoint:sched:sched_switch { @[kstack] = count(); }'`
-> stack counting is available! but now I don't know how it worth.

### dequeue_task_fair
```C
/*
 * The dequeue_task method is called before nr_running is
 * decreased. We remove the task from the rbtree and
 * update the fair scheduling stats:
 */
static bool dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
{
	if (task_is_throttled(p)) {
		dequeue_throttled_task(p, flags);
		return true;
	}

	if (!p->se.sched_delayed)
		util_est_dequeue(&rq->cfs, p);

	if (dequeue_entities(rq, &p->se, flags) < 0)
		return false;

	/*
	 * Must not reference @p after dequeue_entities(DEQUEUE_DELAYED).
	 */
	return true;
}
```

### Pseudo laundering attack
- workload: schbench + hardware interrupt. but with while infinite loop, lag increased.
    -> Is it truly lag debt or irq-related? If not, it might be just CPU load within eevdf? How do we distingquish between them?



# Analyze (Fri)
- Figure out a benign behavior and find differences between benign and the attack.

## Normal
- normally lag clampped 3.8M ns (min/max), which seems mean entity_lag()'s limit.

## Anomaly
root@fedora:/home/sunwoojang/fluidos/laundering# cat laundry_vlag_no-delay-dequeue.6.log | grep khugepaged
khugepaged,19090098
khugepaged,18999972
khugepaged,-136347523
-->> What is that!?!? ⭐️


# Sum up (Sat)
- Significant difference of vlag between benign and laundry.
- No lag debt observed on laundry regarding as time goes.
- There is config of sched that we can consider.
- Mem/IRQ operations associated with scheduling are not observed.
- Using bpftrace, schbench, dd for test.

## Final prose 📄
We set a hypothesis that a laundering attack can beat EEVDF's fairness.
In here, the laundering attack means incessant adversarial urgent signals. In other words, adversarial urgent signals may make lag debt of normal tasks.
To prove this, we hook `dequeue_task_fair()` to get the vlag of sched_entity with bpftrace.
We found out three.
First of all, sum of vlags for a period time is not zero.
Second, there is significant a difference of avg. vlag between benign and laundering attack.
Last, more interestingly, we discover anomaly vlags that are over the limit as though EEVDF scheduler force task's lag clampped to a calculated value. In our experience, it is +-3.8M ns.

### Proofreading
🛠️ 주요 교정 포인트 (Vocabulary & Phrasing)
- "beat EEVDF's fairness" ➔ "compromise / exploit / circumvent"
'beat'는 약간 구어체입니다. 시스템 보안이나 스케줄러 논문에서는 보장성(guarantee)을 '무너뜨리거나(compromise)', '우회(circumvent)'한다고 표현하는 것이 더 묵직합니다.

- "make lag debt" ➔ "induce / artificially accumulate"
빚을 '만든다(make)'기보다는 비정상적으로 '유발(induce)'하거나 '누적(accumulate)'시킨다는 표현이 정확합니다.

- "We found out three." ➔ "Our empirical analysis yields three key observations."
매우 중요한 전환점입니다. "세 가지를 찾았다"보다 "경험적 분석(실험) 결과 세 가지 주요 관찰 결과를 얻었다"로 포장하면 훨씬 프로페셔널해 보입니다.

- "as though EEVDF scheduler force..." ➔ "even though the EEVDF scheduler is designed to bound..."
EEVDF가 원래 lag 값을 특정 범위로 제한(clamp/bound)하도록 설계되었음에도 불구하고 그 한계를 뚫었다는 뉘앙스를 살리는 것이 좋습니다.

### Revision
We hypothesize that a "laundering attack" can compromise the fairness guarantees of the EEVDF scheduler.
Specifically, we define this attack as the injection of incessant, adversarial urgent signals designed to artificially induce lag debt on benign tasks.
To validate this, we utilized `bpftrace` to hook `dequeue_task_fair()` and trace the `vlag` of scheduling entities.
Our empirical analysis yields three key observations:
First, the sum of `vlag`s over a given period does not converge to zero.
Second, there is a statistically significant difference in the average `vlag` between benign tasks and those under attack.
Finally, and most notably, we discovered anomalous `vlag`s that bypass the scheduler's clamping limits.
Even though EEVDF is theoretically designed to bound a task's lag to a calculated value (typically +-3.8M ns in our testbed), these outliers clearly violate that constraint.


## Questions to dive next
- Relationships and its own struct : task_struct - rq - sched_entity
- Why is not sum of lag zero? (I think avg. lag should be zero)
- About fairness
    -> How to know if EEVDF's fairness is beaten?
    -> When to be broken of fairness in scheduling?
- Which external hardware interrupt should be use?
- workload: schbench + hardware interrupt. but with while infinite loop, lag increased.
    -> Is it truly lag debt or irq-related? If not, it might be just CPU load within eevdf? How do we distingquish between them?
- What is khugepaged?? Its vlag was over the limit. ⭐️
- Why do you choose dequeue_task_fair to get a vlag?
- What does the pair of enqueue/dequeue mean?
    -> I think I should know the flow of eevdf scheduling

## Improvement of research (log)
- Add a final prose for sum-up
- Add a log for data/parameter mapping like `laundry_vlag.4.log = start_laundry.sh -w schbench -t 20 + bpftrace script A`

