# Prompting Cheat Sheet - IT Support Edition

Quick reference for the four core AI prompting techniques. Use this during your first weeks on the desk until the patterns become automatic.

---

## Technique 1: Role Prompting

**What it does:** Assigns Claude an expert persona before you ask your question. This anchors the depth, vocabulary, and reasoning to a specific professional context.

**Template:**
```
You are a [job title / seniority level / specialisation].
A user has [specific issue with relevant details].
[Your question or instruction - e.g. "Walk me through the diagnostic steps in order of likelihood."]
```

**Real IT Example:**
```
You are a senior Windows 11 support engineer.
A user has experienced a blue screen with stop code MEMORY_MANAGEMENT.
Walk me through the diagnostic steps in order of likelihood.
```

**What changes:** Instead of a generic list, you get a prioritised walkthrough starting with the most probable cause (faulty RAM), including specific tools (MemTest86, WinDbg), commands, and a decision tree. The response assumes you are technically capable and gives you what you need for a live call.

**When to use it:** Any time the default response feels too generic or not deep enough for the situation you are in.

---

## Technique 2: Chain-of-Thought

**What it does:** Instructs Claude to reason through the evidence step by step before reaching a conclusion. Surfaces the diagnostic logic, not just the answer.

**Template:**
```
Think step by step. [Describe the symptoms and what is working versus what is not.]
What does this tell us about where the fault is likely to be?
```

**Real IT Example:**
```
Think step by step.
A user's laptop cannot connect to the office Wi-Fi but can connect to their mobile hotspot.
What does this tell us about where the fault is likely to be?
```

**What changes:** Claude reasons through each clue systematically. The hotspot working eliminates the Wi-Fi card, the driver, and the OS network stack. The fault narrows logically to the relationship between this laptop and this specific network - meaning a corrupted saved Wi-Fi profile, an 802.1X certificate issue, or a MAC filtering problem. You get the reasoning, not just a conclusion.

**When to use it:** Diagnostic puzzles where you have partial evidence. Also useful for learning - reading Claude's reasoning teaches you how to think about fault isolation.

---

## Technique 3: Few-Shot Prompting

**What it does:** Gives Claude two or three examples of the exact pattern you want, then asks your real question. Claude learns the format from your examples and applies it.

**Template:**
```
I want you to [describe the task].
Here are two examples:

Example 1 - [scenario]: [example input]
[Desired output label]: [example output]

Example 2 - [scenario]: [example input]
[Desired output label]: [example output]

Now apply the same approach to: [your real question]
```

**Real IT Example:**
```
I want you to ask diagnostic questions. Here are two examples of good first questions:

Example 1 - User says: "my email won't open"
Good first question: Is the issue affecting Outlook only, or also the browser-based version?

Example 2 - User says: "my printer is offline"
Good first question: Is the printer showing as offline for everyone on the floor, or just you?

Now apply the same approach to: "my Teams calls keep dropping"
```

**Claude's response:**
> Is the call dropping for everyone in the meeting, or just you - meaning, do others stay connected while you get kicked out?

**When to use it:** When you have a pattern in mind but it is hard to describe in abstract terms. Also useful for consistency - give Claude the same examples every time and responses will follow the same structure across your team.

---

## Technique 4: Output Formatting

**What it does:** Specifies exactly how the response should be structured. Tables, numbered steps, specific column headings, bullet lists - whatever format is most useful for how you will actually use the answer.

**Template:**
```
Respond only in a [format: table / numbered list / bullet points].
[If table: with columns: Column 1, Column 2, Column 3]
Issue / Question: [your question]
```

**Real IT Example:**
```
Respond only in a structured table with three columns:
Possible Cause, Likelihood (High/Medium/Low), First Action.
Issue: Windows 11 laptop is running very slowly after a recent update.
```

**What changes:** Instead of a paragraph you need to read and mentally reformat during a call, you get a scannable table. Sort by Likelihood column, jump to High, read First Action. No parsing required. Can be shared on screen with the user or pasted directly into a ticket.

**When to use it:** Live calls (table format for fast scanning), ticket notes (structured list), runbooks (numbered steps with escalation triggers), team documentation.

---

## Bonus: Combining Techniques

The highest-value combination for live service desk work is **role prompting + output formatting**.

**Template:**
```
You are a [role / tier level].
A user reports [specific issue].
Respond in a table with: [Column 1], [Column 2], [Column 3], [Column 4]
```

**Real IT Example:**
```
You are a Tier 2 support analyst.
A user reports Outlook keeps crashing on launch.
Respond in a table with: Symptom, Likely Cause (1-5 scale), Triage Step, Escalation Trigger
```

**Result:** A professional triage table with likelihood scoring, specific triage steps (including exact commands like `outlook.exe /safe`), and explicit escalation triggers. Paste into a runbook or use directly on a live escalation call.

---

## Context Chaining - Multi-Turn Prompts

Claude remembers the full conversation. You can add constraints progressively as a call unfolds.

**Pattern:**
```
Turn 1: [Base scenario - what the user reported]
Turn 2: [Add a constraint - what they already tried]
Turn 3: [Add urgency or new information]
```

**Live call example:**

| Turn | Your prompt | What Claude does |
|------|-------------|-----------------|
| 1 | "User says laptop is slow after a Windows update. First diagnostic step?" | Suggests Task Manager - CPU/Memory/Disk |
| 2 | "User says they already restarted twice. Next step?" | Skips restart, goes to Performance and Processes tab |
| 3 | "User has a client meeting in 10 minutes. What do I tell them?" | Pivots to triage mode - get through meeting, diagnose after |

You do not need to repeat the full scenario on each turn. Add new information as you receive it.

---

## Quick Decision Guide

| Situation | Technique to use |
|-----------|-----------------|
| Generic response, need more depth | Role prompting |
| Need to understand the reasoning, not just the answer | Chain-of-thought |
| Want Claude to follow a specific question or response pattern | Few-shot |
| Need a response you can use immediately during a call | Output formatting |
| Real troubleshooting call unfolding in real time | Context chaining |
| Need maximum quality in a single prompt | Role + output formatting combined |

---

*Cheat sheet for Lab 3 - AI Foundations | Keep this open on a second monitor during calls*
