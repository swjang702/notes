# Related Work
## Scheduling in Robotics
### [25 RTAS] CROS-RT: Cross-Layer Priority Scheduling for Predictable Inter-Process Communication in ROS 2
The paper indicates that the inherent ROS 2's multi-layered architecture increases unpredictability of scheduling in real-time system such as safety-critical application.
To address this, they propose an novel priority propagation system across multi layers for ROS 2.
Also, they define four key principles to ensure to prevent priority inversion, and prove them theoretically.
The results demonstrate that CROS-RT dominates in predictability of inter-process communication comparing with vanilla ROS 2 and Preempt-RT.
Moreover, they provide some in-depth analysis including E2E response time, overhead of the model, chain length, and so forth.

### [26 SOSP] Linux AGX: An Adaptive GPU eXtension to Linux Fair Scheduling for Physical AI and Robotic Systems
The key insight is that short CPU preparation time gates GPU launch in Linux.
As Linux default fair scheduler cannot aware of GPU tasks or a critical-path, the CPU time slice often is put off, which makes GPU idle.
This especially is vital in ML-driven robotic pipelines.
Therefore, they present AGX (Adaptive GPU eXtension) Linux simple extension which reweight scheduler to be GPU-, dependent-, adapt-aware leveraging userspace profiling.
It reduces meaningfully GPU idle time and completion time of a task in a robotic system.
