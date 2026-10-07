# Motivation (Value of Research = Why is the work important + its justification)

## Key Assumption

```
"Timely"          -> Strong Connected
                            | (trade-off tension)
"Fault Tolerance" -> Strong Isolated
```
- steady state X -> dynamic and extreme state O ?? (e.g., mission transition or interrupt storm or network load, etc.)
- See spacecraft as a tiny hard-real-time cloud!? (Kubernetes analogy)
  - Reflect the brilliant orchestration concepts of Kubernetes (dynamic QoS, node failover, state reconciliation, container, pod, etc.) and pushing them down into the hard-real-time Linux kernel to support SpaceROS.
    -> This is like vllm leverage much of traditional OS concepts into LLM's KV cache memory, we leverage ditributed system's concepts to space robotic systems?

### Directions
- From the summary, the primary motivations of OS of Starship are three: timely, correct control in limited env, and mission phases change.
- I want to delegate "correct control" to static analysis at compile time.
- So, We can focus on "timely" or "transition of phases".
- And also, "Fault recovery"? which can occur at runtime in dynamic space circumstances. -> This is more like close to hardware part.. humm..

- Guarantee end-to-end bound ?! (For this, leveraging k8s QoS? at the OS level?)

### Space Robotics
- Assume that Space Robotic Systems, such as SpaceROS and Starship, now use the PREEMPT_RT patch Linux or the Real-Time Linux (ELISA Space Grade Linux).

## Intro
- Unlike normal computer systems, robotic systems consists of 4 layers. ROS is put between application and OS. So, there occur a kind of gap.
- Furthermore, ROS acts like a king in the robotic system while OS exists and even directly communicate with hardware devices. (A king locked inside a castle Making OS blind)
- These multi-layered architecture increases semantic gaps and unpredictibility of communication such as task's priority inversion.
    -> CROS-RT work

## Candidate Topics

### 1. Cross-layer scheduler (Two-Level Scheduling Problem) [Strong Connected]
- ROS 2 has its own scheduler called "Executor." At the same time, the host OS use PREEMPT_RT scheduler.
- For example, imagine your SpaceROS Executor is perfectly tuned. It knows that Callback A (Landing Thruster) is extremely high priority, and Callback B (Camera Telemetry) is low priority.
However, the network packet that triggers Callback A arrives at the hardware Network Interface Card (NIC).
  1. The OS kernel takes over. The kernel's packet processing thread (ksoftirqd) processes packets strictly in the order they arrived (FIFO).
  2. If 1,000 low-priority Camera Telemetry packets arrive right before the 1 Landing Thruster packet, the OS kernel will dutifully process all 1,000 camera packets first.
  3. The SpaceROS Executor is sitting there, totally starved, waiting for its high-priority message, but it can't do anything because the OS kernel is busy processing low-priority junk.
This is not about taks's priority inversion (CROS_RT). Even if priority order be preserved, This case can happen.

#### Contributions
- While CROS-RT solved "Steady-State Priority Inversion." We are solving "Transient Priority Inversion during Cyber-Physical Mode Transitions."
- Atomic(Agile) Mode-Swapping (If we can provide this, in the future physical AI can leverage this in a safe way??)

#### Strengths and Weaknesses
+ To be able to leverage CROS-RT

### 2. Space-Partitioned ROS (Fault Tolerance or Mission Phase transition) [Strong Isolated]

#### Strengths and Weaknesses
- Cannot touch CROS-RT and scheduling

### 3. End-to-End bounded worst-case latency with distributed concepts during severe state
- "While SpaceROS brings modern distributed publish/subscribe paradigms to aerospace, it currently relies on static OS schedulers that cannot handle dynamic distributed failures. We introduce a Cloud-Native Real-Time framework—pushing Kubernetes-style QoS eviction, Admission Control, and Sidecar routing directly into the PREEMPT_RT kernel to guarantee bounded worst-case latency during mission mode transitions and replica failovers."

### 3.5 Merging: Cross-layer scheduler + End-to-End bwcl with K8s

### 4. GPU ...

## Current limitations
- Lack of Observations


