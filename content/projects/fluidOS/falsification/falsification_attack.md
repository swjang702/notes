# Falsification Attack

## 1. The laundering attack
### Overview
- Define promotion and demotion
```
Normal-tier           Urgent-tier
    T(t)                 U(t)    
 ┌───────┐  Promotion ┌───────┐  
 │       ├───────────►│       │  
 │       │◄───────────┤       │  
 └───────┘  Demotion  └───────┘  
       (when u_i(t)<theta)       
```
```
                               Normal-tier           Urgent-tier                 
                Interrupts/        T(t)                 U(t)                     
Emergent        Events          ┌───────┐  Promotion ┌───────┐        Memory     
event      ──────►▒▒▒▒▒────────►│       ├───────────►│       │◄──────►▒▒▒▒▒      
in physical       ▒▒▒▒▒  write  │       │◄───────────┤       │        ▒▒▒▒▒      
world             Sensor  u(t)  └───────┘  Demotion  └───────┘     (lag consumer)
                (urgency              (when u_i(t)<theta)                        
                 producer)                                                       
```
```
                            capped at a 1-Beta,      capped at a reserved        
                            EEVDF's bounded lag      fraction Beta               
                                    ▲                    ▲                       
                                    │                    │                       
                               Normal-tier           Urgent-tier                 
                Interrupts/        T(t)                 U(t)                     
Emergent        Events          ┌───────┐  Promotion ┌───────┐        Memory     
event      ──────►▒▒▒▒▒────────►│       ├───────────►│       │◄──────►▒▒▒▒▒      
in physical       ▒▒▒▒▒  write  │       │◄───────────┤       │        ▒▒▒▒▒      
world             Sensor  u(t)  └───────┘  Demotion  └───────┘     (lag consumer)
                (urgency              (when u_i(t)<theta)                        
                 producer)                                                       
```
`
Interrupts/events are urgency producers: they are the sensor through which the physical world writes into u_i(t)
Memory is a lag consumer: eviction decisions read the scheduler's state and are priced in the scheduler's own currency.
Memory tells it what future work will cost.
It needs the one number each produces: u_i(t) from events, and a recomputation cost e_extra from memory.
`

- Promotion changes a task's *future* **fluid rate only**.

### Questions
- When is u_i(t) changed?
    - After handling the urgent task by the scheduler?
- How do interrupts/events account for u_i(t) at first?
- Does the Premise ii. ask a relationship between interrupt and other resources?

### Algorithm
**Assumption**
i. There is a kind of *urgency* property within OS.

**Premise**
i.   A physical event emergent triggers an interrupt.
ii.  Urgency propagates from interrupt to other resources.
     is equivalent to
     The result of it is that other resources such as CPU scheduling, GPU execution, memory are affected
     at once (by that urgency).
iii. After an urgency wave, the resources related get back to their original status.

Based on the Premise ii. and iii., we can say that the laundering attack occur in incessant loop between the Premise ii. and iii., which subsumes the case of regarding promotion & demotion as it excludes the computation of promotion & demotion.
Therefore, if we can justify this version of laundering attack, we verify the existence of the laundering attack in the design of FluidOS. If so, we falsify the design against laundering attack.

**Pseudo Procedure**
1. Interrupt occur.
2. Observe resources affected by it. *@ Current here*
3. After completing the task, Observe again the resources getting back to their original positions.
4. Loop incessant 1 to 3.
5. While the loop, figure out abnormal status of some resources or OS.

**Preparation for the Procedure**
- How to occur an interrupt mapped to an emergent physical event.
    -> refer to `How to trigger an interrupt` section in the study.md
- Define which resources and hooks you look at.

## 2. Tier dilution
