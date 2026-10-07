# Question Tree

### Denotation Example
[Q1] Is it apple?
  - [A1] Yes, it is apple. Its color is red.
    - [QA1.1] Why is its color red?
      - [AA1.1] Because the color of every apple is red.
        - [QA1.A1.1] If every apple's color is red, can we say the color of apple is red?
          - [AA1.A1.1] Yes, it is, we call, inductive reasoning.
            - [QA1.A1.A1.1] OK. So, What is deductive reasoning?
        - [QA1.A1.2] What if the color of every apple is yellow?
        - [QA1.A1.3] How about banana?
          - [AA1.A1.3] Banana's color is yellow.
      - [AA1.1'] My teacher taught me.
      - [AA1.1'] My father told me.
    - [QA1.2] Why isn't its color blue?
  - [A1'] No, it is not.
  - [A1''] No, it is not. It is banana.
  - [Q1.1] Is apple fruit?
    - [Q1.1.1] How to define fruit?
      - [A1.1.1] First of all, fruits and vegetables are disjoint.
        - [Q1.1.A1] What does disjoint mean?
  - [Q1.2] Is apple food?
  - [Q1.3] Is apple animal?


## Phenomenon
[P1] *Physical AI systems responds slowly to an urgent event.*
- [Q1] What makes they re-act delayed?
  - [A1] The reason why intelligent robots act slow to an urgent event is asocciated with not how intelligent a robot is but systems' scheduling. [`Hypothesis and Motivation`]
    - [QA1.1] What is a problem of modern systems' scheduler to run a physical AI system?
      - [AA1.1] They, such as Linux EEVDF, were not designed for physical AI systems.
        - [QA1.A1.1] What is your approach?
          - [AA1.A1.1] One approach is to merge EEVDF with Tardiness work.
            - [QA1.A1.A1.1] What are EEVDF and Tardiness work?
              - [AA1.A1.A1.1] (move under [Q6])
          - [AA1.A1.1'] (move under ## Our Approach)
- [Q2] How can the robot act immediately to an urgent event?
  - [A2] A solution of [A1]
  - [A2'] Daniel kahneman system 1 or Unconscious Reflex?
    - [QA2'.1] What form do you expect eventually physical AI systems become? [`Motivation`]
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
- [AA1.A1.1'] Unified Fluid-system OS with *oil theory*
  - [QA1.A1.A1'.1] Can adversarial urgency signals beat the Bound 2's fairness? [[Q4.1]]
    - [AA1.A1.A1'.1] If so, we would call it *laundering attack*
      - [QA1.A1.A1'.A1.1] What is the laundering attack? [*Definition*]
        - [AA1.A1.A1'.A1.1] [[falsification/laundering_attack]]
          - [QA1.A1.A1'.A1.A1.1] How do you define `Laundering Attack`? [*Definition*]
          - [QA1.A1.A1'.A1.A1.2] How do you define `Lag debt`? [*Definition*]
          - [QA1.A1.A1'.A1.A1.3] When is u\_i(t) changed?
          - [QA1.A1.A1'.A1.A1.4] How to interrupts or events account for u\_i(t) at first?
        - [QA1.A1.A1'.A1.1.1] Before laundering attack, How about brute force attack?
          - ~~[AA1.A1.A1'.A1.1.1]~~ The research log 1
            - [QA1.A1.A1'.A1.1.1.1] [Anomaly] Why is the sum of lag non-zero?
            - [QA1.A1.A1'.A1.1.1.2] [Anomaly] What is the khugepaged, whose vlag was over the limit?
          - ~~[AA1.A1.A1'.A1.1.1']~~ The research log 2
            - [QA1.A1.A1'.A1.1.A1'.1] [Anomaly] Why did the `ps` pick up ahead of enqueue?
              - [AA1.A1.A1'.A1.1.A1'.1] To trace accurately it again with a simple bpf tracer??
    - [QA1.A1.A1'.1.1] How to know if EEVDF's fairness is beaten? / What guarantees EEVDF's fairness?
    - [QA1.A1.A1'.1.2] When to be broken of EEVDF's fairness?
    - [QA1.A1.A1'.1.3] How to generate urgency signals?
      - [QA1.A1.A1'.1.3.1] What makes external hardware interrupts equals urgent signals?

## Knowledge for better understanding
- [Q6] What is the history of this line of work? e.g., eevdf, gedf(tardiness), etc. [`Background and Related work`]
  - [AA1.A1.A1.1 == A6] EEVDF
    - [Q6.1] How does EEVDF work?
    - [Q6.2] How, when, and where are metrics(vd, vruntime, ve, and vlag) calculated? [`Implementation`]
    - [Q6.3] Where do I feel the fluid-state system of EEVDF in the code base or its relationships?
  - [AA1.A1.A1.1' == A6'] Tardiness work
- [Q7] How is the relationship between scheduling, CPU migration, and process life cycle?

### Study
- [Q8] What is CBS?



