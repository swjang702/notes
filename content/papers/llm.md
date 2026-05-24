# [25 RTSS] LEMIX: Unified Scheduling for LLM Training and Inference on Multi-GPU Systems
- The first study about concurrent GPU utilization between inference and training for heterogeneous workloads.
- The problem of existing systems is **seperated envs** for each inference and training, which leads to loss of utilizations of GPU. (I think they saw the gap to be able to improve gpu util in it.)
- They motivated by one paper innovative, and tried to improved it. Since there are few prior research, they suggest the base one and advanced one on their side.

# [23 SOSP] Efficient Memory Management for Large Language Model Serving with PagedAttention
## Other Quotes
* A Comprehensive Overview of Large Language Models: The deployment of LLMs on homogeneous hardware can be further optimized in memory, throughput, and latency space by efficiently managing the KV cache.
