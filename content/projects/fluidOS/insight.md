# Insights (Hypotheses)

## Foundations
- [A1] The reason why intelligent robots act slow to an urgent event is asocciated with not how intelligent a robot is but systems' scheduling. [`Hypothesis and Motivation`]
  - [P2] Furthermore, *In Linux EEVDF, lag debt caused by insufficiency of handling urgent events of current systems' scheduler affect other kernel resources, such as memory management and interrupt handling, at once.* (urgency propagation) [`Hypothesis` yet]
    -> This is a key clue for an unified fluid system.
    - But, [Problem1] Linux subsystems are managed by different mechanisms and polcies. So, there occur silo.
- Interrupt (handler) is a producer of urgency.
- Memory is a consumer of lag.

## Oil theory
- 😎 fluidos: if eevdf is fluid state of water, urgency is like oil. then, What I have to figure out is the characteristics of them. (how to express this relrationship in math?) (like immiscible abstraction layer but atop. and can move/go up fast like highpass)
