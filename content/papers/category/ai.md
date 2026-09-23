# [25 RTSS] LEMIX: Unified Scheduling for LLM Training and Inference on Multi-GPU Systems (Outstanding Paper)
- The first study about concurrent GPU utilization between inference and training for heterogeneous workloads.
- The problem of existing systems is **seperated envs** for each inference and training, which leads to loss of utilizations of GPU. (I think they saw the gap to be able to improve gpu util in it.)
- They motivated by one paper innovative, and tried to improved it. Since there are few prior research, they suggest the base one and advanced one on their side.

# [23 SOSP] Efficient Memory Management for Large Language Model Serving with PagedAttention
## Other Quotes
* A Comprehensive Overview of Large Language Models: The deployment of LLMs on homogeneous hardware can be further optimized in memory, throughput, and latency space by efficiently managing the KV cache.

- They so resemble the OS: virtual memory's page table/swapping, shared libraries, FIFO(First-Come-First-Serve), and so forth.

# [26 arXiv Journal] TETRARL: A Self-Adaptive Runtime for On-Device Deep Reinforcement Learning Systems
- Firstly, suggest an R4 optimization problem about on-device DRL.
- Substantially couple prior two conference papers.
- Use Multi-Objective Markov Decision Process (MOMDP).

# [26 Nature] Outplaying elite table tennis players with an autonomous robot
## Summary
The table tennis AI robot is capable to compete with a elite human athelete by using good sensors and well-trained policies.
To acquire granular perception, they use several fine-grained sensors.
For agile control, Ace leverages a deep RL policy which is trained by an algorithm named SAC.
These allow the AI robot move fast with high frequency.
This work show state of the art physical AI attain a high level of agility against top-level human athletes with domain specific deep RL training and apt sensors.

## Strengths and Weaknesses
### Strengths
- They achieve low-latency perception and control in physical AI system.
- Mathematically well-trained models.
### Weaknesses
- It is quite domain-specific training and enviornment.
- Lack of generalization yet.
