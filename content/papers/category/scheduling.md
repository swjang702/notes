# [25 RTAS] CROS-RT: Cross-Layer Priority Scheduling for Predictable Inter-Process Communication in ROS 2
- The problem is that the multi-layer architecture in ROS2 dilutes originality of priority when it propagates from the application layer to the kernel layer via inter-process communication, which makes unpredictability in robotic systems.
- A lack of priority awareness of kernel sched_FIFO increases unpredictability which means high priority in ROS2 is delayed by low priority arrived before. (This can be an evidence of fluid OS's motivation? i.e., urgency propagation)
