## What is the spaceROS and its features?
It is a *middleware layer* of an open-source flight framework derived from *ROS 2*.
It uses Data Distribution Service (DDS) to allow different nodes to communicate.

### Why do robotic systems need a middleware layer?
First, abstractions for the complexity from many devices like sensors.
Second, it enables distributed computing as if were a single unified computer.

```
          ▲  ┌───┐    ┌───┐        
          │  │App│    │App│        
          │  └───┘    └───┘        
          │  ┌───┐    ┌───────────┐
 "Timely" │  │ROS│    │Extra Layer│
(Vertical │  └───┘ ~= └───────────┘
Isolation)│  ┌───┐    ┌───┐        
          │  │OS │    │OS │        
          │  └───┘    └───┘        
          │  ┌───┐    ┌───┐        
          │  │HW │    │HW │        
          ▼  └───┘    └───┘        
            ◄─────────────────────►
              "Fault Tolerance"    
                 (Horizontal       
                  Isolation)       
```


## Candidate Directions
From the discussion summary and my investigation, I have selected brief two directions.
I thought these two cases could break up space systems.

### 1. "Timely" Problem
The goal is to `guarantee End-to-End worst case latency` via `cross-layer scheduling`.
ROS 2 has its own scheduler "Executor", and the OS, of course, has its own CPU scheduler.
ROS 2 knows the "meaning" of the data, while the OS knows the "shape" of the data.
If we can make them somehow talk to each other, we might take advantage of "time".
Also, as the CROS-RT work reduced unpredictability of communication across multi layers, we might not have to concern about priority inversion across layers.

#### Trade-off Chain
```
                          Abstraction                     
Bounded  ──► Too many ──► layer         ──► Semantic gaps 
deadline     devices      for simplicity    from isolation
                                                  │       
                                                  ▼       
Missing  ◄── Non-     ◄──     Hard to   ◄── Lack of       
deadline     deterministic    predict       shared context
                        (unpredictability▲)               
```

### 2. "Fault" Problem
The goal is to maintain seamless failover orchestration and state consistency during dynamic circumstances.
The key insight is that we can see a space robotic system as a tiny hard real-time cloud.
There are lots of sensor devices and multiple nodes for fault tolerance. And the SpaceROS provides how to communicate each other.
Kubernetes already provides several mechanisms (e.g., QoS, admission control, side car, etc.) to keep eventual consistency in a distributed system.
What we can do is to apply existing distributed concepts like K8s to space robotic systems to solve the "Fault" problem, as the vLLM paper leverages traditional OS concepts into LLM's KV cache memory.
A difference is time-scale; in K8s, it takes 3 secs to re-deploy a pod. Meanwhile, in spacecraft, it should take milliseconds.

```
┌───┐  ┌───┐ 
│App│  │App│ 
└───┘  └───┘ 
┌───────────┐
│Kubernetes │
└───────────┘
┌───┐  ┌───┐ 
│OS │  │OS │ 
└───┘  └───┘ 
┌───┐  ┌───┐ 
│HW │  │HW │ 
└───┘  └───┘ 
```

### 3. Merging them
By combining them, for example, the K8S-style eBPF acts as the "Bouncer"(data dropping) at the door, and the Cross-Layer Scheduler acts as the "VIP Escort"(data processing) inside the club.
Without the Bouncer, the VIP Escort has to wade through a massive crowd of garbage packets inside the kernel to find the VIP.
Without the VIP Escort, the VIP gets in the door but gets stuck waiting in a normal CPU queue.


## Key Assumptions
- Our target, such as the Starship, does not use RTOSes but Linux (specifically PREEMPT_RT).
- ROS and the OS are mutually blind; ROS is a king locked inside a castle shouting orders, while the OS blindly manages the gates. They suffer from a lack of shared context.
- We can assume dynamic states (e.g., mission-mode transition, defective HW, interrupt storm, etc.). CROS-RT did its work based on steady-state.
- Existing works have primarily focused on the ROS 2 layer, such as multi-threaded executor. This is one reason why CROS-RT work is worthy.

