# Ticket Notes - Lab 01

> **Lab:** Lab 01 - Set Up AI Tools for IT Support and Write Your First Prompt
>
> **Module:** AI Foundations - Claude.ai and ChatGPT
>
> **Completed:** May 2026

---

## Platform Account Details

### Claude.ai

| Field | Value |
|---|---|
| **URL** | https://claude.ai |
| **Username** | zhark |
| **Plan** | Free |
| **Model active** | Sonnet 4.6 |
| **Conversation title generated** | Windows 11 VPN connection error 429 |
| **Key interface features** | New chat, Search, Chats, Projects, Artifacts, Code (Upgrade), Customize, Recents |
| **Prompt input location** | Centre of screen, "How can I help you today?" placeholder |
| **Model selector location** | Bottom right of the prompt input box - "Sonnet 4.6" with dropdown arrow |

### ChatGPT

| Field | Value |
|---|---|
| **URL** | https://chatgpt.com |
| **User display name** | Nnamso Mkpong |
| **Plan** | Free |
| **Memory status** | Memory full (persistent memory feature active) |
| **Key interface features** | New chat, Search chats, Codex, More, Projects, Recents |
| **Prompt input location** | Centre of screen, "Ask anything" placeholder |
| **Shortcut buttons** | Create an image, Write or edit, Look something up |

---

## Prompt Engineering Techniques Demonstrated

### 1. Structured Diagnostic Prompt

**Definition:** A prompt that provides the OS, error code, and explicit request format (causes + steps) to produce a structured troubleshooting guide.

**Template:**
> A user on [OS version] reports [specific symptom]. Error code [code]. What are the most likely causes and what first-line steps should I take?

**Why it works:** The specificity of the error code and OS version constrains the AI's answer to the relevant context. The dual-part request ("causes AND steps") produces a response that covers both diagnosis and action. Without the error code, the response would be generic. Without the OS version, the response might not include OS-specific commands.

**When to use:** Any time you receive an error code you have not seen before, or when you want a structured starting point before opening the vendor knowledge base.

---

### 2. Follow-Up Chaining

**Definition:** Sending a follow-up prompt in the same conversation that adds new information (a failed fix) and requests the next step, without repeating the original context.

**Template:**
> Assume [action] was performed and the issue persists. What is the next [escalation path / diagnostic step / action]?

**Why it works:** The AI retains the full conversation history and uses it to inform the follow-up response. The new information (a reinstall was attempted) combines with the existing context (error 429, Windows 11, VPN) to narrow the remaining causes and produce a more targeted escalation path.

**When to use:** After each troubleshooting step that does not resolve the issue. Build the diagnostic session progressively within one conversation.

**Critical rule:** Never start a new chat for a follow-up on the same incident. Starting a new chat loses all accumulated context and forces you to re-establish the scenario from scratch.

---

### 3. Role Prompting

**Definition:** Beginning a prompt with a role instruction that tells the AI who it is (or who you are) in this context, constraining the response to the appropriate technical depth and format.

**Template:**
> You are a [specific role]. [Scenario]. [Specific output requested].

**Example used:**
> You are a Tier 1 IT support analyst. A user says their Outlook is not loading after a Windows update. Give me three diagnostic questions I should ask the user before I begin troubleshooting.

**Why it works:** The role instruction acts as a scope constraint. "Tier 1 IT support analyst" tells the AI to produce output appropriate for someone managing a live support call - not a developer, not a network architect. The output format ("three diagnostic questions") tells the AI exactly what to produce rather than letting it choose between questions, steps, or explanations.

**Role variations useful in IT support:**
- You are a Tier 1 IT support analyst
- You are a senior network engineer
- You are an ITSM team lead
- You are writing a knowledge base article for a junior analyst
- You are explaining this to a non-technical user

---

### 4. Negative Scope Prompting

**Definition:** Asking the AI what to avoid rather than what to do - producing an anti-pattern checklist.

**Template:**
> What should I NOT [do / ask / say] when [scenario]?

**Example used:**
> What should I NOT ask a user when they report a printing issue?

**Why it works:** Negative scope prompts access a different part of the AI's training - the patterns of bad practice that appear in the data alongside the good-practice examples. The resulting list is often more immediately actionable than a best-practice list because it directly prevents specific mistakes rather than describing an ideal process.

**Best uses in IT support:**
- Pre-call coaching for new analysts
- Peer review checklists
- User communication drafting ("What should I NOT say in this email to a frustrated user?")
- Change management risk identification ("What should I NOT skip when applying this firmware update?")

---

## Key Findings: VPN Error 429 - The Ambiguous Error Code

The most interesting outcome of this lab was the two different interpretations of the same error code by two AI tools.

### ChatGPT Interpretation
- Error 429 = "A remote computer could not be reached"
- Source: Windows RRAS (Routing and Remote Access Service) error code
- Applicable when: User is connecting via Windows built-in VPN (Settings - Network and Internet - VPN)
- Troubleshooting focus: Connectivity, DNS resolution, firewall, adapter health

### Claude Interpretation
- Error 429 = "Too Many Requests" / rate-limiting response
- Source: HTTP standard status code adopted by modern VPN gateways
- Applicable when: User is connecting via third-party VPN client (Cisco AnyConnect, Palo Alto GlobalProtect, Fortinet FortiClient, etc.)
- Troubleshooting focus: Rate-limiting, gateway capacity, orphaned sessions, authentication layer

### Practical Implication for IT Support

When a user reports VPN error 429, the first question must be:
> "What VPN software are you using - is it the built-in Windows VPN settings, or a separate application like Cisco AnyConnect or GlobalProtect?"

The answer determines which interpretation applies and therefore which troubleshooting path to follow. Both AI responses are correct within their respective contexts. Neither AI asked this clarifying question unprompted - which means the analyst must know to ask it.

**This is the correct mental model for AI in IT support:** AI provides structured frameworks based on the information given. The analyst provides the contextual judgement that narrows which framework applies to the specific situation.

---

## Incident vs Service Request - Key Definitions for Quick Reference

| Field | Incident | Service Request |
|---|---|---|
| **Definition** | Unplanned interruption to a service - something broken | Formal request for something new - routine delivery |
| **Trigger** | Something stopped working | Something is needed |
| **Goal** | Restoration - fastest path back to working | Fulfillment - correct delivery of the requested item |
| **Priority basis** | Impact on the business and urgency | SLA agreement and queue position |
| **SLA example** | Priority 1: respond in 15 min, resolve in 1 hour | Standard: deliver within 2 business days |
| **Tone** | Empathy and urgency | Clear expectation-setting on delivery time |
| **KPIs measured** | MTTR, first response time, reopen rate | Fulfillment time, first-time completion rate |
| **Example** | VPN is down, email not working, shared drive access error | New user account, software install, second monitor setup |
| **Grey area** | Password reset may be a service request OR an incident if the account was compromised | VPN reinstall may be a service request OR an incident if connectivity was lost due to a bad update |

---

## Effective Questions vs Bad Questions - Printing Issue Reference Card

### Ask These

- "What happens when you click Print - does anything happen at all, or does it seem to start and then stop?"
- "Is this affecting just one document or all documents?"
- "Can other people in the office print to the same printer right now?"
- "When did this last work correctly?"

### Do Not Ask These

| Bad question | Why it is bad | Better approach |
|---|---|---|
| "What's your name?" | It's in the ticket | Look it up |
| "What department are you in?" | It's in the ticket | Look it up |
| "What's the printer's IP address?" | User doesn't know | Pull from your asset register |
| "What OS are you on?" | Check the device record | Check it yourself first |
| "Did you do something different today?" | Implies blame | Investigate first, ask if evidence suggests user action |
| "Are you sure you're using it correctly?" | Condescending | Trust the user's competence |
| "Is the printer on?" | Implies obvious oversight | Say "Can you confirm the printer's power light is showing?" as a check, not an accusation |
| "Have you tried fixing it?" | Vague, adds nothing | Ask what they have already tried specifically |

**The rule:** Don't ask what you can look up. Don't ask what is obvious. Don't ask in a way that makes the user feel suspected or stupid.

---

## AI Tool Selection Guide for Common IT Support Scenarios

| Scenario | Recommended tool | Why |
|---|---|---|
| Unknown error code, first encounter | Either (run both for ambiguous codes) | Cross-reference interpretations |
| Multi-step troubleshooting that builds on previous steps | Claude | Superior context retention in follow-up chains |
| Generating a ticket note draft | Either | Both format well; Claude slightly more structured |
| Explaining ITSM concepts to a new team member | Claude | Includes grey area examples and operational implications |
| Windows-specific command sequences | ChatGPT | Slightly more Windows-native in command vocabulary |
| Pre-call coaching on what NOT to do | Either | Negative scope prompts work equally well on both |
| Current CVE or patch note lookup | Neither | Use vendor portal or NVD directly |
| Organisation-specific configuration questions | Neither | Use your internal runbook or ask your team |
| Security incident investigation | Neither | Use your SIEM and security team |
| User communication drafting | Either | Both produce clean professional language |
