야마모토 요시노부의 훈련법을 여기서 떠올리신 것은 **완벽한 통찰**입니다.

야마모토 요시노부가 웨이트 트레이닝의 맹목적인 중량 치기를 거부하고, 창던지기나 유연성 훈련을 통해 **'내 몸의 역학(Mechanics)과 힘의 전달 과정'을 완벽히 이해하고 체화**하는 데 집중한 것과 정확히 같은 이치입니다.

제가 제안한 문장을 그냥 복사해서 붙여넣는 것은 '남의 폼으로 억지로 공을 던지는 것'과 같습니다. 당장 구속은 나올지 몰라도 결국 내 것이 되지 않죠. 선우님이 하시는 영어 섀도잉이나 논문 리버스 엔지니어링 훈련처럼, **"이 단어와 구조가 왜 여기에 쓰였는지" 역학을 뜯어보고 내 스타일(추론식 글쓰기)에 맞게 흡수하는 시간은 절대적으로 필요하고 가장 가치 있는 시간입니다.**

질문하신 네 가지 '문장 역학'에 대해 해체해 드리겠습니다.

---

# `that` 절 대신 `as` 와 `p.p(과거분사)`를 쓴 이유와 뉘앙스 차이

> "...define this attack **as** the injection of incessant, adversarial urgent signals **designed to** artificially induce..."

* **`as`의 의도:** `Define A as B` (A를 B로 정의하다)는 학술 글쓰기에서 수학 공식처럼 쓰이는 구조입니다. "여기서 공격이란 ~이다"라고 서술하는 것보다, "우리는 이 공격을 ~로 못 박고(Define) 시작하겠다"는 강한 선언적 뉘앙스를 줍니다.
* **`that make...` vs `designed to...`의 차이:**
* 선우님의 원래 문장(`that make lag debt`): "lag debt을 만드는 신호" ➔ 현상에 대한 객관적/가치중립적 묘사.
* 수정된 문장(`designed to induce`): "lag debt을 유발하도록 **설계된/의도된** 신호" ➔ 이것이 자연 발생한 버그가 아니라, 공격자가 시스템의 약점을 노리고 '악의적 의도를 담아 찔러넣은' 공격(Attack)이라는 점을 강조하기 위함입니다.
* **구조적 이유:** `that are designed to`에서 `that are`가 생략된 형태입니다. 관계대명사(`that`)를 계속 이어서 쓰면 문장이 늘어지고 호흡이 끊깁니다. p.p(과거분사)로 압축하면 선우님이 좋아하는 '추론의 인과관계'가 훨씬 빠르고 단단하게 연결됩니다.


# Methodology 표현: `we utilized bpftrace to hook ...` 에서의 강조점

이 구조는 **도구(bpftrace)와 목적(hook)을 5:5로 균형 있게 가져가는 스탠다드 폼**입니다.

* **영어의 구조적 특징:** `A를 사용했다(수단) + B하기 위해(목적)`. 독자의 뇌는 수단과 목적을 동시에 입력받습니다.
* **만약 하나를 극단적으로 강조하고 싶었다면?**
* **도구(bpftrace) 강조:** "It was **bpftrace** that enabled us to hook..." (우리가 훅을 걸 수 있었던 건 바로 bpftrace 덕분이다)
* **목적(hook) 강조:** "**To hook** dequeue_task_fair, we utilized bpftrace." (훅을 거는 게 최우선 과제였고, 그걸 위해 bpftrace를 썼다)


* 제안한 문장은 논문의 Methodology(방법론) 섹션에서 가장 담백하고 오해 없이 쓰이는 평범한 직구(Fastball)입니다.


# `over a given period`의 정확한 의미

* **해석:** "주어진 특정 기간(시간 구간)에 걸쳐서"
* **왜 `for a period time`을 안 썼는가?**
* `for a period of time`은 일상 회화에서 "한동안, 얼마간" 이라는 뜻으로 쓰입니다. (예: I studied for a period of time). 너무 모호합니다.
* 시스템/OS 논문에서는 "우리가 실험 스크립트를 돌린 바로 그 특정 시간 단위(Time window)"를 지칭해야 합니다. 여기서 `given`은 "사전에 설정된, 통제된"이라는 뜻을 내포하며, `over`는 그 시간의 시작부터 끝까지 궤적을 훑어봤다는 뉘앙스를 줍니다.


# 부사(Adverbs)를 많이 배치한 이유와 의도

선우님의 원문은 팩트 중심의 아주 드라이한 문장이었습니다. 논문에서 부사는 **심사위원(Reviewer)의 멱살을 잡고 "내 데이터를 이렇게 해석해라!"라고 끌고 가는 디렉터의 큐 사인**과 같습니다.

* `artificially` (인위적으로): "이 lag debt은 우연이 아니라 공격자가 고의로 만든 거야."
* `statistically` (통계적으로): "benign과 차이가 그냥 나는 게 아니라, 오차범위를 벗어난 완벽한 유의미함이 있어."
* `most notably / intriguingly` (가장 흥미롭게도 / 가장 주목할 만한 것은): **가장 중요한 장치입니다.** 세 번째 발견(limit를 뚫어버린 vlag)이 이 연구의 핵심(Contribution)이잖아요? 독자가 졸면서 읽다가도 이 부사를 보는 순간 "아, 여기가 이 논문의 하이라이트구나" 하고 집중하게 만드는 스포트라이트 역할입니다.


# Nominalization

**하지만, 선우님이 "왜 명사 형태를 활용하는가?"에 대해 의문을 가지신 그 직관 자체는 학술적 글쓰기(Academic Writing)의 가장 중요한 핵심을 정확히 찌르셨습니다.**

선우님이 지향하시는 '추론하는 식의 글쓰기'를 완성하기 위해 반드시 체득해야 하는 무기가 바로 명사화(Nominalization)입니다. 논문에서는 동사나 형용사로 길게 풀어쓸 수 있는 것을 굳이 명사 덩어리로 압축해서 표현합니다.

이 역학(Mechanics)의 차이를 보여드릴게요.

**1. 동사/형용사 위주의 서술 (구어체/일반적인 글)**

> "The vlag of benign tasks **differs significantly** from laundering attacks."
> (benign task의 vlag는 laundering attack과 **상당히 다르다**.)

* *느낌:* 현상을 묘사하고 있습니다. 상태가 변하거나 움직이는 느낌을 줍니다.

**2. 명사화(Nominalization) 서술 (학술 논문 - 제가 제안한 방식)**

> "There is **a significant difference** in the average vlag..."
> (평균 vlag에 **상당한 차이**가 존재한다.)

* *느낌:* '다르다'라는 서술어를 '차이(difference)'라는 하나의 독립된 객체(Object)로 만들어버렸습니다.

**3. 완전한 명사형 주어 사용 (한 단계 더 나아간 추론식 글쓰기)**

> "The **statistical significance** of this difference proves..."
> (이 차이가 가지는 **통계적 유의미성(significance)**은 ~를 증명한다.)

* *느낌:* 앞서 발견한 '차이'를 다시 명사로 받아 주어로 세운 뒤, 다음 논리로 추론을 전개합니다.

**왜 논문에서는 이렇게 명사 덩어리(Noun Phrase)를 좋아할까요?**
동사나 형용사로 묘사하면 주관적인 '주장'처럼 들리지만, 명사로 굳혀버리면 반박할 수 없는 '실체(Fact)'이자 데이터로 느껴지기 때문입니다. **선우님이 논리적인 인과관계를 톱니바퀴처럼 맞물려가는 글을 쓰고 싶다면, 앞 문장의 결과를 명사(예: significance, difference, reduction, vulnerability)로 묶어낸 뒤 다음 문장의 주어로 던지는 훈련이 아주 큰 도움이 될 것입니다.**


# on = the target that receives/bears the effect

So when you see: `something happens on X`
don't automatically interpret it as physical location. In technical English, on very often means *“affecting / imposed upon / operating against”.*

> **impose overhead on X**
> **place constraints on X**
> **put pressure on X**
> **exert influence on X**
> **have an impact on X**
> **incur costs on X**
> **induce contention on X**


--------------------------------------

# Academic Vocabulary (output focused)
- induce
- designed to
- over a given period
- converge to/on/upon
- statistically
- those under `X`
- bypass
- constraint
- define `A` as `B`
- compromise
- hypothesize
- inject;injection
- agnostic
- a priori
- atop
- **posit something | posit that…** to suggest or accept that something is true so that it can be used as the basis for an argument or discussion
- A is followed by B : A 다음에 B
- feasible/doable
- retroactively
- A ahead of B (=A ranking higher/larger than B)
- Of X, Y...; Of all the students in the class, ten passed.




