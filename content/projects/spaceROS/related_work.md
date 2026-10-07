# Related Work

## Existing Work Flow
```
```

- Limitation of existing works
    - They primarily focused on ROS 2 layer in user space, not considering kernel layer.
    - They looked at a single machine rather than a distributed system.

## Scheduling in Robotics

### [25 RTAS] CROS-RT: Cross-Layer Priority Scheduling for Predictable Inter-Process Communication in ROS 2
The paper argues that the inherent ROS 2's **multi-layered** architecture increases **unpredictability** of scheduling in real-time system such as safety-critical application.
To address this, they propose an novel priority propagation system across multi layers for ROS 2.
Also, they define four key principles to ensure to prevent priority inversion, and prove them theoretically.
The results demonstrate that CROS-RT dominates in predictability of inter-process communication comparing with vanilla ROS 2 and Preempt-RT.
Moreover, they provide some in-depth analysis including E2E response time, overhead of the model, chain length, and so forth.

- Novelty: The first attempt to bridge the gap between ROS 2 and OS so that it reduced unpredictability across layers by ensuring correct priority propagation down to the kernel. And also they aimed at not a single machine but a distributed communication.
- Limitations: static global mapping table (when an executor created); uni-directional info flow in priority-mapping (is it matter?)
  - [Q] Is it really matter case in space robotic systems?
- What they took: deterministic
- What they sacrificed: flexibility? (static mapping table, is mapping trustful?, etc.)
- How they implemented: modifying network interrupt handling mechanism with network driver, kernel module, a custom syscall.

#### They say
- "Preempt-RT is a widely-used Linux kernel patch that implements real-time computing capabilities. It assigns a static SCHED_FIFO priority (typically 50) to the ksoftirqd thread.
However, as noted in Sec.IV-C, this static assignment cannot fully eliminate priority inversion, leading to unpredictable delays in processing high-priority tasks."


### [26 SOSP] Linux AGX: An Adaptive GPU eXtension to Linux Fair Scheduling for Physical AI and Robotic Systems
The key insight is that short CPU preparation time **gates** GPU launch in Linux.
As Linux default fair scheduler cannot aware of GPU tasks or a critical-path, the CPU time slice often is put off, which makes GPU idle.
This especially is vital in ML-driven robotic pipelines.
Therefore, they present AGX (Adaptive GPU eXtension) Linux simple extension which reweight scheduler to be GPU-, dependent-, adapt-aware leveraging userspace profiling.
It reduces meaningfully GPU idle time and completion time of a task in a robotic system.

- Novelty: 
- Limitations: 
- What they took: 
- what they sacrificed:

#### Comment
- `gate` looks like a syscall interface.
- They saw GPU idle(utilization) problem as a scheduling problem. That's a thing.
- Might the Cross-RT work apply to a part of userspace profiling in this line of work?


### [21 RTAS] PiCAS: New Design of Priority-Driven Chain-Aware Scheduling for ROS2
(redesigned the ROS 2 Executor to respect strict, end-to-end chain priorities.)

- Novelty: 
- Limitations: 
- What they took: 
- what they sacrificed:

#### Quote
- "PiCAS proposed callback priority assignments and executor mappings to align criticalities of chains with their respective callbacks and executors." by [25 RTAS] CROS-RT
- "PiCAS, however does not account for callback-executor mapping across different machines, particularly in remote inter-process communication, which affects P2." by [25 RTAS] CROS-RT


### RWTH Aachen Group
(optimizing multi-threaded ROS 2 executors and calculating end-to-end timing guarantees.)

- Novelty: 
- Limitations: 
- What they took: 
- what they sacrificed:

### DLR ScOSA Project
(actively researching how to integrate GPUs into distributed spacecraft to handle AI workloads.)

- Novelty: 
- Limitations: 
- What they took: 
- what they sacrificed:

