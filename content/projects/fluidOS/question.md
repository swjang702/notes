# Question Tree

## Phenomenon
[P1] *Physical AI systems responds slowly to an urgent event.*
- [Q1] What makes they re-act delayed?
  - [A1] The reason why intelligent robots act slow to an urgent event is asocciated with not how intelligent a robot is but systems' scheduling. [`Hypothesis and Motivation`]
    - [Q1.1] What is a problem of modern systems' scheduler to run a physical AI system?
      - [A1.1] They, such as Linux EEVDF, were not designed for physical AI systems.
        - [Q1.1.1] What is your approach?
          - [A1.1.1] One approach is to merge EEVDF with Tardiness work.
            - [Q1.1.1.1] What are EEVDF and Tardiness work?
              - [A1.1.1.1] (move under [Q6])
          - [A1.1.1'] (move under ## Our Approach)
- [Q2] How can the robot act immediately to an urgent event?
  - [A2] A solution of [A1]
  - [A2'] Daniel kahneman system 1 or Unconscious Reflex?
    - [Q2'.1] What form do you expect eventually physical AI systems become? [`Motivation`]
- [Q3] What is an `urgent event`? [*Definition*]

[P2] *In Linux EEVDF, lag debt caused by insufficiency of handling urgent events of current systems' scheduler affect other kernel resources, such as memory management and interrupt handling, at once.* (urgency propagation) [`Hypothesis` yet]
- [Evidence1]
- [Problem1] Linux subsystems are managed by different mechanisms and polcies.

## Why existing works/mechanisms couldn't solve?
- [Q4] What is a difference between **urgency** in FluidOS and **deadline** in EEVDF?
  - [Q4.1] How to know a task is urgent? [[Q3]]
    - [Q4.1.1] How can we know how much urgent it is? (How to measure urgency)

## Is your question or approach fundamental?
- [Q5] If high-performance hardwares comes out such as ultra high frequency for robotic systems, is still urgency matter for physical AI?

## Our Approach
- [A1.1.1'] Unified Fluid-system OS with *oil theory*
  - [Q1.1.1'.1] Can adversarial urgency signals beat the Bound 2's fairness? [[Q4.1]]
    - [A1.1.1'.1] If so, we would call it *laundering attack*
      - [Q1.1.1'.1.1] What is the laundering attack? [*Definition*]
        - [Q1.1.1'.1.1.1] Before laundering attack, How about brute force attack?
          - ~~[A1.1.1'.1.1.1]~~ The research log 1
            - [Q1.1.1'.1.1.1.1] Why is the sum of lag non-zero?
            - [Q1.1.1'.1.1.1.2] What is the khugepaged, whose vlag was over the limit?
    - [Q1.1.1'.1.1] How to know if EEVDF's fairness is beaten? / What guarantees EEVDF's fairness?
    - [Q1.1.1'.1.2] When to be broken of EEVDF's fairness?
    - [Q1.1.1'.1.3] How to generate urgency signals?
      - [Q1.1.1'.1.3.1] What makes external hardware interrupts equals urgent signals?

## Knowledge for better understanding
- [Q6] What is the history of this line of work? e.g., eevdf, gedf(tardiness), etc. [`Background and Related work`]
  - [A1.1.1.1 == A6] EEVDF
    - [Q6.2] How does EEVDF work?
  - [A1.1.1.1' == A6'] Tardiness work

