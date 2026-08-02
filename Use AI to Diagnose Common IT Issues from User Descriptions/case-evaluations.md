# Case Evaluations - Lab 02

> **Lab:** Lab 02 - Use AI to Diagnose Common IT Issues from User Descriptions
>
> **Platform:** Claude.ai - Sonnet 4.6
>
> **Evaluation framework:** CompTIA A+ troubleshooting methodology
>
> **Completed:** May 2026

---

## Case Evaluation Summary Table

| Case | Issue Type | Complaint (plain language) | AI Accuracy Rating | Strongest AI Output | Missing or Limited Element | Analyst Override Required |
|---|---|---|---|---|---|---|
| **1** | Screen flickering / intermittent blackouts | "My laptop screen keeps flickering and sometimes goes black for a second. It started this morning. I haven't installed anything new." | High (4/5) | External monitor as diagnostic splitter between hardware and software | Cannot physically inspect hinge or cable | No for diagnosis. Yes if physical cable inspection needed. |
| **2** | Login failure / account lockout risk | "I can't log into my computer. It says my password is wrong but I haven't changed it. I've tried three times." | Very High (5/5) | Immediate lockout risk flag. Background device as hidden lockout source. AD check sequence. | Cannot access AD directly - analyst must check | No - analyst must act in AD immediately but AI framework is complete |
| **3** | Printer hardware fault - faded vertical stripe | "My printer is printing everything with a faded stripe down the middle of the page. It's the shared printer on floor 3." | High (4/5) | Correct five-cause ranked list. Rock-the-toner as quick first step (~40% fix rate). Drum life counter check. | Cannot access the shared printer physically or its admin console | Yes - physical access to printer required for all three steps |
| **4** | Display resolution and scaling | "Everything on my screen is very small and I can't make it bigger. My colleague says my resolution changed somehow." | Very High (5/5) | Identified scaling as a separate check from resolution. Both must be verified. Steps verbally deliverable. | None significant | No - fully resolvable over the phone |
| **5** | Hard drive failure / data loss risk | "My computer is making a loud clicking noise from inside and it's getting slow." | Very High (5/5) | URGENT flag on first response. Data backup as Step 1 before diagnostics. Complete emergency protocol on follow-up with robocopy command, prohibited actions list, escalation handoff checklist. | Cannot assess machine age, physical state, user distress, network share availability in real time | YES - human must lead immediately. AI is the checklist, not the decision maker. |

**Accuracy rating scale:** 1 (poor - generic, inaccurate) to 5 (excellent - specific, accurate, immediately actionable)

---

## Case 1 - Detailed Evaluation: Screen Flickering

**User complaint:** "My laptop screen keeps flickering and sometimes goes black for a second. It started this morning. I haven't installed anything new."

**AI accuracy rating:** 4/5 - High

### What the AI Got Right

The ranking of causes was correct. Loose display cable is the most common cause of screen flickering on a laptop that is moved daily - the hinge repeatedly flexes the internal cable over its lifespan. Placing display driver issue second is correct because silent Windows Updates can destabilise GPU drivers even without user action.

The external monitor test as the third diagnostic question is the single most efficient diagnostic step for this complaint. It immediately splits the fault tree: if the external monitor is stable, the problem is isolated to the internal panel, cable, or backlight. If it flickers too, the GPU or driver is the source. This question eliminates half the possible causes in one step.

The escalation flag (flickering worsens rapidly or screen does not recover without reboot) is appropriate - these are the indicators that physical cable failure is imminent.

### What the AI Did Not Cover

AI cannot assess the angle at which the flickering occurs. If the flickering only happens when the lid is at a specific angle, that is diagnostic evidence of a cable or hinge issue that the analyst would observe visually. The AI correctly included this as a question to ask the user, but the interpretation of the answer requires the analyst.

### CompTIA A+ Framework Alignment

The AI output aligns with: Identify the problem (flickering, blackouts, recent onset), Establish a theory (cable, driver, hardware), Test the theory (external monitor), Implement the solution (roll back driver or escalate for physical inspection). The framework is followed correctly.

### Analyst Override Decision

No override required for the diagnostic framework. Override required for: physical inspection of hinge and cable, driver rollback if the AI step sequence does not resolve the issue, escalation to Tier 2 for hardware replacement.

---

## Case 2 - Detailed Evaluation: Login Failure and Account Lockout

**User complaint:** "I can't log into my computer. It says my password is wrong but I haven't changed it. I've tried three times."

**AI accuracy rating:** 5/5 - Very High

### What the AI Got Right

The Immediate Priority Note is the most valuable output in this case. "Stop the user from attempting further logins. Many environments lock the account after 5 failed attempts, and they've already used 3." This is the correct first response and it was the first thing Claude produced. A junior analyst who reads this before any other step will prevent a full lockout on this call.

The cause ranking is correct. Background device with cached stale password is the most important cause because it is the most common source of repeated lockouts that re-occur shortly after the account is unlocked. Caps Lock is second because it is the fastest to check and the most embarrassingly common resolution.

The AD check sequence is correct: check the account status before touching the machine, then unlock or reset, then find and clear the lockout source. The Event ID 4740 and Caller Computer Name reference is a Tier 2-level detail that is appropriately included as the third step - it prevents re-lockout.

### What the AI Did Not Cover

The AI did not explicitly address the possibility that the password rejection might indicate a compromised account rather than a forgotten or locked one. If the user has no explanation for why the password might have changed and there is no lockout showing in AD, this should trigger a security review. The AI would have covered this if asked as a follow-up, but the initial response focuses on the standard technical diagnosis.

### CompTIA A+ Framework Alignment

Correct. Identify the problem (password rejected, 3 attempts, no known change), establish theory (lockout, Caps Lock, expiry, background device), test theory (check AD account status), implement solution (unlock + identify lockout source).

### Analyst Override Decision

No override required for the diagnostic framework. The analyst must execute the AD check directly - AI cannot access AD. If the account appears active and unlocked in AD but the password is still rejected, the analyst must escalate to Tier 2 (cached credentials conflict or domain controller connectivity).

---

## Case 3 - Detailed Evaluation: Printer Faded Stripe

**User complaint:** "My printer is printing everything with a faded stripe down the middle of the page. It's the shared printer on floor 3."

**AI accuracy rating:** 4/5 - High

### What the AI Got Right

The five-cause ranked list is mechanically accurate for a laser printer. Dirty or damaged drum unit as the top cause for a fixed-position vertical stripe is correct - a scratch or deposit on the drum produces a consistent mark at the same position on every page. The toner rocking step as the first troubleshooting action is accurate and resolves approximately 40% of toner stripe issues without any tools or parts. The drum life counter check as the third step is appropriate - it determines whether the issue requires a consumable replacement.

The diagnostic question about fixed vs. shifting stripe is the key differentiator. A fixed position means drum or roller damage. A shifting stripe means toner distribution is uneven. This question directs the analyst to the correct part before any physical intervention.

### What the AI Did Not Cover

The response did not address the multi-user impact of a shared printer issue. A floor 3 shared printer affecting multiple users is a higher-priority issue than a personal printer fault. The analyst should check whether other users on floor 3 are affected before beginning diagnosis - if all users on the floor are affected, this is a shared infrastructure issue that may need faster escalation.

### CompTIA A+ Framework Alignment

Correct for hardware fault diagnosis. The toner rock step (test the quick fix before deeper investigation) aligns with the CompTIA approach of testing the most likely fix before escalating.

### Analyst Override Decision

Yes - physical access to the printer is required for all three troubleshooting steps. The AI provides the correct procedure but the analyst or a designated on-site technician must execute it. Remote resolution is not possible for this case.

---

## Case 4 - Detailed Evaluation: Display Resolution Too Small

**User complaint:** "Everything on my screen is very small and I can't make it bigger. My colleague says my resolution changed somehow."

**AI accuracy rating:** 5/5 - Very High

### What the AI Got Right

The identification of display scaling as a separate variable from resolution is the most valuable element of this response. Many analysts check resolution, confirm it is set to the recommended value, and close the case - missing that the scale setting at 75% or below produces the same symptom even at the correct resolution. The AI checked both in the response, which is correct.

The first troubleshooting step - right-click desktop, Display Settings, select (Recommended) - is a complete, self-service instruction that the analyst can deliver verbally and the user can execute in under 60 seconds. This case is fully resolvable over the phone using AI-generated steps, making it the strongest example of AI reducing handle time with no analyst intervention required beyond instruction delivery.

The diagnostic question about whether the issue is system-wide or application-specific is valuable - if only specific applications appear small, the issue is per-app DPI compatibility (a different fix) rather than system display settings.

### What the AI Did Not Cover

Nothing significant. This case has a clearly defined and easily actionable resolution path.

### CompTIA A+ Framework Alignment

Correct. The recommended resolution step is the immediate fix; the driver check is the underlying cause investigation if the fix does not hold.

### Analyst Override Decision

No - this case is fully resolvable over the phone using AI-generated steps. No physical inspection, no system access, no Tier 2 escalation unless the recommended resolution is missing from the dropdown (indicating a missing driver).

---

## Case 5 - Detailed Evaluation: Hard Drive Clicking Noise and Emergency Response

**User complaint (initial):** "My computer is making a loud clicking noise from inside and it's getting slow."

**Follow-up prompt:** "The user's data has not been backed up recently. What should I tell them and what should I do immediately?"

**AI accuracy rating:** 5/5 - Very High

**Combined evaluation covers both the initial response and the follow-up.**

### What the AI Got Right - Initial Response

The URGENT flag is correct and was the first output produced. "Clicking + slowness together is a classic hard drive failure signature. Data loss risk is real. Act quickly." This matches the level of urgency a trained analyst would communicate.

Making data backup the first troubleshooting step - before any diagnostic tool is run - is the correct prioritisation. On a potentially failing HDD, every write operation increases the risk of sector failure. Running a diagnostic before securing the data puts diagnostic certainty ahead of data preservation. The AI got this order right.

The SMART check command (wmic diskdrive get status) is the correct first diagnostic tool - it provides a go/no-go assessment in one command. CrystalDiskInfo for detailed SMART analysis is the appropriate follow-up.

The three diagnostic questions are precisely targeted: rhythmic vs. random click (HDD vs. fan), machine age and HDD vs. SSD (mechanical vs. solid-state, urgency calibration), backup status (data loss exposure before doing anything else). These questions are sequenced to establish urgency before establishing cause.

### What the AI Got Right - Follow-Up Response

The instruction to treat this as an incident rather than a ticket is a precise ITSM categorisation call that most junior analysts would not make instinctively.

The prohibited actions list is the most important element: do not restart, do not run chkdsk, do not install anything, do not clone without Tier 2. Each item has a specific technical reason - write operations on a failing HDD accelerate sector damage. An analyst who follows these prohibitions without understanding them will be safer than one who knows them but overrides them for convenience.

The robocopy command for backup is appropriate - it handles large file sets, logs errors, and uses restartable mode (/Z) which resumes partial copies after interruption.

The Tier 2 escalation handoff checklist (machine name, asset tag, user details, SMART status, what has and hasn't been copied, symptom duration) is complete and prevents the information gaps that slow Tier 2 response.

### Why Human Judgment Cannot Be Delegated on This Case

The AI produced the correct guidance in full. The human judgment gap exists in the following areas:

**Timing:** The analyst must decide to stop the user from continuing to use the machine immediately - ideally before the AI response has finished loading. A new analyst who waits to read the full response before taking action has introduced a 10-30 second delay that could correspond to a critical sector failure on an actively deteriorating drive.

**Communication tone and user management:** The AI provided a communication script. Delivering that script to a distressed user who has not backed up three years of project files requires the analyst to read the user's emotional state and adapt the communication in real time. The script is a starting point; the conversation is human.

**Environmental assessment:** The AI cannot know whether the network share is accessible from the failing machine, whether a USB drive is available if the network share is not, whether the Outlook PST path is correct for this user's configuration, or whether the user's critical files are actually in the standard locations. These require the analyst's real-time operational awareness.

**Escalation decision timing:** The AI says "Escalate to Tier 2 Now." The analyst must judge whether to escalate before starting the backup (if Tier 2 is immediately available and the drive condition is critical) or after starting the backup (if Tier 2 has a 30-minute response time and the analyst can begin the robocopy immediately). This judgement requires knowing the organisation's Tier 2 availability and the drive's current level of stability.

### CompTIA A+ Framework Alignment

The AI output aligns with and extends the CompTIA framework. "Back up data before troubleshooting" is a CompTIA A+ first principle. The SMART check aligns with "establish theory and test." The escalation trigger aligns with "escalate as needed." The documentation requirement aligns with "document findings."

### Analyst Override Decision

YES - this is the most important override in the lab. The analyst must:
1. Recognise the pattern immediately (before AI output loads)
2. Interrupt the user immediately with the instruction to stop and not restart
3. Execute the backup using the AI guidance as a checklist
4. Make the escalation timing judgement based on drive stability and Tier 2 availability
5. Document the timeline in the ticket

AI provides the complete framework for steps 3 and 5. Steps 1, 2, and 4 require the human analyst.

---

## Rating Summary

| Case | Rating | Primary Reason |
|---|---|---|
| Case 1 - Screen flickering | 4/5 | Correct cause ranking and split-test question. Physical inspection not possible. |
| Case 2 - Login lockout | 5/5 | Lockout risk flagged immediately. AD sequence correct. Background device cause identified. |
| Case 3 - Printer stripe | 4/5 | Correct hardware diagnosis. Physical access required for all steps. Multi-user impact not flagged. |
| Case 4 - Display resolution | 5/5 | Scaling and resolution both checked. Fully resolvable over the phone. No gaps identified. |
| Case 5 - HDD clicking | 5/5 | URGENT flag correct. Backup before diagnosis correct. Complete emergency protocol on follow-up. |

**Overall AI accuracy across five cases:** High to Very High for all cases. The AI framework was correct on every case. The limitation in each case was operational (physical access, AD access, real-time user management) rather than diagnostic.
