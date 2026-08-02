# Prompts Log - Lab 01

> **Lab:** Lab 01 - Set Up AI Tools for IT Support and Write Your First Prompt
>
> **Platforms tested:** Claude.ai (Sonnet 4.6) and ChatGPT (Free plan)
>
> **Completed:** May 2026

---

## How to Read This Log

Each entry contains:
- **Platform** - which AI tool was used
- **Prompt type** - the prompting technique demonstrated
- **Prompt** - the exact text sent
- **One-line evaluation** - immediate verdict on response quality for IT support use
- **Response quality rating** - 1 (poor) to 5 (excellent) for IT support usefulness

Ratings are based on four criteria: specificity, accuracy, actionability, and format (scannable during a live call without needing to re-read).

---

## Prompt 1 - VPN Error 429 Diagnostic

**Platform:** ChatGPT (Free)

**Prompt type:** Structured diagnostic with error code and OS context

**Prompt:**
> A user on Windows 11 reports they cannot connect to the company VPN. Error code 429. What are the most likely causes and what first-line steps should I take?

**Full ChatGPT Response Summary:**

ChatGPT interpreted error 429 as "A remote computer could not be reached" - the Windows built-in VPN RRAS error meaning. Identified six most likely causes: no internet connectivity, wrong VPN server address or DNS failure, VPN server down or unreachable, local firewall or antivirus interference, VPN service or client issue on the PC, and incorrect VPN type or protocol mismatch. Provided seven numbered first-line troubleshooting steps with specific commands (ping, nslookup, ipconfig /all, tracert, Get-Service RemoteAccess) and a suggested ticket summary for documentation.

**One-line evaluation:** Thorough, Windows-specific, immediately usable with copy-ready commands - correctly frames 429 as a reachability problem in the Windows built-in VPN client context.

**Response quality rating:** 5/5

**Notes:** ChatGPT's interpretation (reachability, RRAS error) is correct for the Windows built-in VPN client. The response would be the right starting point if the organisation uses the Windows VPN adapter directly. The commands provided (ipconfig /all, tracert, Get-Service RemoteAccess) are all copy-pasteable into a support call workflow.

---

**Platform:** Claude (Sonnet 4.6)

**Prompt type:** Structured diagnostic with error code and OS context

**Prompt:**
> A user on Windows 11 reports they cannot connect to the company VPN. Error code 429. What are the most likely causes and what first-line steps should I take?

**Full Claude Response Summary:**

Claude interpreted error 429 as "Too Many Requests" - the HTTP-style rate-limiting or throttling response from a VPN gateway (Cisco ASA, Palo Alto GlobalProtect, Fortinet, etc.). Categorised causes into three tiers: Server-side (gateway overwhelmed, account hit connection attempt limit, stuck orphaned session), Client-side (crash loop hammering server, corrupted credentials/cached tokens, expired certificates), and Network/infrastructure (proxy returning 429, split tunneling misconfiguration, ISP throttling). Provided seven first-line steps starting with "Stop and wait 2-5 minutes" (rate-limiting specific), then server status check, clearing stuck sessions, resetting the VPN client, credentials/MFA check, log review, and network isolation test.

**One-line evaluation:** Correctly identifies the rate-limiting interpretation for modern VPN gateways, provides a three-tier cause framework that maps directly to the escalation path, and uniquely recommends waiting before retrying to avoid worsening rate-limiting.

**Response quality rating:** 5/5

**Notes:** Claude's interpretation is correct for third-party VPN clients (Cisco AnyConnect, GlobalProtect, Fortinet FortiClient). The "stop and wait" first step is a critical insight that ChatGPT's response did not include - continued connection attempts during active rate-limiting extend the lockout period. Both responses are correct; the right one depends on which VPN client the organisation uses.

**Cross-platform comparison note:** The two different interpretations of the same error code highlight a key AI limitation - without knowing the specific VPN client, the AI applies its training's most common interpretation. In a real support scenario, the first question to the user should be "what VPN client software are you using?" to determine which interpretation applies.

---

## Prompt 2 - Follow-Up Chaining - Escalation Path

**Platform:** Claude (Sonnet 4.6)

**Prompt type:** Follow-up chaining - context retention test

**Prompt:**
> Assume the VPN client was uninstalled and reinstalled and the issue persists. What is the next escalation path?

**Sent as:** A follow-up in the same conversation as Prompt 1 (no new chat, no context repetition)

**Full Response Summary:**

Claude carried forward the VPN error 429 context and the reinstall information, then produced a four-step structured escalation path:

Step 1 - VPN/Network Admin (Tier 2): Check gateway health (active session count vs. licensed seat limit, CPU/memory load on VPN concentrator), user-specific gateway state (force-terminate sessions tied to the username, ghost sessions survive reinstalls), and licensing (concurrent user limits).

Step 2 - Identity and Access / IAM Team: Active Directory/LDAP account lockout, RADIUS/TACACS+ auth server logs, SAML/SSO/OAuth provider (Okta, Entra ID, Duo) - flagged account, de-synced MFA, token expiry, conditional access policy.

Step 3 - Network/Firewall Team: Perimeter firewall or proxy returning 429 before request reaches VPN gateway, user IP or subnet blacklisted at the edge, packet capture on the gateway interface.

Step 4 - Endpoint/Security Team: MDM compliance posture (Intune, Jamf), certificate store (certmgr.msc), host-based firewall/EDR (Defender, CrowdStrike), and Windows 11 built-in VPN settings for conflicting entries.

Also provided an escalation summary table and a list of information to bring to each team handoff.

**One-line evaluation:** Four-step structured escalation path with team-specific checks, produced without any context re-entry - the context retention is seamless and the output is complete enough to copy directly into a P2 incident ticket.

**Response quality rating:** 5/5

**Notes:** The ghost session point (Step 1) is a critical insight: "ghost sessions survive reinstalls." This means a client reinstall on the user's machine does not clear orphaned sessions registered on the VPN gateway. This is the most common reason a reinstall does not resolve a 429 error - and it requires VPN admin access to clear. This is the kind of nuanced infrastructure knowledge that would take a junior technician significantly longer to find via a search engine.

---

## Prompt 3 - Role Prompting - Outlook Diagnostic Questions

**Platform:** Claude (Sonnet 4.6)

**Prompt type:** Role prompting - persona instruction shaping response format

**Prompt:**
> You are a Tier 1 IT support analyst. A user says their Outlook is not loading after a Windows update. Give me three diagnostic questions I should ask the user before I begin troubleshooting.

**Full Response Summary:**

Q1: "What exactly happens when you open Outlook - do you see an error message, does it freeze on the loading screen, or does it crash immediately?" Rationale: narrows down whether the issue is profile corruption, add-in conflict, or deeper application failure, and identifies where in the launch sequence the problem occurs.

Q2: "Did the issue start immediately after the update, or did Outlook work at least once before stopping?" Rationale: if never worked post-update, likely a compatibility break or botched update. If worked briefly then stopped, likely corrupted cache or background post-update process. Critical for scoping the cause.

Q3: "Have you tried restarting your computer since the update completed, and are you seeing any issues with other Office apps like Word or Teams?" Rationale: unrestarted machine after Windows update is one of the most commonly overlooked causes; knowing whether problem is Outlook-specific or whole-Office-suite tells you whether to focus on Outlook profile/config or the Office installation as a whole.

**One-line evaluation:** Three precisely targeted diagnostic questions with full rationale for each, shaped by the Tier 1 role instruction to avoid both under-asking and over-asking - immediately usable as a call script.

**Response quality rating:** 5/5

**Notes:** The role instruction ("You are a Tier 1 IT support analyst") prevented the AI from jumping to troubleshooting steps before the diagnostic questions, which is the most common mistake new analysts make. Without the role instruction, the same prompt would likely produce a list of things to try rather than questions to ask the user first. The three-question format also respects the user experience - three questions before beginning troubleshooting is enough to scope the problem without exhausting the caller.

---

## Prompt 4 - Negative Scope - Printing Anti-Patterns

**Platform:** Claude (Sonnet 4.6)

**Prompt type:** Negative scope - asking what to avoid rather than what to do

**Prompt:**
> What should I NOT ask a user when they report a printing issue?

**Full Response Summary:**

Three categories of questions to avoid:

**Questions That Waste Time or Damage Trust:**
- Don't ask things the ticket already tells you: "What's your name?" / "What department are you in?" - if it's in the system, look it up. Asking signals you haven't read their ticket.
- Don't ask overly technical questions without context: "What's the printer's IPv4 address?" - most users don't know and it burdens them with information you can pull from your systems.
- Don't ask vague, unhelpful questions: "Have you tried fixing it?" / "Is it broken?" - adds nothing and frustrates users who feel stuck.

**Questions That Make the User Feel Blamed:**
- "Did you do something different today?" - implies fault before investigating anything.
- "Are you sure you're using it correctly?" - condescending, almost never the right opener.
- "Did you spill anything on it?" - puts user on the defensive without physical cause to suspect damage.

**Questions You Should Already Be Able to Answer Yourself:**
- "What operating system are you on?" - check the device record.
- "What printer model is it?" - check the asset register.
- "Is the printer on?" - lead with this as a check statement, not a question implying they might be unaware.

**Underlying rule surfaced:** Don't ask a question if you can look it up, if the answer is obvious, or if asking it makes the user feel stupid or suspected.

**One-line evaluation:** Produces a practical anti-pattern checklist that is more immediately useful for new analyst onboarding than a best-practice list - directly prevents the specific mistakes that erode user trust in the first 60 seconds of a call.

**Response quality rating:** 5/5

**Notes:** This is the most underused prompting technique in IT support contexts. Negative scope prompts produce output that can be used directly in peer coaching, onboarding documentation, and quality assurance reviews. The underlying rule at the end of the response is a principle worth memorising and posting in the team area.

---

## Prompt 5 - ITSM Conceptual - Incident vs Service Request

**Platform:** Claude (Sonnet 4.6)

**Prompt type:** Conceptual knowledge query with cross-reference to ServiceNow/Jira knowledge

**Prompt:**
> What is the difference between an Incident and a Service Request in ITSM?

**Full Response Summary:**

**Incident:** An unplanned interruption to a service or reduction in service quality. Something that was working is now broken. Goal: restoration - get the user back to working as fast as possible. Speed matters more than perfection.

**Service Request:** A formal request for something new - a standard, pre-approved action that is a normal part of service delivery. Nothing is broken. Goal: fulfillment - delivering something the user needs, following a defined, repeatable process.

**Side-by-side comparison table:** Trigger (something broke vs. something is needed), Nature (unplanned/disruptive vs. planned/routine), Goal (restore service vs. fulfill request), Priority driver (business impact and urgency vs. SLA agreement and queue order), Process (Incident Management vs. Request Fulfillment), Example (VPN is down vs. new user account setup), Tone (reactive vs. proactive).

**Why the distinction matters:** Metrics tracked differently (MTTR vs. fulfillment time/first-time completion rate), priority assigned differently (urgency/impact triage vs. queue and lead time), SLAs differ (broken system in 1 hour vs. software install in 2 business days), communication tone differs (empathy and urgency vs. expectation-setting on delivery time).

**Grey area covered:** "Can you reset my password?" (routine request or compromised account - ask why before categorising), "Can you reinstall my VPN client?" (sounds like a request, but if connectivity was lost due to a bad update, it is an incident).

**One-line evaluation:** ITIL-accurate definition with operational implications and grey-area examples that most training documentation omits - consistent with ServiceNow and Jira ITSM content and adds categorisation nuance directly usable in ticket triage.

**Response quality rating:** 5/5

**Notes:** The grey area examples are the most valuable part of this response for practical work. A technician who categorises a password reset as a service request without asking why the user cannot log in may miss an active account compromise. Claude surfaced this risk without being prompted to - suggesting the model's training includes real-world ITSM edge cases, not just textbook definitions.

---

## Cross-Platform Comparison Notes

### Where Claude and ChatGPT Produced Different Answers to the Same Prompt

**VPN Error 429 interpretation:**
- ChatGPT: Reachability error ("A remote computer could not be reached") - Windows RRAS specific
- Claude: Rate-limiting response ("Too Many Requests") - Modern VPN gateway specific

Both are correct. The right answer depends on which VPN client the organisation uses. This is the most important finding from the cross-platform comparison - AI tools reflect different training emphasis, and the same error code can have legitimately different meanings in different contexts.

**Troubleshooting step sequence:**
- ChatGPT: Starts with "Confirm internet access" - connectivity first
- Claude: Starts with "Stop and wait 2-5 minutes" - rate-limiting specific, then connectivity check

Claude's rate-limiting first step is a meaningful addition. If the error is genuinely a 429 rate-limit, continued connection attempts make the lockout worse. ChatGPT's response sequence is correct for the RRAS interpretation but would not help (and could worsen) a rate-limiting scenario.

### Where Both Tools Produced Consistent High-Quality Output

- Structured response format with clear headings
- Numbered troubleshooting steps
- Copy-ready commands
- Logical escalation triggers
- Clear audience awareness (first-line analyst level)

### Overall Assessment

Both tools are useful. Claude's context retention and follow-up chaining make it stronger for multi-turn diagnostic conversations. ChatGPT's Windows-specific technical accuracy for built-in OS components (RRAS, VPN adapter, ncpa.cpl workflow) makes it a useful second opinion for Windows-native issues. Running the same prompt in both tools when the error code is ambiguous is worth the extra 60 seconds.
