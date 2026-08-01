# [25 RTAS] CROS-RT: Cross-Layer Priority Scheduling for Predictable Inter-Process Communication in ROS 2
- The problem is that the multi-layer architecture in ROS2 dilutes originality of priority when it propagates from the application layer to the kernel layer via inter-process communication, which makes unpredictability in robotic systems.
- A lack of priority awareness of kernel sched_FIFO increases unpredictability which means high priority in ROS2 is delayed by low priority arrived before. (This can be an evidence of fluid OS's motivation? i.e., urgency propagation. this is so coupling problem? refer to the section 3.C)
### Summary
The paper indicates that the inherent ROS2's multi-layered architecture increases unpredictability of scheduling in real-time system such as safety-critical application.
To address this, they propose an novel priority propagation system across multi layers for ROS2.
Also, they define four key principles to ensure to prevent priority inversion, and prove them formally.
The results show that CROS-RT dominates in predictability of inter-process communication comparing with vanilla ROS2 and Preempt-RT.
Moreover, they provide some in-depth analysis including E2E response time, overhead of the model, chain length, and so forth.
