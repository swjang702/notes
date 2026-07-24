# Linux CFS

## What I know currently
- All tasks share equal CPU time ideally.
- Linux CFS leverage a concept of virtual runtime aka vruntime.


## What I don't know


## What I want to know
- entrypoint (e.g., runqueue, cpu)
- what is the unit of a task?
- How to know current running task process owning CPU.
- What about multi-core processor?
- What is vruntime?


## Hypotheses


## Concept
A task in Linux scheduler is a runnable thread.


### Syscalls Sched
From the manpages, the number of sched syscalls is only fifteen.
```bash
   nice(2)
          Set a new nice value for the calling thread, and return the new nice value.

   getpriority(2)
          Return the nice value of a thread, a process group, or the set of threads owned by a specified
          user.

   setpriority(2)
          Set the nice value of a thread, a process group, or the set of threads owned  by  a  specified
          user.

   sched_setscheduler(2)
          Set the scheduling policy and parameters of a specified thread.

   sched_getscheduler(2)
          Return the scheduling policy of a specified thread.

   sched_setparam(2)
          Set the scheduling parameters of a specified thread.

   sched_getparam(2)
          Fetch the scheduling parameters of a specified thread.

   sched_get_priority_max(2)
          Return the maximum priority available in a specified scheduling policy.

   sched_get_priority_min(2)
          Return the minimum priority available in a specified scheduling policy.

   sched_rr_get_interval(2)
          Fetch  the quantum used for threads that are scheduled under the "round-robin" scheduling pol‐
          icy.

   sched_yield(2)
          Cause the caller to relinquish the CPU, so that some other thread be executed.

   sched_setaffinity(2)
          (Linux-specific) Set the CPU affinity of a specified thread.

   sched_getaffinity(2)
          (Linux-specific) Get the CPU affinity of a specified thread.

   sched_setattr(2)
          Set the scheduling policy and parameters of a specified thread.  This (Linux-specific)  system
          call provides a superset of the functionality of sched_setscheduler(2) and sched_setparam(2).

   sched_getattr(2)
          Fetch  the scheduling policy and parameters of a specified thread.  This (Linux-specific) sys‐
          tem call provides a superset of the  functionality  of  sched_getscheduler(2)  and  sched_get‐
          param(2).
```

In my test code, I confirmed three syscalls, *getpriority, setpriority, and sched_getscheduler*.
Fun fact is a scheduler policy is set per pid. what does it mean? All tasks run in its own policy?


## Tests

- cfs.c : usage of sched-related syscalls
- main.c : user-space program for eBPF
- sched.bpf.c : a bpf program to use tracepoints and important kernel function in connection with sched.

I write a simple C code to learn usage of all sched-related syscalls. Also, to check hooks including tracepoints and kernel functions, I leverage eBPF program. One advantage of this way is that it can also be used to test sched_ext which is bpf level external scheduler in Linux. Thus, I choose eBPF to confirm kernel operations.

### Setup
- Linux 6.19.8

### Results
- One figure to depict Linux CFS operation.
- One graph that takes all processes as X-axis and CPU time sharing as Y-axis.


## Limitations


## Lessons


## Conclusions
