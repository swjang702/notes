Oh, this is an interesting connection. 특히 DMN(Default Mode Network)에서 생각들이 서로 연결되는 현상을 CPU idle time에 비유했다는 점이 흥미로워.

I wouldn't call it a research contribution yet, but I think there's a potentially useful systems idea hidden in your intuition.

Let me interpret what you're imagining:

> What if an OS could use idle CPU time to anticipate future work, instead of waiting until that work becomes runnable before deciding how to schedule it?

For ROS 2, that could mean preparing some information about future callbacks, their dependencies, or their preferred execution locations.

The key is that you're shifting the question from:

- Reactive scheduling: A task becomes runnable → the scheduler decides what to run.
- Proactive scheduling: The system anticipates upcoming work → prepares useful scheduling decisions → applies them when the work arrives.

I find the second idea worth exploring.

However, there's an important distinction: the CPU is idle because there is no runnable work on that CPU, not necessarily because the scheduler is failing to make decisions.

So the opportunity isn't simply "schedule tasks earlier." It's whether we can precompute information that helps future tasks execute more efficiently or promptly.

## 1. Imagine this scenario

Suppose we have a ROS 2 pipeline:

Camera

Detection

Planning

Your potential idea

During idle time

Anticipate

Analyze likely callback dependencies and prepare execution hints

When work arrives

Execute

Use the prepared information rather than rediscovering it

For instance, instead of waiting until the detection callback finishes to discover that planning is the next relevant stage, the runtime could already know the likely successor, associated thread, CPU placement, and resource requirements.

But there's a catch: the dependency graph might be known already. If so, what useful calculation remains to be performed during idle time?

That question is where I'd begin.

## 2. I see three possible interpretations

| Idea                             | What is prepared?                                                       | My assessment                                              |
| -------------------------------- | ----------------------------------------------------------------------- | ---------------------------------------------------------- |
| Scheduling precomputation        | CPU placement, priority, callback-to-worker mapping                     | Feasible, but novelty is uncertain                         |
| Dependency lookahead             | Predict which callback chain will become critical                       | More interesting, particularly for adaptive ROS workloads  |
| Speculative resource preparation | Warm data, prepare memory residency, anticipate future accelerator work | Potentially more impactful, but higher complexity and cost |

My favorite is a combination of the second and third.

Perhaps the real opportunity isn't to perform scheduling computations while idle, but to use idle resources to reduce the future cost of realizing an application dependency.

This is closer to the AGX/RELAY philosophy: identify the work that unlocks future progress.

For example, AGX identifies CPU work that unlocks GPU execution, while RELAY focuses on the interval between a runtime scheduling decision and actual GPU submission.&#x20;

[26 SOSP] Linux AGX An Adaptive GPU eXtension to Linux Fair Scheduling for Physical AI and Robotic Systems.pdf

eurosys27-fall-paper1740.pdf



Your idea could explore what happens before that decision or dependency becomes runnable.

## 3. But here is how I would challenge your insight

I would ask three difficult questions.

First: What is actually expensive about scheduling?

Linux scheduling decisions are often relatively cheap compared with milliseconds of waiting, execution, or GPU contention. If advance computation saves only a small scheduling calculation, the benefit might be negligible.

Second: Why would idle-time processing be better than existing techniques?

ROS 2 already has mechanisms for controlling callback execution, while research such as [ReDAG-RT](https://arxiv.org/abs/2603.18238) studies dependency-aware scheduling for multi-DAG execution.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://arxiv.org\&sz=32)

arxiv.org



Your work would need to show something that static mapping, callback priorities, or ordinary runtime lookahead cannot achieve.

Third: Is idle time really free?

No. On an embedded robot, CPU idle states save energy. Using idle cycles for speculation can increase power consumption, interfere with future work, or disturb caches.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://cdn.kernel.org\&sz=32)

The Linux Kernel documentation



An idle-time mechanism therefore needs to demonstrate that its future performance benefit outweighs these costs.

## 4. The experiment I'd try first

Before modifying EEVDF, build a toy ROS 2 executor with a small dependency graph.

Compare four implementations:

1. Baseline: Ordinary executor scheduling.
2. On-demand: Compute dependency information when callbacks become ready.
3. Lookahead: Precompute the same information during otherwise idle periods.
4. Oracle: Supply perfect knowledge of future callback arrivals as an upper bound.

Measure callback dispatch latency, p99 dependency-chain completion time, preparation overhead, prediction accuracy, and CPU energy or idle-state impact.

The oracle is particularly useful: if even perfect future knowledge provides little improvement, the direction probably isn't worthwhile.

And if idle-time lookahead substantially helps, ask why the existing runtime couldn't simply perform the same computation earlier without changing Linux.

## 5. My assessment as a potential systems research direction

Quality of the intuition

Worth investigating

Identified real-world failure

Not yet

Novelty versus prior work

Uncertain

Next action

Form a falsifiable hypothesis

I think the most useful way to preserve your idea in your research notebook is:

> Hypothesis: Idle-Time Dependency Lookahead
>
> In event-driven robotic pipelines, the OS and runtime may react to dependencies only when work becomes runnable. Could otherwise idle CPU cycles be used to anticipate upcoming dependency-critical work and prepare scheduling or resource decisions, reducing future response latency without introducing unacceptable overhead or energy consumption?

That's a hypothesis, not yet a confirmed problem.

And one more thought: your DMN analogy is useful as an idea-generation metaphor, not as evidence about how a scheduler should work. The intellectually valuable part is the shift from reacting to current work to preparing for future work.

One thing I'm particularly curious about: when you wrote "mapping," were you imagining mapping ROS callback dependencies to CPU cores/threads ahead of time, or something closer to constructing a ROS dependency graph itself? Those lead to different research questions.
