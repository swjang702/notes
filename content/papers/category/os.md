[26 SOSP] Linux AGX: An Adaptive GPU eXtension to Linux Fair Scheduling for Physical AI and Robotic Systems
### Summary
The key insight is that short CPU preparation time gates GPU launch in Linux.
As Linux default fair scheduler cannot aware of GPU tasks or a critical-path, the CPU time slice often is put off, which makes GPU idle.
This especially is vital in ML-driven robotic pipelines.
Therefore, they present AGX (Adaptive GPU eXtension) Linux simple extension which reweight scheduler to be GPU-, dependent-, adapt-aware leveraging userspace profiling.
It reduces meaningfully GPU idle time and completion time of a task in a robotic system.
