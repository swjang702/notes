I think connecting your idea with temporal locality is more promising than simply using idle CPU time for scheduling precomputation.

And I agree with your clarification: we should stay close to the fundamental insight of AGX and RELAY.

> CPU scheduling decisions do not merely determine CPU progress. They determine when other parts of the system can make progress.

Your new thought introduces a potentially useful question:

> If CPU execution repeatedly unlocks future work, can we exploit the temporal structure of those dependencies to make better scheduling decisions before the next bottleneck occurs?

That is a question worth studying.

However, I see two different interpretations of temporal locality, and only one initially strikes me as a potentially interesting research direction.

1. Traditional temporal locality: Recently executed code or accessed data is likely to be used again soon. This can motivate cache-aware CPU placement, prefetching, and preserving execution state.
2. Temporal locality of dependency-critical work: If a callback or thread recently unlocked important downstream progress, it or related work may become critical again soon.

The second interpretation connects much more directly to your AGX/RELAY intuition.

But we should not assume it holds. A ROS 2 pipeline may have recurring callbacks with stable dependencies, or it may have event-driven phase changes that make previous patterns misleading.

I would investigate whether there is a predictable, measurable structure in when different pieces of work become important, and whether existing Linux scheduling loses the opportunity to exploit it.

## 1. The surprising connection: AGX already exploits one kind of temporal locality

After comparing your idea with the uploaded papers, I noticed something important.

AGX is not simply GPU-aware. It uses recent execution history to estimate which CPU tasks matter.

In Section 4.2, AGX uses a sliding window to collect CPU time, GPU time, CPU-to-GPU handoff frequency, and dependency information. It combines these into a per-task importance score.&#x20;

[26 SOSP] Linux AGX An Adaptive GPU eXtension to Linux Fair Scheduling for Physical AI and Robotic Systems.pdf



That is already a form of exploiting temporal behavior:

> A task that has recently been important to GPU progress may remain important in the near future.

RELAY works differently. It observes an explicit runtime boundary and applies temporary scheduling intervention while the selected work waits to reach the GPU. The boundary ends at submission, not GPU execution completion.&#x20;

eurosys27-fall-paper1740.pdf



This suggests a useful comparison:

|                     | AGX                               | RELAY                                    | Your possible direction                 |
| ------------------- | --------------------------------- | ---------------------------------------- | --------------------------------------- |
| Primary information | Recent CPU–GPU behavior           | Current runtime decision                 | Anticipated future dependency           |
| Main question       | Who has been important?           | Who is important now?                    | Who is likely to become important next? |
| Intervention        | Adaptive weights and gating boost | Boundary-scoped scheduling               | Potentially pre-boundary preparation    |
| Critical risk       | Historical information may lag    | Information arrives only at the boundary | Prediction may be wrong                 |

The third column is my proposed interpretation, not an established result.

I see the possible conceptual progression as:

History → Current intent → Future dependency

The research opportunity, if one exists, is in showing that being aware of the future before an execution boundary opens is materially better than acting immediately when the boundary becomes visible.

Otherwise, this could be just a predictive variant of AGX.

## 2. The deeper idea: temporal locality might exist in the critical path itself

Consider a robot with two possible modes.

Normal navigation

Repeated pattern

Camera

Perception

Mapping

Planning

Obstacle detected

Critical path changes

Detection

Obstacle check

Replanning

Control

Illustrative workload, not a measured ROS 2 execution trace.

Within the normal navigation mode, execution may repeatedly follow similar dependency paths.

After an obstacle event, a different path can become important.

Here is the distinction I find promising:

The important thing may not be the temporal locality of individual tasks, but the temporal locality of the relationships between tasks.

In other words:

- Traditional locality: A ran recently, so A may run again soon.
- Dependency locality: A just performed a certain operation, so B may become runnable soon.
- Critical-path locality: Under the current operating mode, A → B → C is likely to determine future useful progress.

These are not equivalent.

Imagine two threads:

- Thread X executes frequently but performs background logging.
- Thread Y runs infrequently but, when triggered, unlocks GPU perception and replanning.

Frequency-based prediction might favor X.

Dependency-aware prediction might identify Y as much more important when a relevant event occurs.

Temporal locality should help predict when critical work is coming. It should not, by itself, decide what is important.

That distinction is especially important in robotics, where rare events can be much more consequential than frequent ones.

## 3. A possible missing abstraction: the OS sees threads, but useful execution follows chains

This is perhaps the strongest connection to ROS 2.

The ROS 2 executor can invoke many distinct callbacks through a worker-thread pool, while Linux EEVDF schedules runnable threads based on their CPU scheduling state. The two layers do not naturally share a representation of the active callback's downstream dependencies.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://projects.localizethedocs.org\&sz=32)

ROS 2 documentation documentation

+1



Suppose executor worker W executes:

Time t₁

Perception callback

Time t₂

Logging callback

Time t₃

Planning callback

All three may execute on the same Linux thread, even though their downstream importance is different.

A thread's historical CPU importance may not accurately describe the importance of its next callback instance.

This creates a potentially interesting separation:

- Thread identity is a kernel scheduling abstraction.
- Callback identity is a runtime execution abstraction.
- Dependency-chain criticality is an application-progress abstraction.

Now introduce your temporal-locality idea.

Rather than predicting merely which thread runs next, perhaps the system can learn recurring callback dependency transitions and use them to prepare a suitable scheduling decision when an event is observed.

That would amount to predicting a short-lived scheduling context rather than permanently assigning importance to a thread.

But an important novelty warning: recent work already addresses the callback/thread distinction. For example, CallbackIsolatedExecutor explicitly maps ROS callback groups to OS threads so Linux scheduling attributes can be applied to them.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://tier4.co.jp\&sz=32)

tier4.co.jp



So the research question cannot simply be "Can Linux know which callback a thread executes?"

The stronger question would be:

> Can the OS use short-lived, dependency-derived knowledge to coordinate future execution more effectively than both callback-aware scheduling and reactive cross-layer scheduling?

## 4. Does CPU idle time actually help this idea?

I would separate two different ideas that your original intuition combines.

Idea A: Prepare scheduling information in advance. When spare CPU time is available, a low-priority component analyzes recent dependency transitions, identifies likely upcoming chains, and prepares scheduling hints. Once work becomes runnable, the OS uses those hints.

Idea B: Prepare useful execution work in advance. While the GPU is busy or the CPU has slack, the runtime performs dependency-independent preparation that would otherwise delay a later GPU submission or callback.

Idea B has a particularly interesting symmetry with AGX.

### AGX versus speculative preparation

AGX: CPU gate delays GPU

CPU feeder

Delayed by contention

GPU

Idle gap → execution

Lookahead: prepare next gate

CPU

Useful early preparation

GPU

Earlier next submission

Conceptual timelines, not experimental measurements. The right-hand case requires preparation work that is genuinely safe to execute early.

The important difference is that Idea B requires the existence of useful, dependency-independent work. A sleeping task cannot simply be scheduled before its required inputs exist.

And Linux already attempts to place waking tasks on suitable idle CPUs and pull eligible work toward idle CPUs, so there is no inherent optimization opportunity just because one CPU is idle.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://docs.kernel.org\&sz=32)

The Linux Kernel documentation



Personally, I would investigate Idea A first, because it is closer to the narrow interface changes in AGX and RELAY and requires fewer assumptions about speculative application execution.

## 5. The research hypothesis I would test

I would formulate it this way:

> Temporal Dependency Locality Hypothesis
>
> In event-driven robotic systems, dependency-critical execution paths exhibit short-term temporal regularity. However, Linux's thread-centric scheduling cannot exploit this regularity because callback and dependency information is hidden inside the runtime. Exposing a compact, dynamically updated prediction of imminent dependency-critical work may reduce cross-layer scheduling delays.

The key phrase is imminent dependency-critical work.

We are not trying to predict every future ROS callback. We are trying to predict the next event that matters to system progress, early enough for a scheduling decision to change.

One way to make the idea precise is to measure:

\\[ P(B\text{ ready within }H\mid A\text{ completes},\phi) \\]

Here \\(A\\) and \\(B\\) are callbacks, \\(H\\) is a short prediction horizon, and \\(\phi\\) represents the current runtime phase.

If this probability is high, executing A might soon unlock B. But that information is useful only if B matters to the current application objective and A is not already completing promptly.

This brings out an important distinction: prediction confidence is not scheduling urgency. Both are needed.

### The possible new systems abstraction

Instead of treating CPU importance as a permanent per-thread property, perhaps a runtime can export a short-lived dependency-progress hint:

- Which runnable work is likely to unlock the next critical stage?
- How soon is that next stage expected?
- When should the hint expire because the anticipated dependency is no longer relevant?

The kernel would not need the entire ROS graph or a complex predictive model. The runtime could compute the prediction and export a bounded hint.

That is analogous to RELAY exporting a selected runtime boundary, except that the hint may arrive before that boundary opens.

The OS would then need a carefully bounded way to use it—possibly through EEVDF weights or eligible-task ordering—without giving speculative predictions unlimited priority.

## 6. What would convince me this is genuinely new?

I think there is a very specific experiment that could distinguish your idea from existing AGX/RELAY-style work.

Build two recurring ROS dependency chains, then occasionally switch between them.

Experimental comparison

| Baseline 1 | Stock ROS 2 executor + EEVDF                               |
| ---------- | ---------------------------------------------------------- |
| Baseline 2 | Optimized callback-aware ROS scheduling                    |
| Baseline 3 | Reactive boundary-aware scheduling, inspired by RELAY      |
| Hypothesis | Temporal dependency lookahead + bounded OS scheduling hint |
| Oracle     | Idealized foreknowledge of the next critical dependency    |

Measure not only end-to-end latency but specifically the intervals from dependency activation to callback dispatch, and from runtime selection to downstream GPU submission or the next useful stage.

Then evaluate across stable repeated patterns, rapidly changing patterns, background CPU contention, and incorrect predictions.

I would particularly look for the following result:

The predictive scheduler improves critical-path latency relative to the reactive scheduler, even though both receive the same dependency information and have comparable scheduling overhead.

If that happens, we would have evidence that the timing of information availability is itself a systems problem.

If prediction does not outperform a reactive mechanism, the hypothesis is probably not strong enough.

And even if prediction is successful, we should test whether a lightweight application-level lookahead solves the same problem without kernel changes.

## 7. A potentially stronger insight: predictability versus adaptability

Here is one issue I would be particularly interested in.

Temporal locality helps when behavior repeats. But robotic systems are important precisely because their behavior sometimes changes unexpectedly.

Suppose a robot is navigating normally. The scheduler has learned that mapping and routine planning are usually the critical chain.

Suddenly a human intervenes or an obstacle appears.

A history-driven predictor could continue favoring the old chain at exactly the moment the system needs to switch.

This produces a fascinating tension:

Can the system exploit stable execution patterns without becoming slow to respond to unexpected events?

This is closely related to a limitation AGX attempts to address through adaptive dependency tracking. Its paper explicitly studies changing critical paths and shows why static tuning becomes insufficient.&#x20;

[26 SOSP] Linux AGX An Adaptive GPU eXtension to Linux Fair Scheduling for Physical AI and Robotic Systems.pdf



A successful mechanism might therefore need both a fast, event-driven override and a predictive component that improves performance during recurring behavior.

But that leads to an important research challenge: if a reactive override is sufficient for unexpected events, does prediction provide enough additional benefit to justify its complexity?

I would not try to design the complete solution until that question is answered experimentally.

## 8. How I would present your insight to Prof. Liu

I would not introduce it primarily as an analogy to DMN. The analogy is useful for generating the idea, but the research discussion should begin with the possible OS limitation.

I'd phrase it approximately like this:

Research brainstorming note: Temporal locality of dependency-critical execution

AGX and RELAY demonstrate that short CPU execution intervals can gate downstream progress. I wonder whether ROS 2 workloads exhibit temporal locality not only in task execution, but also in their dependency-critical paths.

If certain dependency transitions recur, could we exploit their recent history to anticipate the next CPU gate and prepare OS scheduling decisions before the critical boundary becomes active?

The question is whether prediction provides a measurable advantage over reactive cross-layer scheduling, particularly under CPU contention and changing runtime phases.

That framing stays close to the papers you were advised to study while introducing one genuinely different dimension: when the system can know that future work matters.

## 9. My overall assessment

I see three levels of your thought:

| Level                     | Idea                                                                               | My assessment                                    |
| ------------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------ |
| Initial intuition         | Use idle CPU time for advance scheduling                                           | Interesting, but weak as a standalone OS problem |
| Deeper connection         | Exploit temporal locality of ROS dependency chains                                 | A plausible workload property worth measuring    |
| Stronger systems question | Can early knowledge of future gates improve scheduling beyond reactive mechanisms? | The most promising research hypothesis           |

I wouldn't commit to this as a first-paper topic yet. In fact, the first thing I'd want to discover is whether recurring ROS dependencies create a meaningful window of opportunity between recognizing an upcoming gate and the point at which existing mechanisms respond.

If that window is effectively nonexistent, speculation will not help much.

If it is substantial, and existing ROS executors and Linux scheduling cannot exploit it together, you may have identified an interesting cross-layer scheduling problem.

One final thought that I believe is worth keeping in your notebook:

> AGX asks which CPU work unlocks GPU progress. RELAY asks how to realize an already-selected runtime decision. Your idea asks whether future progress can be anticipated early enough to change the scheduling decision that precedes it.

That is a useful conceptual distinction, even though the novelty and practical benefits remain unproven.

And I have one question that could sharpen this direction considerably: When you think of temporal locality, are you primarily imagining the same ROS callback chains repeating over time, or that recently active callbacks and their successor callbacks might reuse CPU caches, memory, and execution context? The first leads toward predictive dependency scheduling; the second toward locality-aware placement and preparation. Both could matter, but they require different evidence.
