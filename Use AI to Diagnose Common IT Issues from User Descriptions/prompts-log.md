# Prompts Log - Lab 02

> **Lab:** Lab 02 - Use AI to Diagnose Common IT Issues from User Descriptions
>
> **Platform:** Claude.ai - Sonnet 4.6, Free plan
>
> **Conversation title:** Tier 1 IT support diagnosis framework
>
> **Completed:** May 2026

---

## How to Read This Log

All seven prompts in this lab were sent within the same Claude conversation. The role context established in Prompt 1 persisted across all subsequent case prompts. Each entry contains: the exact prompt sent, a one-line response evaluation, and a quality rating (1-5 for IT support usefulness).

---

## Prompt 1 - Role Context (System Prompt)

**Prompt type:** Role establishment - persona and output format

**Prompt:**
> You are a Tier 1 IT support analyst at a 500-person company. When I describe a user issue, give me a structured diagnosis with: possible causes ranked by likelihood, the three most important questions to ask the user, and the first three troubleshooting steps.

**Claude response:** "Got it! I'm ready to act as your Tier 1 IT support analyst. Go ahead and describe the user issue, and I'll break it down with ranked causes, key questions, and first troubleshooting steps."

**One-line evaluation:** Role and format accepted correctly - the three-part output structure (ranked causes, questions, steps) is explicitly acknowledged and will be applied to all subsequent cases.

**Quality rating:** N/A (context setting, not a diagnostic response)

**Notes:** This prompt is the most important in the session. All five case responses are shaped by this role instruction. The three-part format maps directly to the CompTIA A+ troubleshooting methodology: establish theory (ranked causes), gather information (diagnostic questions), implement the plan (troubleshooting steps). Without this prompt, the same case descriptions would produce generic advice rather than structured analyst-ready output.

---

## Prompt 2 - Case 1: Screen Flickering

**Prompt type:** Hardware/software diagnostic - display issue

**Prompt:**
> My laptop screen keeps flickering and sometimes goes black for a second. It started this morning. I haven't installed anything new.

**Response summary:** Screen Flickering / Intermittent Blackouts. Five ranked causes: loose display cable (1), display driver issue (2), faulty backlight/inverter (3), overheating GPU (4), external interference (5). Three questions: lid angle/movement, overnight Windows Update, external monitor test. Three steps: test external monitor, roll back display driver, check Task Manager during flicker. Escalation flag: flickering worsening rapidly or screen not recovering without reboot.

**One-line evaluation:** Correct cause ranking with physical cable above software, and the external monitor test as the key diagnostic split - immediately actionable on a live support call.

**Quality rating:** 4/5

**Notes:** The external monitor question is the fastest way to split hardware from software faults on a display issue. Asking this first saves the analyst from going through driver steps on a hardware fault, or ordering physical inspection on a driver fault. The "started this morning / haven't installed anything new" context correctly pointed AI to silent Windows Update as the second-ranked cause - even if the user did not initiate an update, background updates can run overnight.

---

## Prompt 3 - Case 2: Login Failure and Lockout Risk

**Prompt type:** Authentication / account management - lockout risk

**Prompt:**
> I can't log into my computer. It says my password is wrong but I haven't changed it. I've tried three times.

**Response summary:** Login Failure / Password Rejected (User Claims No Change). Immediate Priority Note: stop the user from attempting further logins - 3 of 5 attempts used. Six ranked causes: background device with cached password (1), Caps Lock/Num Lock (2), password expired (3), IT security lockout (4), keyboard layout switched (5), local vs domain account (6). Three questions: Caps Lock/Num Lock status, other devices logged in, password expiry warnings received. Three steps: check AD account status, unlock/reset, find and clear lockout source (Event ID 4740). Escalation flag: account active in AD but password still rejected at machine.

**One-line evaluation:** The immediate lockout risk flag (3 of 5 attempts already used) is the most valuable output - it directly prevents the worst-case outcome on this call and demonstrates that the role prompt's company context shaped the response correctly.

**Quality rating:** 5/5

**Notes:** The background device with stale cached password as the top cause is the correct insight that most Tier 1 analysts miss. Users with passwords saved on phones or home computers will re-lock their account within minutes of being unlocked if the offending device is not identified and cleared. The Event ID 4740 / Caller Computer Name reference gives the analyst the exact tool to find that device.

---

## Prompt 4 - Case 3: Printer Faded Stripe

**Prompt type:** Hardware diagnosis - shared printer fault

**Prompt:**
> My printer is printing everything with a faded stripe down the middle of the page. It's the shared printer on floor 3.

**Response summary:** Printer Diagnosis - Faded Vertical Stripe (Floor 3 Shared Printer). Five ranked causes: dirty/damaged drum unit (1), low/uneven toner (2), dirty fuser/transfer belt (3), damaged toner cartridge (4), dirty scanner glass (5). Three questions: fixed vs. shifting position, recent events (paper jam, cartridge change), all users/trays or specific. Three steps: rock the toner cartridge, run printer cleaning cycle, check toner and drum life counters. Escalation trigger: all three steps fail, likely drum replacement needed.

**One-line evaluation:** Correct hardware diagnosis for a laser printer stripe - the toner rocking step as a quick first fix (~40% resolution rate) and the drum life counter check as the second escalation checkpoint are both accurate and practical.

**Quality rating:** 4/5

**Notes:** The diagnostic question about fixed vs. shifting stripe position is the key differentiator in this case. A fixed-position stripe means structural damage (drum, roller). A shifting stripe means distribution issue (toner level, clumping). This single question directs the analyst to the correct repair action before any physical intervention. The multi-user impact of a shared printer was not flagged - this is the one gap in this response.

---

## Prompt 5 - Case 4: Display Resolution and Scaling

**Prompt type:** Software/settings diagnosis - display configuration

**Prompt:**
> Everything on my screen is very small and I can't make it bigger. My colleague says my resolution changed somehow.

**Response summary:** Diagnosis - Display Resolution Too High / UI Elements Too Small. Six ranked causes: accidental resolution change (1), Windows Update reset (2), GPU driver update (3), remote session/KVM (4), monitor swap (5), third-party software (6). Three questions: trigger event before issue, system-wide vs. app-specific, other users or remote session. Three steps: set resolution to Recommended, check display scaling (100% or recommended), update/roll back display driver. Escalation trigger: recommended resolution not available (missing driver) or monitor showing as Generic Monitor.

**One-line evaluation:** The explicit check for display scaling (separate from resolution) is the strongest element - many analysts miss that 75% scale produces the same symptom as wrong resolution even at the correct resolution setting.

**Quality rating:** 5/5

**Notes:** This is the cleanest case in the lab for AI-assisted diagnosis. The issue is a software/settings problem with a self-service fix that the analyst can deliver verbally in under 60 seconds. No physical access, no system access, no Tier 2 involvement. The colleague's observation ("resolution changed somehow") in the user's description correctly directed AI to accidental change as the top cause. Context in the user description improves AI output accuracy.

---

## Prompt 6 - Case 5: Hard Drive Clicking Noise

**Prompt type:** Safety-critical hardware failure - data loss risk

**Prompt:**
> My computer is making a loud clicking noise from inside and it's getting slow.

**Response summary:** Diagnosis - Loud Internal Clicking + Performance Degradation. Priority flag: TREAT AS URGENT. Five ranked causes: HDD failing "click of death" (1), failing cooling fan (2), loose cable/foreign object hitting fan (3), optical drive fault (4), SSD firmware fault (5). Three questions: rhythmic vs. random click and activity correlation, machine age and HDD vs. SSD, backup status. Three steps: back up critical data immediately (FIRST, before diagnosis), check CPU and disk temperatures (HWMonitor, CrystalDiskInfo), run SMART check (wmic diskdrive get status). Escalation trigger: SMART not OK or temperatures critical - escalate immediately.

**One-line evaluation:** The URGENT flag on the first response and backup as Step 1 before any diagnostic tool are both correct - this is the case where AI urgency recognition matters most and Claude got both the diagnosis and the prioritisation right.

**Quality rating:** 5/5

**Notes:** The prioritisation of data backup before SMART check is the most important element of this response. On a potentially failing HDD, running a diagnostic generates write operations that can accelerate sector failure. Securing the data first is correct. The SMART command provided (wmic diskdrive get status) is the fastest first-pass check available from a standard command prompt. This response demonstrates that AI can identify and communicate urgency correctly - but the analyst must act before reading the full response.

---

## Prompt 7 - Case 5 Follow-Up: No Backup Emergency

**Prompt type:** Follow-up chaining - emergency escalation with no backup

**Prompt:**
> The user's data has not been backed up recently. What should I tell them and what should I do immediately?

**Response summary:** Emergency Response - No Recent Backup, Suspected Failing Drive. Critical situation: treat as incident, not ticket. User communication script: calm, honest, specific instructions (stop work, save, close, do not restart). Prohibited actions: do not restart, do not chkdsk, do not install, do not clone without Tier 2. Immediate actions in order: keep machine powered on and idle, identify what needs saving (Desktop/Documents/Downloads/Pictures/Outlook PST path), copy to network share using robocopy command. Tier 2 escalation checklist with specific data points. After data safe: Tier 2 runs full SMART, decides drive replacement vs. hardware swap, arranges loan machine. Documentation requirement: timestamps throughout.

**One-line evaluation:** Complete emergency protocol including a user-facing communication script, prohibited actions with reasons, prioritised backup procedure with robocopy command, and a Tier 2 handoff checklist - the most operationally complete response in the lab.

**Quality rating:** 5/5

**Notes:** The "treat as incident, not a ticket" instruction is the most important output here from an ITSM perspective. An incident bypasses the standard ticket queue and goes directly to escalation. The robocopy command (/E copies subdirectories including empty, /Z restartable mode, /LOG creates a transfer log) is the correct choice for bulk backup on a potentially unstable system. The Outlook PST default path (C:\Users\[username]\AppData\Local\Microsoft\Outlook) is the detail that prevents the most commonly missed backup item. The timestamp documentation requirement protects both the analyst and the user if data is ultimately lost.

---

## Cross-Case Analysis

### Most Useful Cases for AI-Assisted Diagnosis

**Case 2 (Login lockout)** and **Case 4 (Display resolution)** produced the highest immediate value for handle time reduction. Both cases have software/settings causes that AI can diagnose accurately, solutions that can be delivered verbally over the phone, and no physical access requirement. These two cases represent the highest AI return-on-investment on a standard service desk call.

### Most Important Case for Understanding AI Limitations

**Case 5 (HDD clicking)** is the critical case. AI produced the correct output - URGENT flag, correct diagnosis, backup before diagnosis, complete emergency protocol. But:
- The analyst must recognise the pattern before the AI output loads
- The analyst must make real-time judgements about machine stability, network access, user communication, and escalation timing
- The analyst must understand *why* each prohibited action is prohibited, not just follow the list

An analyst who uses AI on this case without the underlying knowledge is less effective than an analyst who knows the HDD failure pattern instinctively. AI amplifies existing knowledge; it does not substitute for it.

### Pattern Observed Across All Five Cases

The AI output quality was directly proportional to the specificity of the user's description. Cases with more context in the complaint (Case 2: "I've tried three times", Case 4: "my colleague says my resolution changed") produced more targeted responses than cases with minimal context (Case 5: seven words). The user's complaint is the AI's data input. More specific complaints produce more targeted diagnosis.
