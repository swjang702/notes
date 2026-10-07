# Question Tree

- [Q5] What do I leverage?
  - [A5] OS scheduler, CROSS_RT, Linux AGX, and FluidOS.

## Observations

## Why existing works/mechanisms couldn't solve?
- ~~[Q1] What is the history of this line of work?~~ [`Related work`]
  - [A1] Not much, some.
         * PiCAS (RTAS 2021): redesigned the ROS 2 Executor to respect strict, end-to-end chain priorities.
         * RWTH Aachen Group: optimizing multi-threaded ROS 2 executors and calculating end-to-end timing guarantees.
         -> These are only treat user space executors.
         * CROS-RT (RTAS 2025): the first major framework to explicitly bridge this gap for ROS 2. (limited in only network packet and assumed a steady-state)
         **Nobody has bridged the OS and SpaceROS for the extreme dynamics of spaceflight.**
         - Fault Recovery / Mission Mode Changes
  - [Q1.1] What are existing works and current status of this line of work?
    - [A1.1] Refer to `related_work.md`.
- [Q13] What is the limitation of CROS-RT work and future direction of it?
  - [A13] CROS-RT only cares network processing; assumes steady-state; static creation of mapping table?
  - ~~[Q13.1] What are key features of related works of CROS-RT? [A7.1.1]~~ ⚡️
    - [A13.1] priority-driven scheduler for the executor, dynamic-priority scheduler, dynamic scheduling adjustments, real-time scheduling under multi-threaded executors, GPU management within ROS 2, distributed ROS 2 systems

## Is your question or approach fundamental?

## Our Approach
- ~~[Q16] connect ros with os <-> counter intuitively, what about absolute isolation for them? or mutual exclusive.? was there similar case or problem in cs or reality.? (1. airport, ros is like kubernetes.? cloud cause they also multiple nodes(space robotics like small cloud.? but different tension), 3. microkernel)~~ ⚡️
  - [A16] 1. Kubernetes / Cloud Analogy (Spacecraft as a Tiny hard-real-time Cloud) (Distributed system?)
            a. Absolute Isolation like secure containers for "Fault tolerance"
            b. Kubernetes ControlPlane and Scheduler for "Cross-Layer Scheduler"
            c. Kubernetes Observability
          2. Microkernel: There is seL4 which proves mathematical security and a space and time partitioning rule, ARINC 653. ARINC 653 defines a two-level hierarchical schedule(?!).
          3. Bypassing OS like LibOS or Exokernel
    - ~~[QA16.1] SpaceROS or Starship also follows the ARINC 653? Because from the wikipedia, "The standard defines a two-level hierarchical schedule."~~
      - [AA16.1] SpaceROS Yes, Starship No.
  - ~~[Q16.1] How about comparing the space robotics architecture with the kubernetes architecture?~~ ⚡️⚡️
    - [A16.1] 1. The workloads: Microservices vs ROS 2 Nodes
              2. The Networking: Service Mesh vs DDS Middleware
              3. The Control Plane: K8S Scheduler vs System/Mission Manager
              4. Consensus & State: etcd vs Voting
              * The "Aha!" difference (Why K8S fails in space): Eventual Consistency. In k8s, if a node dies, it might take 5 sec to re-create. But in space, it must take under 10 milliseconds.
              * In k8s, when a node gets evicted or resources get tight, k8s uses **QoS(Quality of Service) Classes**: Guaranteed, Burstable, and BestEffort. If memory out, k8s kills the BestEffort pods to save the Guaranteed pods.
              **SpaceROS does not have a dynamic QoS eviction system at the OS level.
              Taking the brilliant orchestration concepts of Kubernetes (dynamic QoS, node failover, state reconciliation) and pushing them down into the hard-real-time Linux kernel to support SpaceROS.
              It's the exact same architectural battle, just fought at the microsecond level instead of the minute level!**
      - [Q16.A1.1] This is like vllm paper leverages much of traditional OS concepts into LLM's KV cache memory optimization, we leverage distributed system's concepts to space robotic systems.? And just think about achieving microsecond level instead of the minute level, as we can just take other architectural concepts from kubernetes for the space robotic systems.
        - [A16.A1.1] The *vLLM* paper didn't invent paging; they realized that LLM researchers were struggling with memory fragmentation, and said, *"Hey, the OS community solved this in the 1970. Let's just apply it here."*
        We are doing the exact same thing: **The robotics community is struggling with distributed fault recovery and mode transitions. The Cloud/Kubernetes community solved this a decade ago. We are taking the Cloud's orchestration concepts and pushing them down into the real-time Linux kernel to hit microsecond deadlines.**
        Specific K8S concepts:
        1. The Sidecar Proxy
          * How K8s does it: Every pod gets a "Sidecar" proxy. Before a microservice receives a network request, the sidecar inspects it, checks if the sender is authorized, and drops it if it's stale or bad.
          * Our spaceROS microsec version: eBPF "kernel sidecar"
        2. Admission Control
          * How K8s does it: When you try to deploy a new Pod, the K8s Admission Controller checks if the cluster has enough CPU and RAM.
          * Our version: Real-Time Network Admission Control
        3. Liveness Probes & Leader Election
          * How K8s does it: The control plane pings a container every 10 secs. If it misses 3 pings, K8s kills it and elects a new leader.
          * Our version: Hardware-Timestamped Epochs (Addressing Challenge #6 from your PDF)
          In distributed spacecraft, waiting seconds to detect a failure is fatal. Instead of slow pings, our OS kernel embeds a "Control Epoch" ID into every single network packet's metadata.
          If Node A (the leader) fails, Node B instantly promotes itself and increments the Epoch ID to Epoch 2. If a delayed packet from Node A suddenly arrives claiming to be the leader, our kernel sees it belongs to Epoch 1 and instantly drops it. This prevents "split-brain" actuator conflicts in microseconds.
        **The Big Picture for the paper:**
        "While SpaceROS brings modern distributed publish/subscribe paradigms to aerospace, it currently relies on static OS schedulers that cannot handle dynamic distributed failures. We introduce a Cloud-Native Real-Time framework—pushing Kubernetes-style QoS eviction, Admission Control, and Sidecar routing directly into the PREEMPT_RT kernel to guarantee bounded worst-case latency during mission mode transitions and replica failovers."
        - [QA16.A1.A1.1] Can be there any intersection between this direction and the previous cross-layer scheduler one? or it would be better keep both direction seperated?
          - [AA16.A1.A1.1] They can intersect flawlessly. In modern systems research, the architecture are split into two parts: a Control Plane (which makes the rules) and a Data Plane (which executes the rules).
            * The Cross-Layer Scheduler (CROS-RT evolution) is our Control Plane.
            * The K8s-inspired OS concepts (eBPF sidecars, admission control) are our Data Plane.
          *By combining them, The K8S-style eBPF acts as the "Bouncer"(data dropping) at the door, and the Cross-Layer Scheduler acts as the "VIP Escort"(data processing) inside the club.
          Without the Bouncer, the VIP Escort has to wade through a massive crowd of garbage packets inside the kernel to find the VIP. Without the VIP Escort, the VIP gets in the door but gets stuck waiting in a normal CPU queue.*
          If we find that math/implementation is too heavy for one paper, we can split it:
            * Paper 1 (RTSS): Focus purely on the Cross-Layer Mode-Swapping math and bounding the CPU worst-case execution time.
            * Paper 2 (EuroSys): Focus purely on the Space-QoS / K8s eBPF network isolation.
          Unified solution would take the problem ("SpaceROS is blind to the OS") and solves it with a blend of robotics context, OS scheduling, and cloud-native networking.
    - ~~[Q16.1.1] In space robotic systems, How many nodes and hardware devices (interrupt producer) therein?~~
      - [A16.1.1] It might be enough for a tiny hard-real-time cloud.
        1. The main Control Plane (The K8s Masters)
        Crew Dragon and Starship use 3 main Flight Computers. They run PREEMPT\_RT Linux and operate in a continuous "voting" consensus.
        2. The Worker Nodes (Engine Controllers and Avionics)
        This is where the network gets incredibly congested. 18 processing units (54 actual units for triple-redundant) ~ 33 Raptor engines (in Starship).
        3. The Interrupt Producers (Sensors & Actuators)
        This is where the kernel gets overwhelmed. A vehicle like Starship has thousands of hardware devices generating interrupts.
        **Why the K8s Analogy is Perfect for this Scale**
        When Starship is in orbit, all 50+ nodes and thousands of sensors are blasting UDP packets across the spacecraft's internal Ethernet network. (tiny distributed systems and network matter)
        If a primary flight computer reboots (fault recovery), or the rocket flips to land (mode transition), the Linux kernel is suddenly hit by a tidal wave of tens of thousands of network interrupts from those 39 engine controllers and thousands of sensors. (in a dynamic severe state)
        Vanilla PREEMPT\_RT Linux collapses under that interrupt storm because it has no concept of "Admission Control" or "QoS Eviction." By bringing those Kubernetes concepts down into the kernel's eBPF layer (the Bouncer) and cross-layer scheduler (the Escort), we can guarantee that the 1 packet that actually matters—the engine ignition command—gets through in 2 milliseconds, no matter what the other 54 computers are doing!
- [Q17] What is a trade-off chain of your approach? what are you gonna take and sacrifice? ⚡️
  - [A17] 

## Knowledge for better understanding
- ~~[Q2] Where is the current status of space-ready OS (for physical AI systems)?~~
  - [A2] 1. The "Old Guard"  : RTEMS and VxWorks
         2. The "Math-Proven": seL4 and PikeOS
         3. The "Physical AI": Linux, ELISA, and DLR's ScOSA.
  - ~~[Q2.1] What is the difference between space-ready OS and normal OS?~~
    - [A2.1] A normal OS optimizes for fairness and throughput (keeping everyone happy). A space-ready OS optimizes for absolute determinism and survival (keeping the mission alive).
      - ~~[Q2.A1.1] How often is mission-mode changed?~~ (*value of mission transition work*)
        - [A2.A1.1] It is a tale of two extremes. For 99% of a mission, the mode never changes. For the critical 1%, modes change in a matter of milliseconds or seconds, and if the OS misses the deadline, the vehicle is destroyed.
          * The Coast phase (Months)
          * The EDL phase (Entry, Descent, and Landing - Minutes/Seconds): This is where our paper shines.
        Other severe states can be hardware/physical defect cases.
  - [Q2.2] Would you draw a system overview of space robotic systems?
- ~~[Q3] What are known challenges for rockets or space-robots from the perspective of software systems (OS)?~~
  - [A3] Radiation, Erroneous output, Stale commands and epoch clashes, safe mission transitions, communication latency, isolation across shared resources
- ~~[Q4] How can we destroy or interfere with the control of systems of the starship or space-robot?~~
  - [A4] priority inversion, deadlines, interrupt storm, etc.
    - ~~[QA4.1] Current space-ready OS can meet bounded worst-case latency?~~
      - [AA4.1] Short answer is yes, but with a massive asterisk.
                1. Traditional RTOSes (VxWorks, RTEMS, seL4): Yes (locally)
                2. Space Grade Linux (PREEMPT_RT): No (Under network load)
                * The real problem: "End-to-End" vs "Local" latency: *Current space OSes cannot guarantee bounded worst-case latency during mission mode transitions or fault recovery.*
- ~~[Q8] What is the difference between OS and ROS?~~
  - [A8] It's not fair to compare them. It's like Airline (ROS 2) and the Airport Infrastructure (Linux).
    - ~~[QA8.1] Okay. If so, What and Where is the control tower for them?~~
      - [AA8.1] No an unified one, two separate ones.
                Airline control tower decides "flight"(callback) and organizes "passengers" while
                Airport control tower controls the physical runways (CPU) and the arrival gates (Net/Mem)
  - ~~[Q8.1] What is the relationship between OS and ROS?~~ 💫
    - [A8.1] A stacked architecture:
             1. Top Layer: The Robot Code (Your custom C++ code to land Starship).
             2. Middleware Layer: ROS 2 / SpaceROS (Formats your commands and schedules your robotics tasks).
             3. Communication Layer: DDS (The protocol ROS 2 uses to pack the data for the network).
             4. OS Layer: Linux / PREEMPT_RT (Takes the packed data, puts it into a hardware buffer, and schedules the CPU).
             5. Bottom Layer: Hardware (The physical wires, antennas, and thrusters).
             -> They do not share information well.
                ROS 2 knows the *meaning* of the data.
                Linux only know the *shape* of the data.
- [Q10] Do they use cFS and OSAL? If so, what parts are insufficient based on the OSAL git repository?
- ~~[Q12] Does SpaceROS use GPU? Are there any spaces for GPU?~~
  - [A12] Yes, GPUs are currently making their way into space, but they are causing massive headaches for systems engineers.
    If our K8s-inspired Cross-Layer Scheduler is the "now," GPU scheduling for Physical AI in space is absolutely the **"next."**
    1. They aren't flying giant NVIDIA RTX 4090s. They use specialized SoC like NVIDIA Jetson AGX/Orin.
       The DLR ScOSA Project is actively researching how to integrate GPUs into distributed spacecraft to handle AI workloads.
    2. Here is why GPU scheduling in a real-time SpaceROS environment is a goldmine for systems research:
       Refer to the `future_direction.md`.
- ~~[Q14] Which OS do spaceROS and Starship use? Do they use Linux?~~
  - [A14] Yes, PREEMPT_RT patched Linux or ELISA, etc.
- ~~[Q15] Can be there any space for eBPF for space robotics? Especially, between ROS 2 and Linux kernel? (Of course, this talks about methodology, not core research problem)~~

### Study
- ~~[Q7] What is SpaceOS? What is feature of it?~~
  - [A7] It is a *middleware layer* of open-source flight framework from the ROS 2.
         Using Data Distribution Service (DDS) to allow different nodes to communicate.
    - ~~[QA7.1] Why do robotic systems need a middleware layer?~~
      - [AA7.1] First, abstractions for complexity from many like sensor devices
               Second, It enables distributed computing as if single unified computer.
        - ~~[QA7.A1.1] Does ROS have their own scheduler?~~
          - [AA7.A1.1] Yes it does. it is called the "Executor." ⚡️
- ~~[Q3] What is ELISA project?~~
  - [A3] A goal is to make certifiable Linux-based systems for safety-critical appliations.
         One focusing is dealing with hardware behaving unpredictably. e.g., Fault-tolerant file systems, Radiation simulation, etc.
- ~~[Q6] Which OS do space-mission systems use?~~
  - [A6] Realtime Linux, RTOS, VxWorks, RTEMS, etc.
- ~~[Q9] What is the PREEMPT_RT in Linux? What is the purpose?~~
  - [A9] PREEMPT_RT is a mechanism that shrinks the interval between the scheduler chose X and X is running. FYI, SCHED_FIFO is a policy.
  - [Q9.1] How it works?
- [Q11] What is cFS? What is the purpose of it?


