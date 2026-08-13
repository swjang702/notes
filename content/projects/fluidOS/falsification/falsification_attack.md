# Falsification Attack

## 1. The laundering attack *@ Current here*
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

- When is u_i(t) changed?
- How do interrupts/events account for u_i(t) at first?

## 2. Tier dilution
