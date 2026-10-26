# Related Work

## This line of work (Literature)
```
                                   [26RTAS]ROSBand                    
[21RTAS]PiCAS                      Regulating memory bandwidth        
Predictable end-to-end latency     to guarantee timing performance    
using scheduling within ROS 2               ▲                         
                 ▲                          │                         
                 │                          │                         
              ───┴─────────────────┬────────┴────────────────────────►
                                   │                                  
                                   ▼                                  
                             [25RTAS]CROS-RT                          
                             Cross-layer scheduling                   
                             Bridging between                         
                             OS and ROS 2                             
```
```
                ▲ ┌───┐ ▲                 
                │ │App│ │                 
        CROS-RT │ └───┘ │ PiCAS           
(Priority-chain)│ ┌───┐ │ (Priority-chain)
                │ │ROS│ │                 
                │ └───┘ ▼                 
                │ ┌───┐                   
                │ │OS │ ▲                 
                ▼ └───┘ │ ROSBand         
                  ┌───┐ │ (Mem-regulation)
                  │HW │ ▼                 
                  └───┘                   
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

#### Quote
- "Furthermore with [59], the authors demonstrate that the issue of priority inversion and unpredictable delays arise from the lack of consistent priority propagation across the ROS2 stack architecture all the way down to the kernel layer. To deal with this, they propose CROS-RT, a cross-layer priority scheduling framework that enforces consistent priority-driven scheduling, mitigating priority inversion and ensuring predictable end-to-end latency for high-priority tasks." by [25 EMSOFT] Special Session

#### What they say
- "Preempt-RT is a widely-used Linux kernel patch that implements real-time computing capabilities. It assigns a static SCHED_FIFO priority (typically 50) to the ksoftirqd thread.
However, as noted in Sec.IV-C, this static assignment cannot fully eliminate priority inversion, leading to unpredictable delays in processing high-priority tasks."

#### Comment
- They don't touch the OS scheduler. Just use SCHED_FIFO.


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
- How they implemented:

#### Comment
- `gate` looks like a syscall interface.
- They saw GPU idle(utilization) problem as a scheduling problem. That's a thing.
- Might the Cross-RT work apply to a part of userspace profiling in this line of work?


### [21 RTAS] PiCAS: New Design of Priority-Driven Chain-Aware Scheduling for ROS2
Due to lack of real-time support in ROS, predictable end-to-end latency is hard to be achieved.
They propose a new ROS scheduling mechnism that reduces end-to-end latency with priority-based chain recognition across ROS 2 layer (Application and Middleware).

- Novelty: 
- Limitations: 
- What they took: 
- what they sacrificed:
- How they implemented:

#### Quote
- "PiCAS proposed callback priority assignments and executor mappings to align criticalities of chains with their respective callbacks and executors." by [25 RTAS] CROS-RT
- "PiCAS, however does not account for callback-executor mapping across different machines, particularly in remote inter-process communication, which affects P2." by [25 RTAS] CROS-RT
- "Choi et al. [27] introduced a priority-driven, chain-aware scheduler for ROS2, directly linking ROS2 callback prioritization to the timing requirements of task chains." by [25 EMSOFT] Special Session
- "Choi et al. [28] propose a priority-driven scheduler that prioritizes callbacks based on the given timing requirements of the corresponding chains, and they achieve predictable bounds on the end-to-end latency of critical chains."

#### What they say
- `From a real-time perspective, the scheduling of executors by an OS has a large impact on the timing behavior of callbacks.`
- `Challenge 2. Priority assignment for executors. By default, executors are scheduled by the Completely Fair Scheduler (CFS) [30] of the Linux kernel. Under this scheduler, it is hard to predictably prioritize the executors that are running call- backs from critical chains. Fortunately, the system developers can manually assign OS-level priority to executors although ROS2 does not provide an ofﬁcial interface to conﬁgure it.
Note that the priority assignment for executors becomes more challenging if callbacks from chains with different criticalities are mixed in a single node because such callbacks cannot be separately allocated to different executors.`


### RWTH Aachen Group
(optimizing multi-threaded ROS 2 executors and calculating end-to-end timing guarantees.)

- Novelty: 
- Limitations: 
- What they took: 
- what they sacrificed:
- How they implemented:

### DLR ScOSA Project
(actively researching how to integrate GPUs into distributed spacecraft to handle AI workloads.)

- Novelty: 
- Limitations: 
- What they took: 
- what they sacrificed:
- How they implemented:


### [25 EMSOFT] Special Session - Predictable Timing Behavior in Distributed Cyber-Physical Systems

#### Comment
I think this paper would help to build up background knowledge.


### [26 RTAS] ROSBand: A Bandwidth Regulation Approach on ROS2-Based Systems

- Novelty: portable memory bandwidth regulation for ROS 2 system
- Limitations:
- What they took: High portability
- What they sacrificed: timing precision
- How they implemented: Touching ROS 2 layer

#### Comment
This work proves that bandwidth regulation is necessary in ROS 2. However, because ROSBand is implemented purely in user space, its activation delay is up to 200μs, and it relies on 1-5ms regulation intervals.
This is acceptable for a self-driving car's 100ms camera pipeline, but it can be fatally slow for a spacecraft.

#### What they say
- "In particular, it is possible to override the ROS2 internal scheduler by explicitly creating threads at OS level during initialization, and associating them with specific executors. This, in combination with pthread support for assigning thread priority at the OS level, is the basis of ROSBand."
  -> What!?!? is it possible for ROS 2 executor to associate with OS thread priority?
    -> Yes, true. but it works after ROS 2 receives packets.
- "enforcing a controlled and exclusive mapping from callbacks to executors and to OS threads"


## ROS

### [26 ACM Comput.] ROS 2 in a Nutshell: A Survey
- ROS 1 has several limitations: (a) centralized architecture, (b) lack of built-in-multi-robot support, and (c) lack of real-time guarantee


## Etc.

### [27] RELAY: Bridging Transformer Runtime Boundaries and Linux Fair Scheduling

#### 1. Summary
They argue movement of transformer inference from isolated to full shared host execution leads to non-negligible performance overhead.
To solve this problem, they find a gap between transformer layer scheduling and OS scheduling, Linux fair scheduler.
The key insight is that selected boundary by transformer layers only can be done after CPU feeder is scheduled by Linux scheduler.
This work introduces a light-weight extension of Linux EEVDF identifying critical data such as selected boundary and CPU feeder.

#### 2. Strengths

#### 3. Weaknesses

#### 4. Other Comments


### [96 RTSS] A Proportional Share Resource Allocation Algorithm for Real-Time, Time-shared Systems



