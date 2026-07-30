# Lab 10: AI Augmented ServiceNow Incident Workflow

**AI + ITSM Integration | Claude + ServiceNow | Priority: High**

## Objective

Work an incident in ServiceNow while using Claude in a parallel window to assist with diagnosis, draft work notes, suggest escalation criteria, and generate the resolution note. This lab demonstrates a real world dual tool workflow that increases throughput without replacing the analyst's judgment.

## Business Scenario

Our service desk has started allowing analysts to have Claude open alongside ServiceNow during live calls. This repository documents the workflow for a complete incident lifecycle, from first contact to closure, showing exactly where AI added value and where the analyst remained in control. It is intended as a training guide for the rest of the team.

## Tools Used

| Category | Tool |
|---|---|
| ITSM Platform | ServiceNow PDI |
| AI Assistant | Claude.ai, opened in a second browser window |
| Workflow | Dual window: ServiceNow on the left, Claude on the right |
| Deliverable | This GitHub repository (training guide) |

## The Incident

**INC0010010** — User reports they cannot print to the office network printer HP LJ 3F 01. User is on Windows 11. The printer showed as offline that morning.

## Workflow Stages Documented

1. Incident creation and initial triage informed by AI diagnostic questions
2. Client confirms the issue is isolated to a single user, not the whole floor
3. AI assisted root cause analysis based on the new information
4. AI drafted work note documenting the investigation update, posted to the Activity log, state moved to In Progress
5. Fix applied (remove and re add the printer / reinstall the driver)
6. AI generated resolution note, posted to the Activity log, state moved to Resolved

## Step by Step Walkthrough

### 1. Incident Created in ServiceNow

A new incident, INC0010010, was logged for the printer issue and assigned to the analyst.

![Incident created in ServiceNow](screenshots/01-incident-created-in-servicenow.png)

> **Highlight:** Note the **State** field is set to **New** and **Urgency** to **3 - Low** at intake, before any AI assisted triage has taken place. This is the baseline the rest of the lifecycle builds on.

### 2. AI Assisted Diagnostic Questions

Before touching ServiceNow further, the incident description was pasted into Claude to generate diagnostic questions and first troubleshooting steps ahead of the first call with the user.

![Claude generates diagnostic questions](screenshots/02-claude-diagnostic-questions.png)

Claude returned three diagnostic questions (whether the issue was isolated or floor wide, whether anything recently changed, and whether the printer showed an error on its display panel) and three first steps (ping the printer, check the print queue, restart the spooler). These questions directly shaped the first call with the user.

### 3. Drafting the First Work Note with AI

Once the user confirmed the issue was isolated to their machine only, Claude was asked to phrase this finding as a professional ServiceNow work note.

![Claude drafts the isolated issue work note](screenshots/03-claude-worknote-draft-isolated-issue.png)

> **Highlight:** Claude was not yet connected to ServiceNow at this point (see the **"Connector search is off"** banner), so it correctly returned plain text for the analyst to paste in manually rather than attempting an action it could not perform. This is an example of the AI working within its actual permissions instead of assuming access it did not have.

### 4. Work Note Posted to the Activity Log

The AI drafted note was reviewed and pasted into the ServiceNow Work Notes field, then posted.

![Work note posted to the Activity log](screenshots/04-worknote-posted-activity-log.png)

### 5. AI Assisted Root Cause Analysis

With the isolated only finding logged, Claude was asked what the most likely cause was and what to check next.

![Claude provides root cause analysis](screenshots/05-claude-root-cause-analysis.png)

Claude reasoned that since a colleague on the same printer was unaffected, the printer, network, and print server were unlikely to be the cause, and pointed to a local port/IP binding or driver issue on the affected machine as the most probable cause, with a ranked checklist to confirm it.

### 6. Drafting the Investigation Update Work Note

Claude was then asked to turn the confirmed investigation findings and next step (remove and re add the printer) into a formal work note.

![Claude drafts the investigation update work note](screenshots/06-claude-investigation-update-worknote-draft.png)

### 7. Work Notes Updated, State Moved to In Progress

The investigation update was posted to the Activity log and the incident **State** was moved from **New** to **In Progress**, reflecting that active remediation was underway.

![Work notes updated and state changed to In Progress](screenshots/07-worknotes-updated-state-in-progress.png)

> **Highlight:** Look at the **State** dropdown in the top right — it now reads **In Progress**. This is the moment the analyst, not the AI, made the judgment call to move the ticket forward based on a completed diagnostic step.

### 8. AI Generated Resolution Note

After the fix was applied (printer driver removed and reinstalled) and the user confirmed printing worked again, Claude was asked to draft the resolution note.

![Claude drafts the resolution note](screenshots/08-claude-resolution-note-draft.png)

> **Highlight:** Claude again correctly reported that no ServiceNow connector was available in this conversation and provided the note as text only, reinforcing that the AI never silently assumes write access to a production style system.

### 9. Incident Resolved

The resolution note was pasted into Work Notes, posted, and the incident **State** was moved to **Resolved**.

![Resolved work notes added and state changed to Resolved](screenshots/09-resolved-worknotes-state-resolved.png)

## Dual Tool Workflow Diagram

See [`workflow-diagram.md`](workflow-diagram.md) for the full ASCII diagram showing exactly where Claude was used versus where the analyst acted independently.

## Where AI Helped Most in a Live Incident

- **Framing the first call.** Generating targeted diagnostic questions before the analyst spoke to the user meant the call stayed focused instead of the analyst improvising questions on the spot.
- **Turning raw findings into professional documentation.** Every work note and the final resolution note were drafted by Claude in ServiceNow appropriate language, saving the analyst from writing formal prose mid incident.
- **Structuring root cause reasoning.** Claude took a single data point (colleague on the same printer is unaffected) and produced a ranked, checkable list of likely causes, which shortened the path to the fix.
- **Consistency of tone across the ticket.** Because the same AI assisted phrasing style was used at every stage, the Activity log reads as a clean, professional narrative rather than a patchwork of quick notes typed under time pressure.

## Where the Analyst Must Lead

- **Identity verification.** Confirming the caller is who they say they are, and that the ticket is genuinely theirs, is a trust and security decision that must stay with the human analyst.
- **Escalation judgment.** Deciding whether an "isolated to one user" issue is actually isolated, or whether it is an early signal of a wider outage, requires situational judgment Claude does not have visibility into.
- **User communication tone.** Claude can draft internal work notes, but how the analyst actually speaks to a frustrated or anxious user on the call is a human skill that should not be delegated.
- **State transitions and closure.** Every State change (New to In Progress to Resolved) in this lab was made by the analyst after reviewing the AI's output, not automatically by the AI. The AI informs the decision; it does not make it.
- **Validating AI output before it becomes a record.** Every work note and resolution note drafted by Claude was reviewed by the analyst before being pasted into ServiceNow. AI output is a draft, not a system of record entry, until a human accepts it.

## Measuring AI Impact in IT Support

Rough, conservative time savings estimates per ticket type when an analyst works alongside Claude in this dual window pattern:

| Ticket Type | Typical Manual Time | With AI Assist | Estimated Savings |
|---|---|---|---|
| Simple hardware/peripheral issue (e.g. printer, mouse, monitor) | 15 to 20 minutes | 8 to 12 minutes | ~40 percent |
| Password reset / account lockout | 5 to 8 minutes | 4 to 6 minutes | ~20 percent |
| Software install / driver issue | 20 to 30 minutes | 12 to 18 minutes | ~35 to 40 percent |
| Network connectivity triage | 25 to 40 minutes | 15 to 25 minutes | ~35 percent |
| Complex/multi system incident | 45 to 90 minutes | 35 to 70 minutes | ~15 to 20 percent |

Savings are concentrated in **diagnostic framing** and **documentation time** rather than in the physical remediation itself, since AI cannot touch hardware or run commands the analyst has not chosen to run. The time saved on the printer ticket in this lab came almost entirely from not having to draft the work notes and resolution note from scratch, and from a tighter first call driven by pre generated diagnostic questions.

## What I Learned

1. AI is most valuable at the **start** (framing questions) and the **end** (writing documentation) of an incident, not necessarily in the middle where hands on troubleshooting happens.
2. A well drafted work note, written consistently at every stage, makes the Activity log dramatically easier for the next analyst (or the customer, if visible) to follow.
3. Claude correctly refusing to claim it had posted directly to ServiceNow when no connector was active is a good example of an AI tool being transparent about its own limits instead of hallucinating an action.
4. The dual window pattern only saves time if the analyst treats AI output as a **draft to review**, not a final answer to paste blindly. Every note in this lab was reviewed before posting.
5. Escalation judgment, identity verification, and tone with the end user remain firmly human responsibilities, and should be called out explicitly in any team training on this workflow so nobody assumes the AI "handles" those parts.

## Real World Relevance

Enterprise service desks are increasingly formalizing "AI assisted, human approved" patterns like this one into their team standards, because it captures documentation and consistency gains without handing over decisions that carry security, safety, or customer trust implications. As ITSM platforms add native AI copilots, the underlying discipline shown in this lab, using AI to accelerate triage and documentation while the analyst retains control of diagnosis, escalation, and closure, is exactly the pattern those native tools are being built to formalize. Teams that practice this discipline manually first, as in this lab, are better prepared to adopt native AI ITSM features responsibly when they roll out.

## Repository Contents

```
lab-10-ai-servicenow-incident-workflow/
├── README.md              This file — full training guide
├── workflow-diagram.md    Dual tool workflow ASCII diagram
├── prompts-log.md         Full Claude prompt and response log
└── screenshots/           All 9 annotated screenshots referenced above
```
