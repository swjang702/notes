# ROS 2 and Linux Scheduling

*A research outline on coordinating callback dispatch with CPU scheduling for robotic workloads.*

**Research question.** When a short ROS 2 callback unlocks GPU computation or another dependent stage, can the ROS executor and Linux scheduler coordinate to make that progress happen sooner—without permanently prioritizing the executor thread?

## 1. Motivation

Robotic applications increasingly combine CPU callbacks, GPU inference, and dependent processing stages. A short CPU callback may be essential not because it consumes much CPU time, but because **its completion unlocks the next stage of work**. Linux AGX and RELAY show how delays in CPU feeder execution can postpone GPU progress.

ROS 2 adds another scheduling decision *before* the CPU feeder runs: the **executor chooses which ready callback a Linux thread will execute**. Linux schedules that thread but does not know which callback is waiting inside the executor. Consequently, giving an executor thread more CPU time may not accelerate the callback that matters.

The question is not simply whether ROS 2 has high end-to-end latency. It is whether **two separately reasonable scheduling decisions can delay the same dependency-critical work**—and whether that delay requires a coordinated solution.

### The scheduling boundary

```text
ROS 2               Callback ready
                            |
                            v
                    [ Executor selection ]  <-- callback-level waiting
                            |
                            v
                    Callback assigned to worker
                            |
                            v
Linux               [ Worker CPU scheduling ] <-- runnable wait / preemption
                            |
                            v
                    CPU callback prepares launch
                            |
                            v
GPU                 GPU submission --> downstream execution
```

*The two types of waiting are conceptual sources of delay, not necessarily consecutive or independent time intervals. A worker can run other callbacks or be preempted along the way.*

| Layer | What it schedules | What it cannot directly control |
|---|---|---|
| ROS 2 executor | Ready callbacks and their assignment to workers | CPU service for a worker competing with unrelated Linux threads |
| Linux scheduler | Runnable OS threads | Selection of a callback still waiting inside an executor |

**Illustrative failure.** A long housekeeping callback occupies a non-preemptive executor worker. A short GPU-feeding callback becomes ready, but cannot start until housekeeping finishes. Boosting that already-running worker cannot make it interrupt the housekeeping callback. Conversely, even if the executor promptly selects the feeder, Linux may delay the worker under CPU contention.

This example motivates the investigation; its frequency and importance in realistic ROS 2 workloads still need to be measured. Other executor designs may avoid it.

## 2. Problem and Research Hypotheses

We will test three related claims, rather than assume that every ROS 2 workload suffers from this problem.

### H1. The executor can hide dependency-critical work from the kernel

A GPU-feeding callback may be ready but not yet selected. The kernel sees an executor thread, not the identity or importance of the waiting callback. **Question:** Under which executor configurations and workloads does this delay materially postpone downstream execution?

### H2. Fixing either layer alone can leave the other delay intact

Callback-aware executor scheduling may still suffer Linux runqueue delays. GPU-aware Linux scheduling may still spend CPU service on a worker running an unrelated callback. **Question:** Does a meaningful residual delay remain after applying strong single-layer optimizations?

### H3. Permanent thread priority is a poor substitute for timely coordination

A worker may execute both critical feeder callbacks and ordinary housekeeping. Persistently favoring the worker can give CPU time to the wrong callback and interfere with other processes. **Question:** Can a short-lived preference improve downstream progress at a smaller fairness and background-service cost?

The central novelty test is whether a new coordination mechanism can outperform **the best practical combination of existing executor-level and kernel-level policies**, not merely stock ROS 2 and Linux.

## 3. Possible Approach

The guiding abstraction is a **progress gate**: a callback instance whose short CPU execution enables a downstream computation, together with the OS worker that can realize it.

Rather than transferring an entire ROS dependency graph into the kernel, the runtime could expose only the information required while a gate matters:

- **Identity:** Which callback instance and worker thread are involved?
- **Role:** What downstream progress does this callback unlock?
- **Lifetime:** When does the gate become relevant, change workers, complete submission, or expire?

The ROS side would retain callback selection and dependency semantics. The Linux side would retain CPU scheduling and fairness accounting. The interface would coordinate **when an actual worker should receive temporary scheduling preference**.

### Division of responsibility

**ROS 2 / executor**
- Recognize relevant callbacks and their resource/dependency role.
- Select a ready feeder when that ordering is justified.
- Expose the selected callback-to-worker binding and its lifecycle.

**Linux / scheduler**
- Identify the corresponding runnable worker and its CPU contention.
- Apply a bounded, temporary scheduling preference when the worker can advance an active gate.
- Remove the preference at submission, cancellation, handoff, or expiry; preserve bounded effects on competing tasks.

A kernel hint **cannot preempt an in-progress, non-preemptive ROS callback**. This is a structural limitation, not something a more aggressive EEVDF weight can repair. A useful design must address selection at the executor and CPU service at the kernel, or show that existing middleware policies already solve the first part.

| Design lens | Current direction |
|---|---|
| **Abstraction** | Short-lived callback-to-worker progress gate |
| **Mechanism** | Minimal runtime-to-kernel lifecycle hint; bounded fair-class intervention |
| **Policy** | Favor a worker only while it can advance currently critical downstream work |
| **Trade-off** | Faster progress versus fairness, background interference, tracking overhead, and stale hints |

This design is intentionally provisional. Before changing the kernel, we must establish which information or control point existing mechanisms cannot already provide. Simply attaching a ROS observer to RELAY is not, by itself, a new contribution.

## 4. Evidence and Evaluation Plan

The first goal is to **explain where delay comes from**, not to demonstrate a speedup from a proposed scheduler.

### 4.1 Characterize the two scheduling layers

Record, for each relevant callback instance:

- **Callback becomes ready:** `t_ready` — when the callback is eligible for executor selection.
- **Callback begins:** `t_start` — when its user-level code starts executing.
- **GPU work is submitted:** `t_submit` — when the associated GPU launch is accepted.
- **Linux execution intervals:** wakeups, runnable-but-off-CPU waiting, context switches, and actual CPU service.

For a matched feeder callback:

```text
ready-to-launch delay = t_submit - t_ready
                      = (t_start - t_ready) + (t_submit - t_start)
```

This identity does **not** mean that the first component is purely executor waiting or the second purely CPU execution. Linux waiting and executor activity must be reconstructed separately from trace intervals, without double-counting.

Use ROS 2 tracing together with Linux scheduler tracing (`sched_wakeup`, `sched_switch`) and GPU submission events. Match callback identities to **host TIDs** and align trace clocks. LTTng `vpid`/`vtid` identifiers are PID-namespace-relative; they should not be treated as universal host IDs.

### 4.2 Compare meaningful alternatives

| System | Purpose |
|---|---|
| Stock ROS 2 + deployed Linux policy | Establish actual behavior |
| Callback-aware executor only | Isolate executor scheduling improvements |
| Kernel scheduling improvement only | Isolate CPU dispatch improvements |
| Best existing executor + kernel combination | Test whether new coordination is necessary |
| Proposed coordinated design | Measure incremental value, if justified |
| Idealized immediate selection/dispatch | Bound the opportunity for improvement |

Include competitive executor mechanisms and appropriately configured Linux policies. Check the exact kernel implementation: a vendor Linux 5.15 scheduler must not automatically be described as mainline EEVDF.

### 4.3 Planned figures

| Figure | Main question | Intended evidence |
|---|---|---|
| **Fig. 1 — Motivation** | Where is the feeder delayed? | One synchronized ROS–Linux–GPU timeline separating callback wait, worker CPU wait, and submission |
| **Fig. 2 — Root cause** | What can each layer fix? | Executor-only versus kernel-only trace decomposition under controlled contention |
| **Fig. 3 — Coordination benefit** | Does cooperation beat strong alternatives? | Critical gate delay versus background-service cost across all baselines |
| **Fig. 4 — Design** | What information crosses the boundary? | Executor–kernel interface, lifecycle, and fallback behavior |
| **Fig. 5 — Generality and cost** | When does the approach help or fail? | Executor variants, worker counts, CPU/GPU balance, mode changes, overhead, and fairness |

**Primary outcomes:** ready-to-submission latency (including p95/p99), critical-chain completion time, GPU idle gaps attributable to CPU-side gating, and downstream data freshness where meaningful.

**Costs and controls:** background CPU service, deadline misses where deadlines are defined, scheduler overhead, stale/cancelled hints, CPU-only pipelines, idle hosts, and GPU-saturated cases. Use fixed workload inputs, software revisions, CPU/GPU clocks, and power settings.

For a real-time analysis, additional assumptions would be required about callback releases, non-preemptive blocking, execution bounds, and device service. Changing EEVDF weights alone does not establish a worst-case end-to-end guarantee.

## 5. Positioning Against Prior Work

| Work | Established contribution | Question left for this project |
|---|---|---|
| **Linux AGX** | GPU-/dependency-aware fair-scheduler weights and feeder boosts | How much GPU-gating work remains hidden before ROS callback selection? |
| **RELAY** | Carries runtime-selected Transformer work through host scheduling to GPU submission | What changes when the runtime has not yet selected the relevant callback or its worker changes? |
| **PiCAS and related executor work** | Priority- and chain-aware ROS callback scheduling | What Linux-side bottleneck remains after a strong executor policy? |
| **Teper et al., RTAS 2025** | ROS executor semantics designed for stronger scheduling analysis | How does executor behavior interact with shared-host CPU contention and downstream GPU gating? |
| **CROS-RT, RTAS 2025** | Cross-layer ROS/Linux scheduling and priority propagation | Is there a distinct callback-to-GPU progress failure that existing coordination does not address? |

The existence of ROS–Linux coordination is **not** itself novel. A paper needs a specific failure, a necessary new control point, and measured improvement over existing cross-layer techniques.

## 6. Immediate Next Steps

1. **Establish the measurement pipeline.** Confirm kernel scheduler and ROS executor versions; correlate callback readiness, callback start, worker TID, Linux runqueue events, and GPU submission.
2. **Produce Fig. 1 with a small controlled workload.** Vary housekeeping callback length, worker count, and CPU contention; then repeat with a realistic pipeline.
3. **Test existing solutions before designing a kernel patch.** Compare an executor-aware policy, Linux tuning, and their combination. If these remove the bottleneck, revise the research question.
4. **Identify the smallest missing interface.** Determine whether the kernel needs to know about callback readiness, callback-to-worker assignment, or only the selected-to-submitted interval.
5. **Design and evaluate only what the traces justify.** Quantify the performance–fairness trade-off and document cases where coordination provides no benefit.

**Decisive question for the next discussion:** What can a coordinated ROS–Linux mechanism accomplish that an optimized ROS executor plus AGX/RELAY-style kernel scheduling cannot?

---

### Selected references

- *Linux AGX: An Adaptive GPU eXtension to Linux Fair Scheduling for Physical AI and Robotic Systems* — Sections 3–5.
- *RELAY: Bridging Transformer Runtime Boundaries and Linux Fair Scheduling* — Sections 3–5.
- *PiCAS: New Design of Priority-Driven Chain-Aware Scheduling for ROS 2* (RTAS 2021).
- *Reconciling ROS 2 with Classical Real-Time Scheduling of Periodic Tasks* (RTAS 2025).
- *CROS-RT* (RTAS 2025).
