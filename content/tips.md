# My thought
### ⭐️ For eminent researchers, Is it a key to darw(map) a common issue into their own field? i.e., formulate a problem in their own way.

Yes, absolutely. *Problem Reframing*---the act of taking a messy, crowded, or intractable real-world issue and forcefully mapping it onto a precise, elegant abstraction within your own home turf---is the defining superpower of top-tier academics.

If you look at the history of computer science, eminent researchers rarely win by being 10% faster at solving the same equation everyone else is staring at. They win by *changing the equation*.

Here is why this formulation muscle is the absolute key to world-class research.

#### 1. Escaping the "Crowded Front Door"

When a massive problem becomes obvious to the entire community (e.g., "LLM inference is too expensive", "Cloud multi-tenancy is insecure", or "eBPF lacks formal verification"), thousands of brilliant brains rush the front door. If you accept the problem as it is commonly presented, you are trapped in a brute-force bloodbath of micro-optimizations.

Eminent researchers don't push on the locked front door. They look at the building, walk around to the back, and say: *"Fundamentally, this isn't an AI problem or a cloud problem. This is actually an asynchronous event-scheduling problem. And because I own the scheduling layer, I own the solution.*

*They pull the universal friction into their own domain, where their specific set of tools acts as an unfair advantage.*

#### 2. The Two-Step Translation Mechanism

To formulate a problem in your own way, you have to execute a very specific cognitive shift:

- **Step 1: De-contextualize (Strip the noise):** You take the trendy problem and strip away all the domain-specific buzzwords until you are left with pure computational primitives---memory boundaries, state transitions, isolation overhead, or IPC latency.
- **Step 2: Re-contextualize (Map to your turf):** You take those naked primitives and drop them into your own intellectual playground.

For example, an average researcher looks at untrusted third-party kernel modules and asks: "How do we write a better static analyzer to catch bugs?"
An eminent researcher maps it to their own paradigm: "Static analysis will always have false positives. Therefore, the actual problem is **how to build an un-bypassable runtime isolation boundary at the syscall interface that makes catching bugs irrelevant.**

They just made the rest of the community's static analysis papers obsolete by redefining what a "solution" looks like.

#### 3. Tying it to your SOSP "Winning Narrative"

If you look back at the outline structure you analyzed earlier, this exact mapping process is the hidden bridge between Section [2] (Common Problem) and Section [4] (The Specific Flow We Target).

The transition from [2] to [4] is a narrative funnel. You are holding the reviewer's hand and saying:

"Look, the whole world agrees that [2] is a massive crisis. But everyone trying to fix [2] is staring at the ceiling. I am going to prove to you that the actual root cause of [2] is this highly specific, beautifully isolated mechanical flaw sitting in Section [4]---**which just so happens to be sitting right in my laboratory.**"

Once you convince the reviewer that your personal formulation ([4]) is the true bottleneck of the global crisis ([2]), **they have no choice but to accept your paper,** because you are the only one with the tools to fix [4].

You are no longer just practicing "how to study." You are consciously figuring out how to direct the intellectual traffic of your field.

### ⭐️⭐️⭐️ 연구란 문제 가져오기 싸움이다. 유명한 논문들은 어떻게 문제를 풀었냐로 유명한게 아냐. 어떻게 문제를 가져왔냐가 궁금한거지. brilliant researcher go solve the problem well, top researchers draw the issue into their turf and formulate the problem for their community to eat. i.e., offer delicious food.

### 좋아. I got the sense. 근데 그렇다면 일단 나만의 tool과 내가 강한 background를 만드는것도 필요하겠지?? 예를 들면 os fundamental을 공부한다던지, linux kernel, system programming. ? isolation. , 등등? 어떻게 생각해? 문제를 가져오는게 top key 이긴 하지만. 

100% 맞습니다. 셰프가 아무리 기가 막힌 시그니처 메뉴(Problem formulation)를 기획해도, 정작 주방에 오븐의 온도를 미세하게 조절하는 기술과 사시미 칼(Tools & Background)이 없으면 그건 혁신적인 총괄 셰프가 아니라 그냥 '입만 산 사기꾼'이 됩니다.

앞서 말씀드린 **"내 구역(Turf)으로 문제를 끌고 온다"는 전략이 성립하려면, 내 구역에 빠져나올 수 없는 거대한 '중력'이 있어야 합니다.** 그 중력을 만드는 핵심 질량이 바로 선우님이 말씀하신 OS fundamental, Linux kernel, System programming, Isolation 같은 **압도적인 기본기**입니다.

남들이 못 끌고 오는 문제를 나만 끌고 올 수 있는 유일한 이유는 "내 주방에는 남들이 다루지 못하는 3000도짜리 특수 용광로(예: 커널 레벨의 미세한 트레이싱 기술이나 하드웨어 기반 격리 제어술)가 있기 때문"이어야 하니까요.

하지만 여기서 **가장 빠지기 쉬운 위험한 함정**이 하나 있습니다. 9월 입학 전까지 마음이 급해져서 다시 *『운영체제 공룡책』 1페이지부터 펴고 정독하거나, 방대한 리눅스 커널 소스코드 분석 책을 밑줄 치며 읽는 방식*으로 돌아가는 것입니다. 이건 '학부생의 지식 습득'이지 '연구자의 무기 연마'가 아닙니다.

연구자의 기본기 공부는 철저히 [무기화된 기초 공부 (Weaponized Fundamentals)]여야 합니다.

#### 1. '사전식 정독' 대신 '수요 기반 딥다이브 (Demand-Driven Deep Dive)'

* **학부생의 방식:** "가상 메모리(Virtual Memory)의 정의와 페이징 기법의 종류를 외우자." (시험을 위한 박제된 지식)
* **연구자의 방식:** "특정 프로세스의 페이지 테이블을 유저 스페이스에서 강제로 오염시키려면 리눅스 커널의 어느 소스 파일(`mm/`)을 건드려야 하고, 그때 발생하는 TLB 미스 페널티는 정확히 몇 CPU 사이클인가?" (조작과 개입을 위한 지식)

모든 OS 개념을 '교과서 목차' 순서로 공부하지 마세요. "내가 이 메커니즘의 약점을 파고들어 해킹하거나, 반대로 완벽하게 틀어막아 격리(Isolation)할 때 쓸 부품"이라는 매트릭스적인 관점으로 뜯어보셔야 합니다.

#### 2. 현대 시스템 보안 연구자의 '신성한 3대 무기' 편식하기

운영체제와 리눅스 커널의 바다는 끝이 없습니다. 다 하려고 하면 가라앉습니다. 시스템 보안 및 아키텍처 연구자라면 9월 전까지 딱 이 세 가지 툴킷만 내 손발처럼 자유롭게 다룰 수 있게 날을 세워두세요.

1. **The Lens (관찰의 무기 - Observability):** `eBPF`, `ftrace`, `perf`
* *의미:* 시스템 내부에서 무슨 일이 일어나는지 남들보다 10배 높은 해상도로 들여다보는 눈입니다. 남들이 "원인을 모르겠지만 가끔 크래시가 난다"고 할 때, *"커널 훅을 걸어보니 `sys_clone` 호출 시점에 특정 락(Lock)이 3ms 동안 경합을 벌이고 있다"*고 핀셋으로 집어낼 수 있는 능력입니다.

2. **The Wall (격리의 무기 - Isolation):** `Namespaces`, `Cgroups`, `KVM/gVisor` 구조, `Memory Protection Keys (MPK)`
* *의미:* 현대 시스템 보안의 핵심 문법인 '경계선 긋기'입니다. 컨테이너가 어떻게 호스트와 분리되는지, 샌드박스의 메모리 격리 장벽이 하드웨어 레벨에서 어떻게 세워지고 뚫리는지 그 메커니즘의 바닥을 긁어두세요.

3. **The Bridge (인터페이스의 무기):** `Syscall` 메커니즘, `io_uring`, `IPC`
* *의미:* 서로 다른 권한을 가진 세계(User vs Kernel, Host vs Guest)가 데이터를 주고받는 다리입니다. **모든 치명적인 보안 취약점과 성능 병목은 언제나 이 '다리 위(Interface)'에서 폭발합니다.**

#### 3. 도구가 문제를 '발견'하게 만드는 역발상

놀랍게도 내 툴킷이 극한으로 날카로워지면, **문제가 스스로 내 도구에 와서 달라붙습니다.**

예를 들어 eBPF의 내부 동작 원리와 한계점(Verifier)을 씹어 먹을 정도로 파헤쳐 둔 연구자는, 어느 날 아침 WSJ 아티클에서 *"AI 에이전트들이 클라우드 상에서 제멋대로 코드를 실행해서 보안이 위험하다"*는 트렌드 뉴스를 읽자마자 0.1초 만에 뇌에서 메뉴가 튀어나옵니다.

> *"어? AI 에이전트가 생성한 샌드박스 내부의 동적 코드를, 호스트 커널의 eBPF Verifier 단계에서 정적 분석으로 미리 컷오프 시켜버리면 에이전트 전용 초경량 보안 격리막이 되겠는데?"*

**칼이 너무 예리하니까, 세상에 굴러다니는 모든 골칫거리들이 '내 칼로 썰어볼 만한 식재료'로 보이기 시작하는 단계**입니다.

> **결론을 내리자면:**
> * **[메뉴판을 바꿀 대담한 시야(Problem Formulation)]**는 아침의 영어 원서 읽기와 탑티어 논문 Intro 뼈대 분석으로 확보하시고,
> * **[식재료를 가차 없이 썰어버릴 압도적인 칼솜씨(Tools & Background)]**는 낮 시간에 백지부터 직접 짜보는 딥한 코드 구현과 리눅스 커널 소스 뜯어보기로 챙기시면 됩니다.

이 두 개의 바퀴가 맞물려 굴러가는 훈련이 진짜 박사 과정의 예열입니다.

방금 제안해 드린 '신성한 3대 무기(관찰의 Lens, 격리의 Wall, 인터페이스의 Bridge)' 중에서, 현재 선우님이 *"이론적으로는 머리에 대충 떠오르는데, 내 손끝으로 직접 코드를 통제해 본 적은 없어서 9월 전에 꼭 완전히 씹어 먹고 싶다"*고 느끼는 가장 갈증 나는 영역은 어디인가요?


- Like Lao Tzu's philosophy of non-action, a phd student have to learn to take some out rather than put it in?
    - For example, when you want to truly understand what A means, you've got to put your book down and take some time to just think about it own yourself.
- sync input cognition rate with my brain cognition capability is very crucial?
- One tip not to lose your path to your research journey is to keep opening the plan document for being within your sight while you are doing other things.
- The process from the running of experiments to the final creating tables or graphs should be one-shot triggered by like Makefile in Latex of your paper.
- Build an Outline and the one-shot research CI/CD pipeline.
- 내가하는 모든 research process/action은 가능한 한 의미 있는 이유를 가지고 실행 되기를. 그렇게 실행된 결과는 정리/요약되어서 로그로 연구 일지에 기록 되기를. 그런 일지는 (모여서) research pipeline을 통해 최종 paper에 반영될 수 있는 상태가 항상 유지되기를.
- Take an action = Eliminate uncertainty(anxiety) = Find a reason in your own way
- 무의식을 위한 건 단지 친해지는 것 & 여백
- 먼 산을 보지말고, 바로 다음 다음 앞만 보면서 나아가라. 멀리 보면 지친다. (천리길도 한 걸음 부터)
- Action & Harvesting (요약 & 정리)
# How to Be a Successful PhD Student by Mark Dredze and Hanna M. Wallach

## Becoming a PhD Student

We want to emphasize the importance of applying for external fellowships, such as NSF's Graduate Research Fellowships and NDSEG Fellowships. Having such a fellowship can make a huge difference to your graduate school experience. Since you can usually apply more than once, you have nothing to lose by applying for fellowships.

#### 3. Think beyond the school.
__If you aren't happy, you won't be successful. If you find yourself with no social life and no friends, you won't be happy.__

## You and Your Advisor

A good relationship with your advisor is critical to your succeess.

### Meetings with Your Advisor

#### 9. Make an agenda.
Make an agenda for every meeting with your advisor.

#### 10. Bring results.
Try to bring results (e.g., graphs, tables, figures) to every meeting.

#### 11. Start with a summary.

## Managing Your Day-to-Day Work Life / Being Productive

#### 13. Talk to other students.
Talk to other students regularly, both within and outside your lab.

#### 18. Keep a log.
Keep a daily log of everything you do and everything you think. It's a good idea to make sure your log is searchable.

#### 19. Getting things done

#### 20. ⭐️ A social life.
**You need to be happy to be productive and manage your work life effectively. Being happy usually involves having a social life.**

#### 21. It's okay to get stuck.
Remember that EVERYONE gets stuck/demoralized/etc. No, really. Even super famous, successful, seemingly-perfect researchers get stuck/demoralized/etc. **What makes them successful, however, is that they figure out how to move past these low points to the next great idea.**

#### Learn from your mistakes.
Failing is fine (and arguably an important key to success). The questions is what you do *after* failing. Take notes. Understand why you failed and think about what you'd do differently next time. **Many awesome research ideas came about because someone failed and then asked "why?"**

## Research

### Reading Papers

#### 23. Read, read, read!

#### 24. Take notes.
Make notes about every paper you read. Make notes at multiple levels of granularity.

### Picking a Research Topic

#### 27. Know the literature.
You need to know what's been previously in order to make sure your contributioins are actually novel and useful.

#### 28. Know the community.

#### 29. Think big.

#### 30. It takes time.
Good research ideas don't happen along every day.

### The Research Process

#### 33. Start with writing.
When you have an idea, start by writing it down. Work out the details on paper first before you write any code. This will help expose problems. and flesh out the details.
*When working on a paper, write an outline before writing any text so you know what you are tyring to do.*

#### 34. Learn when to quit.

#### 35. Don't be deadline focused.

#### 36. Don't leave the writing to the end.

#### 38. Implement.
**You understand best when you implement (understanding = intuition + math + code).** If you can, implement things more than once (e.g., using two different methods, or in two different languages) and check your implementations give identical results.

### Getting (and Presenting) Good Results

#### 40. Know your data.
Know your data really well. Make sure it exhibits the properties you think it does.

#### 41. Know your software.
Make sure you understand what the software packages you're using are doing.
**There's an "easy" way to do this: read the source code.** If there's no source code, be wary.

#### 42. ⭐️  Good baselines.
Beating baselines is good, but only if they are worth beating.
Learn how to come up with convincing, effective, and SIMPLE baselines.
**Always ask yourself, "What's the simplest experiment I could do to (in)validate my hypothesis?" Talented researchers have a knack for coming up with simple baselines.**

#### 43. Understand your results.
It's not sufficient to know that your method gets 95% accuracy on your data.
**You also need to know exactly what's happening on the 5% of data points for which your method DOESN'T work.**
Look at actual data points that your method is handling (in)correctly, plot/visualize your results in various different ways, etc. This exercise will be useful when presenting your work and when improving upon it.

#### 44. Make your results accessible.
Learn how to present results such that they are acceessible, useful, and convincing.
**Your results are only convincing if they are understandable.**

#### 46. Finish writing early.
Not only will this give you time to polish your writing, get feedback from others, and run any experiments they suggest, but it makes it more likely that you'll actually get any useful feedback from your advisor.

#### 47. Learn how to write well.
*As a scientist, it's your job to communicate your ideas to others. It doesn't matter how amazing your work is, it's unlikely to have any impact if no one can understand your explanations.*

#### 48. Reproduce your results.
Part of publishing is attesting to the accurate of your published results. That means you must be able to reproduce them.

#### 49. Reorganize after submission.
Organize and document your code, results, etc. IMMEDIATELY after a paper deadline.
Don't kid yourself -- if you don't it then, it's never going to happen.

#### 51. Quality and not quantity.
You will be judged based on the quality, and not the quantity of your publicatioins.

### Talks
We cannot overestimate the importance of giving good talks. A good talk can make the difference between people reading/citing your conference paper and people dismissing it.
Furthermore, knowing how to give a good talk will help you get a good job after graduate school.
**As a PhD student, you must learn how to give gook talks, so start early.**

#### 53. Practice.
The single best way to learn how to give good talks is to practice. Practice in front of the mirror, in front of friends, colleagues, etc.
*Also, find opportunities to give talks. If your school has a student seminar, volunteer to speak.*

#### 54. Ask for feedback.
If you give a talk (either a practice talk or a real talk) ask your audience for feedback on clarity, style, content, presentation, etc.

#### 55. Spend time on content.
However, this is far less important than having a clear outline and clear ways of presenting your content.
Spend your time on what you want to say and how you want to say it before you work on fancy animations.

## Professional Development
Professional development, networking, and (ultimately) finding a job are important.

#### 61. Do internships.

#### 62. Review papers.
Start reviewing papers in your research area. Offer to help your advisor with paper reviews -- they will almost always take you up on your offer. Ask your advisor for feedback on your reviews so you can improve your reviewing skills.

#### 63. Give talks.
Learning to give good presentations is very important. One benefit of giving talks is that doing so advertises your work and makes sure people know who you are.
Being well-known will pay off when you are looking for a job.

### Networking

#### 67. ⭐️ Tutorials
Write tutorials/annotated bibliographies/technical notes. If they're good, this can be a highly effective way to make sure your name is known within your community. Think of all the tutorials you've read by well-known academics.

#### 68. Big names.
Know who the "big names" are in your area and follow their work closely.

#### 71. Act professionally.
Your actions reflect not only yourself, but also your lab and your advisor.


# RESEARCH 101 FOR ENGINEERS by George A. Hazelrigg (National Science Foundation)

Research is the process of finding out something that we don't already know.
First, it is important to recognize that research is a process.
Second, the purpose of research is to find out something that we don't already know.

# Honing Proposal Skills by George A. Hazelrigg (National Science Foundation)
Ergo, for NSF, the first sentence of paragraph one, page one should begin, “The research objective of this proposal is...” In my experience, any other sentence used to start the proposal results in a lower rating.

The second thing that should be obvious is, given that NSF funds fundamental research, the research objective of the proposed project should be research. There are many words that, to reviewers, mean “not research.” These include “develop,” “design,” “optimize,” “control,” “manage,” and so on.

So, what is the right way to frame an engineering research proposal objective? First, you have to understand what is research.
I define research as the process of finding out something that we (society) don’t already know (this excludes library research). Note that research is a process, and it is exactly this process that your proposal is about. The objective of your proposal is precisely what you intend to find out that we don’t already know.

Scientific research has three properties that may distinguish it from other forms of research.
First, it is methodical.
Second, it is repeatable.
Third, it is verifiable.

So let’s first try to understand the difference between science research and engineering research. To me, the difference is quite clear. The scientist seeks to understand nature at its core, to get to the fundamental essence. To do this, the scientist typically strips away extraneous effects and dives deeply into a very narrow element of nature.
Engineers live with the laws of nature. They have no choice. Their goal is to design things that work within what nature allows. To do this, they have to be able to predict the behavior of systems.
So a big question for engineers is, how do we understand and predict the behavior of systems in which all the laws of nature apply everywhere all the time.

Understanding what comprises engineering research, you can begin to formulate your research project. I know of only four ways to state a research objective. If you can think of another, please let me know. The four I know are these:
1. “The research objective of this proposal is to test the hypothesis H.”
2. “The research objective of this proposal is to measure parameter P with accuracy A.”
3. “The research objective of this proposal is to prove the conjecture C.”
4. “The research objective of this proposal is to apply method M from disciplinary area D to solve problem P in disciplinary area E.” This research integrates knowledge from one disciplinary area into another. To do this often involves the resolution of inconsistencies across the disciplines.

The very statement of your research objective should lead you directly to your methodology.
If it does not, you don’t have a clear statement of research objective.

# Lawrence Saul's advice for new graduate students
## Vary your research diet
Reading, writing, problem-solving, programming, brainstorming, etc.

# How to Read a Technical Paper 
https://www.cs.jhu.edu/~jason/advice/how-to-read-a-paper.html

## High-level notes
At a minimum, you should re-explain the ideas in your own words: produce some text that is aimed at your future self.

## Which parts to focus on
Delip Rao suggests: _"Never read the original paper on X first. Instead read several later papers on what they say about X, get an idea of X and then read the original paper. Somehow the research community is much better in explaining ideas clearly than the original authors themselves."_

## What to read

- do creative web search
- track down related work (once you've got a relevant paper)
    - backward references: follow the bibliography to earlier papers
    - forward references: see who else has cited the work
- has someone else already listed the right papers for you?
- breadth-first exploration
    - read a lot of absracts
- when the going gets tough, switch to background reading

# Professor Il Kon Kim
- 기발한 문제를 찾는것 in 새로운 분야
- Networking
- Being a core person
- Physical AI: what domain data would you?
- AI와 Security 새로운 국면

# Professor Byung Chul Tak (교수님께서 산전수전, 실패를 몸소 직접 다 겪어 보심)
- 절대 포기하지말고 두드릴 것. 그러면 결국 event가 발생함.
- 연구/논문 oriented mind를 처음부터 가질 것. 그런 사람과 아닌 사람은 차이가 발생함.
- 1년에 top-tier 논문 1개씩. 미국 교수직 하려면 1.5개. 그리고 꾸준히 실적이 나오는게 중요함.
    - 첫 해부터.
- 지도교수님 말을 잘 들을 것. 스타일을 빨리 잘 파악해서 잘 적응할 것.
- 지도교수님이 어떤 스타일인지에 상관없이, 주도적으로 active하게 할것. e.g., micro managing or 방목형.
    - 주도적이라는건 내것이라는 생각이 들면 자동으로 되게 됨.
- 첫번째가 연구이고 두번째는 인맥(Networking)이다.
- AI를 잘 쓰는 것이 중요할테지만, AI를 다 쓰면 능력이 퇴화하는 것은 사실임. 따라서 연구자로써 능력을 키워야 함. (처음엔 조금 느리더라도)
- 집의 경우 한곳에 빨리 정착하고 쭉 오래 사는 것이 좋음. 여러 군데 돌아다니고 환경이 바뀔 경우 거기에 쓰이는 에너지를 무시할 수 없음.
- summer intern은 2번만 하는게 좋음. 3번은 많음. 2, 3학년 때. 인턴도 그냥 가서 해야지 라는 마음이 아니라, 이 죽기 살기의 마음가짐으로 해야 함. (팀원들 한테 잘 보여야 함.)
- 죽이 되든 밥이 되든 나는 혼자서라도 연구를 끝까지 한다는 마음이 중요함. 꺾이지 않는 마음. 즉, 남 탓 해서 좋을 게 없다.
    - 슬럼프가 생기면 안됌. (물론 교수님께서는 슬럼프도 있었다고 하셨지만)
- 인도의 경우 남 탓 가로채거나, integrity 없이 하는 애들이 있을 수 있지만, 따라 하면 안됌. 석사 때 한 연구가 맞다고 생각하고, 지도 교수님 잘 따르며 연구를 해 나가야 함.
- 훌륭한 연구, top-tier 학회의 연구란, 테크닉은 둘째. 심지어 좀 구현이 부족하더라도, 그 연구의 가치(value)가 중요함. 얼마나 이 분야에 도움이 되는 일인가. (motivation, 기여도)
    - 다른 분야의 최신 trend/동향을 파악하는 것 중요. 세미나는 있으면 무조건 다 들어라. 다른 분야의 어떤 최신 트렌드를 가져와서 내꺼에 접목해서 하는것은 좋은 방향. (tf-idf도 옛날 기술이라 좀 위험했음.) 한가지만 주구장창 파는 것은 위험함.
- 교수직은 일반 대기업 연구소 연구자보다 훨씬 많은 연구 실적뿐만 아니라, 학계 유명인들과 네트워킹도 필요함!
    - 학회에 매년 가서 적극적으로 인사도 먼저 하고, 얼굴을 인식시켜놔야함. 특히 미국 교수직이나 tenured의 경우 논문 실적만 좋다고 되는게 아님. 그 학계 분야의 거물급이 나를 알고 recognize 해줘야 함.
- 오래 앉아 있는 것과 좋은 연구는 비례하지 않음. 규칙적으로 루틴을 딱 정해놓고, 그때만 하고 운동은 꼭 하는게 좋음. 그리고 주말도 당연히 연구 하셨다고 하심.
- 처음부터 교수직을 노리고 하는것도 좋음. (마음가짐이나 뒷따라 오는 태도, 준비 태도 등을 고려해서 말하신 거겠지.)
- Networking, Reputation 굉장히 중요함. 욱하거나 절대 그런건 보이면 안됌. 무조건 나중에도 기억함. 지도교수는 왕이다. 잘 따라야 함.
- 지금부터 연구를 하고 있어야 함. (연구란 마치 무술을 스승에게 전수 받는것과 비슷하다.)
- 배우자가 있으면 서로 이해하고, 나만 고생한다고 생각하면 안됌. 애기가 있으면 연구시간은 절반 이상 줄어듬. 진짜 효율적으로 해야 함. 여자 혼자 애기를 보는 건 무조건 탈이 남.
- introduction이 중요하다! 그게 어느정도 써지면 실력이 좀 늘고 잇는것. 
- 적을 만들지말 것. 
- AI를 쓸거면 내 후임으로 말고, 지도교수님 처럼 쓸 것.

# 나는 4시간만 일한다.

## 1단계: 접근하기 좋은 틈새시장(분야)을 골라라.

수요를 창출하는 것은 쉬운 일이 아니다. 차라리 수요가 있는 곳(novel area)에 제품을 채워 넣는 것이 훨씬 더 쉽다.
제품(실험)을 개발하고 나서 그것을 팔 사람을 찾지는 마라. 시장을 찾고 나서, 다시 말해 고객을 결정하고 난 다음에 그들을 위한 제품(논문)을 개발해야 한다.

### 시작은 작게, 생각은 크게

수익성 있는 틈새시장을 찾으려면 스스로에게 다음과 같은 질문들을 던져 보라.

1. 치과 의사든 엔지니어든 연구자든 다른 무엇이든 다 좋으니, 당신은 어떤 사회 집단, 산업 집단, 직업 집단에 속해 있거나 속한 적이 있거나 아무튼 그 세계를 이해하는가?

2. 당신이 찾아낸 집단이 그들만의 _잡지_를 가지고 있는가?

## 2단계: 제품을 먼저 브레인스토밍하라

제품의 주요 장점은 한문장으로 요약될 수 있어야 한다.

고객이 지불하는 제품 비용은 (독자가 바꾸거나 받아들여야 할 신념의 정도는) 50달러에서 200달러 사이여야 한다.

생산 기간이 3주에서 4주 이상 걸려서는 안 된다.

온라인 FAQ로 설명이 충분해야 한다. (A paper with appendix should be enough to be reproducible.)

# How to Find Research Problems
https://www.cs.jhu.edu/~jason/advice/how-to-find-research-problems.html

The biological anthropologist Loren Eiseley used to say there were two kinds of scientists: big-bone-hunters and small-bone hunters.

Computer science includes many different kinds of research efforts, some of which are more tyrannosaurical than others. You can contribute to one of these efforts in various ways:
- About the smallest bone that you can find in Computer Science is a reproduction or implementation of someone else's work.
- You can thoroughly review the existing research in some area.
- Build a large program or device of some kind.
- Your field identifies various problems or issues as significant. These often represent big bones in the skeleton of the field -- problems that arise often, and whose solution makes a difference. Get to know some of these problems and the work that's been done on them. If you see how to achieve the first-ever solution, or a better solution, or a different style of solution, that's a big deal. Sometimes finding a good solution involves changing the problem slightly.
- If you are feeling ambitious and have a big-bone temperament, study important papers in your branch of computer science, flip through some conference proceedings to see what people are working on, and ask: What problems (recognized or unrecognized) are obstructing progress in my field? Can I solve them? If not, can I at least formalize them? Can I prove to my colleagues that solving them would make a difference?
- Finally, you can identify new interesting problems. This is often not as hard as it might sound:
    - Study existing (applied) systems and note what they do badly at.
    - If your field is interdisciplinary, ask people in the other discipline what they think is interesting.
    - In many areas, the data have a way of suggesting their own problems. Systems programmers can collect data on actual disk access patterns and study it for regularities to exploit. Theoreticians of programming languages can look at real programming languages, and graphics programmers can look at real photographs and movies, for effects that they don't know how to capture.

__Finally:__ Now that you're in grad school and no one sets your agenda, everything you do is open-ended. That means you can easily spend too much time on any task you start, especially if stubborn perfectionism or an inferiority complex leads you to feel that your work is never good enough, or if you're subconsciously trying to put off that scary next phase of your research.
- Don't spend eternity on background reading. Recognize that you will have to start your work in a state of partial ignorance: you don't have time to learn everything you need to know. That's okay -- your professors do the same thing. In fact it's good, since ignorance leaves your mind free to see new ways of doing things. So start doing your own thinking early. You can alternate that with reading: just show your ideas periodically to someone who can warn you about related work and point you to relevant papers.
- Don't spend eternity on one problem. No solution is ever complete. Take the time to make your work solid and beautiful and presentable, but recognize when you've hit a point of diminishing returns. Use project #1 to inspire project #2, which stands as research on its own. Don't use it as the core of project #1', #1'', etc. forever.


# Write the Paper First (@)
https://www.cs.jhu.edu/~jason/advice/write-the-paper-first.html

If you're planning to submit a conference paper, I'd like to strongly suggest that you __spend the next few days just writing the paper__ (even if you haven't yet planned or finished the experiments).

### Clear writing increases your odds of acceptance.

Clear motivation and exposition are more important than results for getting your paper accepted. If you run out of time, it is better to have a great story with incomplete experiments than a sloppy draft with compelete experiments. A good paper builds its case with the accumulated weight of several experiments, so missing a few is not fatal (and you can finish them for the camera-ready version). But a confusing, unconvincing, or incomplete writeup is fatal.

_"A well-known senior academic told me that they review papers by reading as far as they can understand, then assigning a score based on how far they got."_

### The document is a focus for discussion with others

If you have a paper draft early, then you can give it to other people (including me) for feedback.
Your draft can describe your motivation, formal problem, model, algorithms, and experiments before you actually build anything. (Ideally, it will also explain why you did it this way rather than some other way, and point out gaps that remain for future work.) By showing others the draft at this stage, you'll get important feedback _before_ you invest time in the "wrong" work.

### Writing is a mechanism for planning what to work on

#### Is it a good topic?

#### What needs to be done?

- Your _introductioin_ will make some claims.
- Writing the _literature review_ will help you design your experiments.
    - However, don't write the lit review _first_.
- Writing the _experimental section_ is possible even before you've done the experiments.

### The document is an organizing scheme for your work on the paper

Your first step is to _outline_ the paper. Download the paper template from the conference website. Come up with a good title a good title (and an abstract if you like), and write the section/subsection headers.
**This file will turn into your final documetn.** Everything you do from now on should be focused on improving it!

- The main goal of your experiments is to produce table and grpahs _for the document_. These should be produced and included automatically, with minimal fuss and minimal opportunity for human error.
    - This approach allows you to view and share the current results at any time. For your own understanding, you may want to run many experiments than can be included in the paper. In this case, make a separate "experimental logbook" document that includes and discusses the results of _all_ the experiments. This longer document can also be viewed and shared at any time.

### The document is like a code specification
Writing is a form of thinking and planning. Writing is therefore part of the research process---just as it is part of the software engineering process.

Of course, neither coding nor research is purely top-down---in practice, there's feedback. But crucially, you'll keep the code and the paper in sync.

### Writing _now_ is a favor to yourslef.

You'll feel so much better once you have a draft! The looming deadline will not be nearly so stressful.


# How to Succeed in Graduate School: A Guide for Students and Advisors
https://www.cs.princeton.edu/~jrex/teaching/spring2005/fft/acm_gradschool2.htm

## Networking

One of the most important skills you should be learning in graduate school is how to ``network.``
Going to conferences and standing in the corner is not enough. Especially if you're not normally an outgoing person, you have to make a conscious effort to meet and build relationships with other researchers.

Have summaries of various lengths and levels of detail of your work mentally prepared, so that you can intelligently and clearly answer the inevitable ``So what are you wokring on??``.
If someone expresses an interest in your work, follow up! Send them email talking about new ideas or asking questions; send them drafts of papers; ask them for drafts of their papers and send them comments. (If you do this, they'll be sure to remember you!)

Finding specific mentors can be very useful. Especially if you feel that you are isolated at your institution, having a colleague at another institution who can give you advice, feedback on drafts of papers, and suggestions for research directions can be extremely valuable.

# Write Good Papers
https://lemire.me/blog/rules-to-write-a-good-research-paper/

## What a good paper should contain
- A sexy start: tell the reader early why he should read your paper. Don’t summarize, sell! A good abstract tells us **why we should read this paper**, it does not summarize the paper. Convince us early that your paper is important. For example, the Kent Beck recipe for a good 4-sentence abstract is: (1) state the problem (2) say why it is interesting (3) say what your solution achieves (4) say what follows from your solution.

# How To Be a Good Graduate Student by Deirdre N. McCloskey
https://www.deirdremccloskey.com/docs/pdf/Article_315.pdf

Your job in graduate school, anyway, is to *overstand*; that is, to learn to think critically about pieces of computer science. Of course you still have to understand, to memorize, and to show up on time.
But the biggest source of failure in graduate school is trying to apply the earlier techniques without the new element of criticism.

*Hang out with the best faculty members.* I know I didn't, and regret it deeply.
Hanging out with the best faculty means that *you must do what the faculty suggest.*
The biggest difference between first-rate and second-rate grad students, I've discovered by acquaintance with lots of both kinds, is that the first-rate do what they are told to do by people (called "faculty") who know more than they do, whereas the second-rate are always substituting their necessarily defective judgment for that of their betters.

*Hang out with the best students.* The best students are the ones who are most crazily devoted to talking about computer science, morning, noon, and night.
You are in the land of geeks, not the land of Greeks. Enjoy it and you'll learn a lot more.

# ⭐️⭐️ Whitesides' Group: Writing a Paper by George M. Whitesides
https://intra.ece.ucr.edu/~rlake/Whitesides_writing_res_paper.pdf

## 1. What is a Scientific Paper?
A paper is an organized description of hypotheses, data and conclusions, intended to instruct the reader.
Papers are a central part of research. If your research does not generate papers, it might just as well not have been done. "Interesting and unpublished" is equivalent to "non-existent."

**Realize that your objective in research is to formulate and test hypotheses, to draw conclusions from these tests, and to teach these conclusions to others. Your objective is not to "collect data."**

A paper is not just an archival device for storing a completed research program; it is also a structure for *planning* your research in progress.
If you clearly understand the purpose and form of a paper, it can be immensely useful to you in *organizing* and conducting your research.
A good outline for the paper is also a good plan for the research program. You should write and rewrite these plans/outlines throughout the course of the research.
At the beginning, you will have mostly plan; at the end, mostly outline.
**The continuous effort to understand, analyze, summarize, and reformulate hypotheses on paper will be immensely more efficient for you than a process in which you collect data and only start to organize them when their collection is "complete".**

## 2. Outlines
### 2.1 The Reason for Outlines
I emphasize the central place of an outline in writing papers, preparing seminars, and planning research.
I especially believe that for you, and for me, it is most *efficient* to write papers from outlines.
An *outline* is a written plan of the organization of a paper, *including* data on which it rests.
**You should, in fact, think of an outline as a carefully organized and presented set of data, with attendant objectives, hypotheses, and conclusions, rather than an outline of text.**
An outline itself contains little text. If you and I can agree on the details of the outline (that is, on the data and organization), the supporting text can be assembled fairly easily. If we do *not* agree on the outline, any text is useless.
Much of the *time* in writing a paper goes into the text; most of the *thought* goes into the organization of the data and into the analysis.
It can be relatively efficient in time to go through several (even many) cycles of an outline before beginning to write text; writing many versions of the full text of a paper is slow.

All writing that I do---papers, reports, proposals (and, of course, slides for seminars)---I do from outlines. I urge you to learn how to use them as well.

### 2.2 How Should You Construct an Outline?

The classical approach is to start with a blank piece of paper, and write down, in any order, all important ideas that occur to you concerning the paper.
Ask yourself the obvious questions: "Why did I do this work?"; "What does it mean?"; "What hypotheses did I mean to test?"; "What ones did I actually test?"; "What were the results? Did the work yield a new method of compound? What?"; "What measurements did I make?"; "What compounds? How were they characterized?".
Sketch possible equations, figures, and schemes. It is essential to try to get the major ideas.
If you start the research to test one hypothesis, and decide, when you see what you have, that the data really seem to test some other hypothesis better, don't worry. Write them both down, and pick the best combinations of hypotheses, objectives, and data.
Often the objectives of a paper when it is finished are different from those used to justify starting the work. Much of good science is opportunistic and revisionist.

When you have written down what you can, start with another piece of paper and try to organize the jumble of the first one. Sort all of your ideas into three major heaps (1-3).

*1. Introduction*

Why did I do the work? What were the central motivations and hypotheses?

*2. Results and Discussion*

What were the results? How were compounds made and characterized? What was measured?

*3. Conclusions*

What does it all mean? What hypotheses were proved or disproved? What did I learn? Why does it make a difference?

Next, take each of these sections, and organize it on yet finer scale. Concentrate on organizing the *data*. Construct figures, tables, and schemes to present the data as clearly and compactly as possible.
This process can be slow---I may sketch a figure five to tne times in different ways trying to decide how it is most clear (and looks best aesthetically).

Finally, put everything---outline of sections, tables, sketches of figures, equations---in good order.

When you are satisfied that you have included *all* the data (or that you know what additional data you intend to collect), and have a plausible organization, give the outline to me. Simply indicate where missing data will go, how you think (hypothesize) they will look, and how you will interpret them if you hypothesis is correct. I will take this outline, add my opinions, suggest changes, and return it to you. It usually takes four to five iterations (often with additional experiments) to agree on an outline.
When we *have* agreed, the data are usually in (or close to) final form (that is, the tables, figures, etc., in the outline will be the tables, figures,... in the paper).

**You can then start writing, with some assurance that much of your prose will be used.**

The key to efficient use of your and my time is that we start exchanging outlines and proposals as early in a project as possible.
*Do not, under any circumstances, wait until the collection of data is "complete" before starting to write an outline.*
No project is ever complete, and it saves enormous effort and much time to propose a plausible paper and outline as soon as you see the basic structure of a project. Even if we decide to do significant additional work before seriously organizing a paper, the effort of writing an outline will have helped to guide the research.

### 2.3. The Outline

What an outline should contain:

*1. Title*

*2. Authors*

*3. Abstract*

Do not write an abstract. That can be done when the paper is complete.

*4. Instroduction*

The first paragraph or two should be written out completely. Pay particular attention to the opening sentence. Ideally, it should state concisely the objective of the work, and indicate why this objective is important.
In general, the Introduction should have these elements:
- The *objectives* of the work.
- The *justification* for these objectives: Why is the work important?
- *Background*: Who else has done what? How? What have we done previously.
- *Guidance to the reader*: What should the reader watch for in the paper? What are the interesting high points? What strategy did we use?
- *Summary/conclusion*: What should the reader expect as conclusion? In advanced versions of the outline, you should also include all the sections that will go in the Experimental section (at the level of paragraph subheadings) and indicate what information will go in the Microfilm section.

*5. Results and Discussion*

The results and discussion are usually combined. This section should be organized according to major topics. The separate parts should have subheadings in boldface to make this organization clear, and to help the reader scan through the fiinal text to find the parts of interest.

In the outline, do not write any significant amount of text, but get all the data in their proper place: Any text should simply indicate what will go in that section.
- Section Headings
- Figures (with captioins)
- Schemes (with captions and footnotes)
- Equations
- Tables (correctly formatted)
Remember to think of a paper as a collection of experimental results, summarized as clearly and economically as possible in figures, tables, equations, and schemes.
The text in the paper serves just to explain the data, and is secondary. The more information can be compressed into tables, equations, etc., the shorter and more readable the paper will be.

*6. Conclusions*

In the outline, summarize the conclusions of the paper as a list of a short phrases or sentences.
Do not repeat what is in the Results section, unless special emphasis is needed.
The Conclusions section should be just that, and not a summary.
It should add a new, higher level of analysis, and should indicate explicitly the significance of the work.

*7. Experimental*

Include, in the correct order to correspond to the order in the Results section, all of the paragraph subheadings of the Experimental section.

### 2.4 In Summary

- Start writing possible outlines for papers *early* in a project. Do not wait unil the "end". The ned may never come.
- Organize the outline and the paper around easily assimilated data---tables, equations, figures, schemes---rather than around text.
- Organize in order of importance, not in chronological order. An important detail in writing papers concerns the weight to be given to topics.
Neophytes often organize a paper in terms of chronology: that is, they give a recitation of their experimental program, starting with their cherished initial failures and leading up to a climactic successful finale.
*This approach is completely wrong. Start with the most important results,* and put the secondary results later, if at all.
The reader usually does not care how you arrived at your big results, only what they are. Shorter papers are easier to read than longer ones.

## 3. Some Points of Style

- Do not use nouns as adjectives:
Not:
    ATP formation; reaction product
But:
    formation of ATP; product of the reaction


# The Craft of Research

## PART 4 Writing Your Argument

### 16 Introductions and Conclusions

#### 16.6 Organizing the whole introduction

All this may seem formulaic, but it's what readers expect. And when you master a rhetorical like this, you have more than a formula for writing.
**You also have a tool for thinking.** To write a full statement of your shared context and problem, you have to think hard about what your readers know, what they don't, and, in particular, what they should know and why.
