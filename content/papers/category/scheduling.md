# [25 RTAS] CROS-RT: Cross-Layer Priority Scheduling for Predictable Inter-Process Communication in ROS 2
- The problem is that the multi-layer architecture in ROS 2 dilutes originality of priority when it propagates from the application layer to the kernel layer via inter-process communication, which makes unpredictability in robotic systems.
- A lack of priority awareness of kernel sched_FIFO increases unpredictability which means high priority in ROS 2 is delayed by low priority arrived before. (This can be an evidence of fluid OS's motivation? i.e., urgency propagation. this is so coupling problem? refer to the section 3.C)
### Summary
The paper indicates that the inherent ROS 2's multi-layered architecture increases unpredictability of scheduling in real-time system such as safety-critical application.
To address this, they propose an novel priority propagation system across multi layers for ROS 2.
Also, they define four key principles to ensure to prevent priority inversion, and prove them theoretically.
The results demonstrate that CROS-RT dominates in predictability of inter-process communication comparing with vanilla ROS 2 and Preempt-RT.
Moreover, they provide some in-depth analysis including E2E response time, overhead of the model, chain length, and so forth.

### Citation from Cong Liu
Well, a naive observation following Soheil's work: when the ROS 2 executor dispatches callbacks, it is agnostic to their **resource role**.
A callback whose short CPU segment gates a GPU launch is ordered by the same period- or registration-based rules as ordinary CPU-only callbacks, so a non-preemptive housekeeping callback can run ahead of a millisecond-scale GPU-feeding callback while the GPU sits idle. If the executor does not dispatch such feeder callbacks in time, no kernel-level mechanism, whether EEVDF or AGX, can help: the kernel's scheduling entity is the executor thread, and the callback ordering inside that thread is invisible to it. AGX can bring the executor thread onto the CPU promptly, but if the executor then spends that time on a housekeeping callback first, the kernel-level boost is simply wasted one layer down. Making the ROS 2 executor's dispatch policy aware of this distinction is therefore not just an optimization but the only layer where this gap can be closed, which leaves clear room for improvement.


# [26 SOSP] Linux AGX: An Adaptive GPU eXtension to Linux Fair Scheduling for Physical AI and Robotic Systems
### Summary
The key insight is that short CPU preparation time gates GPU launch in Linux.
As Linux default fair scheduler cannot aware of GPU tasks or a critical-path, the CPU time slice often is put off, which makes GPU idle.
This especially is vital in ML-driven robotic pipelines.
Therefore, they present AGX (Adaptive GPU eXtension) Linux simple extension which reweight scheduler to be GPU-, dependent-, adapt-aware leveraging userspace profiling.
It reduces meaningfully GPU idle time and completion time of a task in a robotic system.

### Deep Dive into Data
- What does it mean exactly?
- Why is it important?
- Why do they present the data?
#### My curiosity (questions)
- How much does AGX reduce makespan?
- How much does AGX increase GPU utilization?
    - Figure 6. Overall performance of schedulers. (The first data in the evaluation section)
        - Metrics: three
        - workload targeting: seven
        - the number of comparison (Five Baselines): six
        - the number of computing platforms: three
        - My comment: I think good points are two. One is many variables to test and the second one is applying to the other research result, DREAM (ASPLOS'23), which is about application-level scheduler. And most of data are plausible.
- How much is overhead of AGX?
    - Figure 8. Overhead analysis and component breakdown.
- What does dependency graph consist of?
- How does short CPU preparation time gate GPU launch?
- How much does the CPU preparation time interfere GPU utilization?
    - Figure 9. DAG critical-path sensitivity
- How many does AGX support vendors?
    - Just shown as testbed, three platforms.
- What does weighting scheme look like?


# [26 SOSP] Scheduling Linux Threads under I/O Chiplet Wall Using cSwitch
!! [NEED TO UPDATE]


# [23 ASPLOS] Dream: A dynamic scheduler for dynamic real-time multi-model ml workloads
!! [NEED TO UPDATE]

