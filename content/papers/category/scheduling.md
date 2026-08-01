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


# [26 SOSP] Scheduling Linux Threads under I/O Chiplet Wall Using cSwitch
!! [NEED TO READ]
