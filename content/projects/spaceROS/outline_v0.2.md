# ROS 2 and Linux Scheduling

*Coordinating callback dispatch and CPU service for dependency-rich robotic workloads*

**Research question.** When a short ROS 2 callback unlocks GPU computation or another downstream stage, is there a scheduling failure that neither the executor nor Linux can adequately address on its own—or through a straightforward combination of existing techniques?

## 1. Introduction

In modern robotic pipelines, a short CPU segment can determine when a much larger downstream computation begins. Perception and planning may depend on timely GPU launches, yet the CPU work that initiates those launches competes with ordinary callbacks and background threads. **Linux AGX** and **RELAY** demonstrate that scheduling a CPU feeder promptly can matter more to application progress than its CPU demand alone would suggest. Their broader lesson is that *CPU scheduling controls when other resources can make progress*.

ROS 2 adds another scheduling boundary. An executor selects callbacks and maps their execution onto Linux threads; Linux schedules those threads without directly selecting the callbacks waiting inside the executor. A critical callback may therefore wait **before selection**, even when its worker receives CPU service. Conversely, a callback selected promptly may be delayed **after selection** by Linux contention. These are distinct control points, and neither layer automatically has the information or authority of the other.

**The objective of this work is to determine whether that separation produces an important, generalizable scheduling failure—and, only if it does, identify the minimum coordination required to address it.** A convincing result must explain why a well-tuned executor combined with existing Linux scheduling mechanisms is insufficient. Lower end-to-end latency alone would not establish a new OS contribution.

## 2. Problem Characterization

### 2.1 Where is dependency-critical work delayed?

```text
  Upstream event / data available
                 |
                 v
       Callback becomes ready
                 |
                 |  A. Executor-side waiting or blocking
                 v
       Callback selected / bound to a worker
                 |
                 |  B. Worker runnable delay or preemption
                 v
       CPU feeder executes and submits work
                 |
                 v
       GPU / downstream stage progresses
```

The two delays are **causal categories**, not necessarily disjoint wall-clock intervals. For example, while a feeder waits inside the executor, the worker might be running housekeeping code or might itself be descheduled. Trace-based attribution must distinguish these states rather than assign the entire wait to one layer.

**Figure 1 — A critical callback is ready, but downstream work does not advance.** A synchronized ROS–Linux–GPU timeline showing callback readiness, executor selection, worker on/off-CPU intervals, GPU submission, and GPU activity. Include two cases: (a) a feeder waiting behind a long non-preemptive callback; (b) a selected feeder whose worker loses CPU service. The first case shows a *limit of kernel-only intervention*, not yet the need for a new kernel mechanism.

- **Evidence needed:** Matching callback/worker identities and timestamps; actual GPU idle or delayed downstream work; prevalence beyond a deliberately adversarial one-worker test.
- **Alternative explanation to rule out:** GPU queue saturation, callback data unavailability, deliberate middleware ordering, or an executor that already avoids the delay.

### 2.2 Is a new coordination mechanism necessary?

The central comparison is not merely executor-only versus kernel-only scheduling. **Their best practical combination is the crucial baseline.** If independently improved layers already eliminate the avoidable delay, a new cross-layer interface is not justified.

| Comparison | Question it answers |
|---|---|
| Stock executor + deployed Linux scheduler | What happens today? |
| Callback-/chain-aware executor only | How much delay originates in callback selection? |
| Kernel-only scheduling improvement | How much delay originates in CPU service? |
| **Best existing executor + kernel combination** | **What problem remains without a new interface?** |
| Idealized selection/CPU-service oracle | How much avoidable delay is theoretically left? |

**Figure 2 — Existing fixes remove different delays; what remains after combining them?** Compare those configurations with matched workload and CPU/GPU contention. Decompose readiness-to-submission time by *what the worker was doing* and *whether the feeder was selected*. Show the residual gap relative to the oracle, if any.

- **Hypothesis H1:** Ready-but-unselected callbacks can materially delay downstream progress in realistic execution configurations.
- **Hypothesis H2:** A measurable delay remains after combining strong executor and Linux scheduling baselines, especially when callback importance or worker assignment changes dynamically.
- **Decision point:** If the combined baseline is near the oracle, or the issue disappears with an existing executor, **revise the research problem rather than invent a kernel mechanism**.

### 2.3 What is the actual missing capability?

A thread is Linux's scheduling entity, but its *current callback* determines whether CPU service unlocks useful downstream work. The same worker may execute a GPU feeder at one moment and housekeeping at another. A permanent boost may therefore favor the **right thread at the wrong time**.

The unresolved question is more specific than “ROS and Linux cannot communicate”:

> **Which callback-level fact must change a Linux scheduling decision—or which Linux-level fact must change callback dispatch—for the combined system to outperform existing independent policies?**

The answer might involve callback readiness, selection, worker binding, handoff, or the precise lifetime of the feeder segment. It is not yet known which information is necessary, whether existing interfaces can express it, or whether the remaining problem is large enough to matter.

## 3. Key Insight and Possible System Design

*This section describes a design direction, not an established contribution. Its contents should be revised after Figures 1–2.*

### 3.1 Candidate abstraction: a short-lived progress gate

A **progress gate** is a callback instance whose execution enables an important downstream stage, together with the worker that can execute it. Unlike a permanent per-thread priority, the gate has a limited lifetime and can move as callbacks are assigned to workers.

Potential information to expose across the boundary:

- **Readiness and role:** A dependency-critical callback is available; what progress can it unlock?
- **Binding:** Which runnable worker can actually execute it, and when is that association valid?
- **Completion or cancellation:** When should any special treatment stop or be withdrawn?

The kernel does **not** need the whole ROS graph unless measurements show that a smaller interface fails. The executor should continue deciding callback order; Linux should continue accounting for and scheduling runnable threads.

### 3.2 Candidate mechanism: coordinate only actionable decisions

If the evidence supports a missing capability, investigate a minimal contract between the executor and Linux:

1. The runtime identifies dependency-relevant work and selects or binds it to an executable worker.
2. Linux uses that *current* association to provide **bounded, short-lived** CPU scheduling preference when it can accelerate the gate.
3. The preference ends on submission, completion of the relevant CPU phase, handoff, cancellation, or timeout.

A useful design must explicitly handle changing callback-to-worker mappings, multiple workers, overlapping gates, stale notifications, and competing background tasks. It must also say **what it enables beyond simply combining a callback-aware executor with AGX/RELAY-like scheduling**. If there is no such capability, keep the simpler solution.

**Figure 3 — The smallest useful coordination boundary.** Show callback readiness/selection and worker binding on the ROS side, runnable-worker scheduling on the Linux side, and the downstream submission event. Highlight only information that Figure 2 establishes as missing. Include lifecycle expiration and the normal-scheduler fallback.

| Design lens | Question to settle |
|---|---|
| **Abstraction** | What is the minimum callback-to-worker progress information? |
| **Mechanism** | Is a new kernel interface or EEVDF modification actually required? |
| **Policy** | When is preferential CPU service worth its cost? |
| **Trade-off** | How much downstream progress is gained per unit of background interference and tracking overhead? |

**Structural limit:** A kernel boost cannot interrupt a non-preemptive callback *within* a worker. Correct callback selection, more workers, or callback preemption must address that case at the appropriate layer. Nor does changing fair-class weights establish hard real-time guarantees.

## 4. Evaluation and Discussion

*Figures in this section are planned evidence, not reported results. Each result should be written only after the corresponding experiment.*

### 4.1 Does coordination outperform the strongest existing combination?

**Figure 4 — Downstream progress versus cost.** Compare the proposed design, if justified, against stock ROS/Linux, strong executor-only and kernel-only policies, and **their best existing combination**. Plot readiness-to-submission latency (including tail latency) or critical-chain completion time **against** background CPU service or throughput. A speedup that requires disproportionately starving competing work is not sufficient.

- **Supports the claim if:** Coordination improves the performance–interference frontier beyond the strongest existing combination.
- **Weakens the claim if:** The combined baseline provides the same result at similar cost, or the benefit comes only from increasing the total priority budget.

### 4.2 When does the failure occur, and when does it disappear?

**Figure 5 — Sensitivity and generality.** Vary executor design, worker count, callback lengths, callback-to-worker changes, CPU contention, GPU saturation, and dependency-chain shape. Include a realistic perception/planning pipeline after the controlled motivating experiment.

- **Supports generality if:** The same *mechanism-level* failure appears across several credible configurations, not merely one non-preemptive worker.
- **Defines the boundary if:** An optimized executor, abundant CPU capacity, or a GPU already saturated with queued work eliminates the benefit.

### 4.3 What does the mechanism cost, and why does it help?

**Figure 6 — Mechanism ablation and overhead.** Disable individual information signals and kernel decisions; quantify event-processing cost, scheduling overhead, stale/incorrect hints, background fairness, and power where measurable. Explain *which* part of the proposed mechanism causes any improvement.

- **Supports the design if:** The cross-layer information or policy removes a specific delay observed in Figure 2 at acceptable cost.
- **Challenges the design if:** The same effect comes from static thread settings or a simpler existing OS interface.

### 4.4 Measurement foundations and first experiments

For each callback instance, instrument **ready → selected/bound → callback start → downstream submission**, together with Linux wakeup, scheduling, and CPU-execution intervals. Standard `callback_start` is **not** a callback-ready timestamp. Join ROS tracing with scheduler traces using validated clocks and host thread IDs; LTTng `vpid`/`vtid` are PID-namespace-relative. Verify the *deployed* Linux scheduler rather than assuming a vendor 5.15 kernel implements mainline EEVDF.

First measurements, in order:

1. **Produce Figure 1:** A feeder-versus-housekeeping microbenchmark, then confirm the phenomenon in a realistic ROS pipeline.
2. **Produce Figure 2:** Tune existing executor and Linux policies separately and jointly, and identify any unexplained residual delay.
3. **Only if necessary, build Figure 3's mechanism:** Implement the minimum missing interface; collect Figures 4–6 to justify its complexity.

Keep experiment configurations, raw traces, analysis scripts, and regenerated figures reproducible. Do not claim bounded worst-case end-to-end latency without a corresponding execution, blocking, and device-service model.

## 5. Relation to Prior Work

| Work | Established idea | Distinction this project must establish |
|---|---|---|
| **Linux AGX** | Dependency-/GPU-aware weighting and feeder support in Linux fair scheduling | A feeder may remain hidden as an unselected ROS callback; show why existing weight changes are insufficient. |
| **RELAY** | Boundary-scoped CPU scheduling for Transformer runtime-selected GPU work | Demonstrate a failure or required control point *before or across* ROS callback selection, not just a ROS port of RELAY. |
| **PiCAS and related ROS executors** | Callback-/chain-aware dispatch | Identify residual host-scheduling limitations **after** applying credible executor policies. |
| **Teper et al. (RTAS 2025)** | ROS 2 executor changes to support scheduling analysis | Account for their executor semantics and compare against their strongest relevant configuration. |
| **CROS-RT (RTAS 2025)** | Coordination between ROS-level and OS-level execution | Establish a distinct GPU-/dependency-progress problem beyond generic ROS–Linux priority propagation. |

**Novelty threshold:** The fact that callback and thread schedulers operate at different layers is already known. The contribution must be a **specific, measured failure**, a **necessary new capability**, and a **baseline-resistant improvement**.

## 6. Conclusions

The intended conclusion is not that ROS 2 and Linux should always be coordinated. It is a more precise answer to three questions:

1. **Existence:** Under what workloads does callback selection or Linux CPU service prevent downstream progress?
2. **Necessity:** Which delays survive competitive executor scheduling, kernel scheduling, and their existing combination?
3. **Significance:** If coordination is necessary, what minimal abstraction improves useful progress without unacceptable fairness or implementation cost?

If evidence supports all three, the broader systems lesson may be that **CPU scheduling should account for short-lived application progress dependencies whose meaning changes as runtime work items are bound to OS threads**. If the combined baseline already solves the problem, that finding should redirect the project rather than be concealed.

---

*Reading foundation: Linux AGX; RELAY; PiCAS; Teper et al. (RTAS 2025); CROS-RT (RTAS 2025); George M. Whitesides, “Whitesides' Group: Writing a Paper.”*
