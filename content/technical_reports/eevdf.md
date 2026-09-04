# EEVDF

## Understanding of Concept

```
lag = ideal service − actual service
    = (elapsed time)/n  −  (quanta actually received)

           lag = −q                 0                 +q
              │                     │                  │
    ──────────┼─────────────────────┼──────────────────┼──────────
       ahead / rich              on target        behind / poor
    (got more than share)                     (got less than share)
              ▲                                        ▲
              │                                        │
        ELIGIBILITY                              DEADLINE
      caps how far ahead                     caps how far behind
```

- eligibility = ceiling on the rich. You may not take more.
- deadline = floor for the poor. You may not be left with less.
* Sum of lags = zero
--> With all, it draw a fluid-system. (lag is water? i.e., for being fluid-system, you need a medium?)

```
real (quantum-based, q = 1ms):

C1  ████                        ← 100% for 1ms, then nothing
C2      ████
C3          ████
C4              ████
    └───┴───┴───┴───┘
    0   1   2   3   4  ms


ideal (fluid):

C1  ░░░░░░░░░░░░░░░░            ← 25% continuously
C2  ░░░░░░░░░░░░░░░░
C3  ░░░░░░░░░░░░░░░░
C4  ░░░░░░░░░░░░░░░░
    └───┴───┴───┴───┘
    0   1   2   3   4  ms
```

### One asymmetry worth noticing

The two bounds are not enforced the same way, and this is a real structural difference:

- **The ceiling is mechanical.** `entity_eligible()` returns false and the task is simply not a candidate. It cannot run. The bound holds by construction — no proof required.
- **The floor is emergent.** Nothing in the code says "guarantee this task finishes by its deadline." The scheduler just sorts eligible tasks by virtual deadline. The floor is a consequence of that ordering, and it has to be proved — which is precisely what those lemmas you've been reading are doing.

So your rich/poor picture has a nice extra wrinkle: taxing the rich is a law with an enforcement mechanism, while the safety net for the poor is a theorem about what the law's side effects turn out to guarantee. That's why the paper spends pages on the second and none on the first.


## Implementation

### Eligibility Check in code

*/kernel/sched/fair.c*
```C
int entity_eligible(struct cfs_rq *cfs_rq, struct sched_entity *se)
{
	return vruntime_eligible(cfs_rq, se->vruntime);
}
```

### Time Quanta
```C
/*
 * Minimal preemption granularity for CPU-bound tasks:
 *
 * (default: 0.70 msec * (1 + ilog(ncpus)), units: nanoseconds)
 */
unsigned int sysctl_sched_base_slice			= 700000ULL;
static unsigned int normalized_sysctl_sched_base_slice	= 700000ULL;
```


