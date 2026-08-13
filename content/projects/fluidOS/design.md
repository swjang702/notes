# Design
## Model
- Task t = (w, u(t), lag(t))
    - w is nice value (constant)
    - u(t) is urgency (future info)
    - lag(t) is a difference between ideal time and actual time (past info)
- Global:
    - System parameter B: the urgent-tier reservation
    - Urgent set U(t) = { t_i : u_i(t) >= theta } for promotion threshold *theta*.

## The fluid reference (what lag is measured against)
### Fluid rate
- Normal tasks: fluid rate = w_i / W_normal * (1-B_used(t)) * C, where C is machine capacity, W_normal is the normal-tier weight sum, and B_used(t) <= B the capacity the urgent tier actually consumed.
- Urgent tasks: fluid rate = their share of the reserved B, split within the tier by weight * urgency.
