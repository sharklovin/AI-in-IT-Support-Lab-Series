# Prompts Log: Lab 7 - AI-Assisted Ticket and Handover Documentation

This log records every prompt sent to Claude during this lab, along with the response received, for auditability and reference.

---

## Prompt 1: Draft an Initial Incident Ticket

**Prompt:**
```
I am a service desk analyst. Write a professional incident ticket description
for the following user complaint: my laptop keeps freezing every 20 minutes
and I have to hard-restart it. I have been having this issue for three days.
Format it as: Short Description, Category, Subcategory, Priority, and Initial
Work Note.
```

**Response:**

> **Short Description:** Laptop freezing repeatedly every ~20 minutes, requiring hard restart
>
> **Category:** Hardware
>
> **Subcategory:** Endpoint / Laptop
>
> **Priority:** P2 - High
>
> **Initial Work Note:** User reports that their laptop has been experiencing complete system freezes approximately every 20 minutes over the past three days. Each freeze requires a hard restart (forced power cycle) to recover, as the system becomes entirely unresponsive. No specific trigger has been identified at this time.
>
> The recurring nature and three-day duration suggest a potential underlying issue with hardware (e.g., overheating, failing RAM, or storage drive errors) or a software/driver conflict. Immediate investigation is warranted to prevent data loss and minimize further disruption to the user's productivity.
>
> **Next Steps:**
> - Confirm whether any error messages or Blue Screen of Death (BSOD) codes appear before or after the freeze
> - Check Windows Event Viewer logs for critical errors around the times of the freezes
> - Run hardware diagnostics (CPU temperature, RAM test via MemTest86, disk health via SMART data)
> - Review recently installed applications or Windows updates that may coincide with the onset of the issue
> - Escalate to L2/Field Support if hardware fault is confirmed

**Evaluation:** The output is well structured and immediately usable in a ticketing system. One point worth flagging for analysts: when this same content was logged in ServiceNow, the ticket was set to **Priority 3 - Moderate**, not the **P2 - High** that Claude recommended. AI output should always be checked against your organisation's own priority matrix rather than applied automatically — see the highlighted screenshot below.

![Incident logged in ServiceNow with priority discrepancy highlighted](screenshots/02-servicenow-incident-created.png)

---

## Prompt 2: Improve a Poor-Quality Work Note

**Prompt:**
```
Improve this work note to professional service desk standard. Current note:
called user, they said its slow, tried turning it off and on, still slow,
will look at it later. The improved note should include: what was reported,
what was investigated, what action was taken, and what the next step is.
```

**Response:**

> **Work Note - Update**
>
> **Contact Method:** Telephone
>
> **What Was Reported:** User was contacted via telephone and confirmed that the device is experiencing significant performance degradation. The system is described as running slowly, impacting the user's ability to carry out normal day-to-day tasks.
>
> **What Was Investigated:** A standard first-line troubleshooting step was performed remotely with the user. A full system restart was carried out to rule out any temporary processes or memory overload as the cause of the slowness. Following the restart, the user confirmed that the performance issue persisted, indicating that the fault is not resolved by a reboot alone.
>
> **Action Taken:**
> - Contacted user via phone and gathered updated symptom information
> - Advised and assisted user in performing a full power cycle (shutdown and restart) of the device
> - Confirmed with user post-restart that the slow performance continued, ruling out a temporary software or process-related cause
>
> **Next Steps:** A further investigation is scheduled to perform an in-depth diagnostic review of the device. This will include checking CPU and memory utilization, reviewing startup processes, inspecting Event Viewer logs for errors, and assessing whether a hardware fault or software conflict is contributing to the degraded performance. User has been informed that a follow-up will be conducted and has been advised to continue saving work regularly to prevent any potential data loss.

**Evaluation:** This is the clearest demonstration of AI value in the lab. A three-line, information-poor note became a fully structured update with no loss of the original facts. See the full [before-and-after comparison](before-and-after.md).

![Improved work note posted into ServiceNow](screenshots/04-servicenow-work-notes-updated.png)

---

## Prompt 3: Generate an Escalation Handover Note

**Prompt:**
```
Write a professional escalation handover note from Tier 1 to Tier 2 for the
following scenario: user cannot access the company ERP system, error message
says access denied, AD account is active and in the correct group, issue
started after a role change was applied yesterday by the HR system. The note
should include all steps completed by Tier 1 and a clear handover statement.
```

**Response:**

> **ESCALATION HANDOVER NOTE**
> **Escalating From:** Tier 1 - Service Desk
> **Escalating To:** Tier 2 - Systems / Access Management Team
> **Escalation Priority:** P2 - High
> **Date/Time of Escalation:** 22 May 2026
>
> **Incident Summary:** The user is unable to access the company ERP system. Upon attempting to log in, the user receives an "Access Denied" error message. The issue began following a role change that was applied to the user's profile via the HR system the previous day. The user has had no access to the ERP system since the role change was enacted and is currently unable to perform core job functions.
>
> **Steps Completed by Tier 1:**
> 1. **User Verification & Symptom Gathering** - confirmed the exact error message, established the timeline against the HR role change, confirmed no other systems affected, verified the correct ERP URL was used.
> 2. **Active Directory (AD) Account Checks** - confirmed the account is Active, not locked or expired, password valid, and confirmed correct group membership with no recent unexpected changes.
> 3. **Basic Troubleshooting Performed** - session refresh, cache/cookie clear, alternate browser test, and confirmation the issue is user-specific, not a wider outage.
> 4. **HR System Role Change Review** - confirmed the role change with the user and HR records and identified it as the likely trigger, potentially a permission conflict or provisioning error.
> 5. **Escalation Decision** - Tier 1 troubleshooting has been exhausted; the issue requires backend investigation outside Tier 1 scope.
>
> **Handover Statement:** This incident is being formally escalated to the Tier 2 Systems and Access Management Team for advanced investigation. Tier 1 has confirmed that the user's AD account is active and correctly grouped; however, the "Access Denied" error persists following an HR-system-initiated role change applied yesterday. It is recommended that Tier 2 investigate the ERP role mapping tied to the new HR role, review the automated provisioning logs for any errors generated during the role transition, and verify that the updated role carries the correct ERP entitlements. The user has been informed of the escalation and is aware that Tier 2 will be in contact. Business impact is high as the user is currently unable to access a critical business system.
>
> **User Impact:** High - User is fully locked out of the ERP system and cannot perform core job functions.
> **User Notified of Escalation:** Yes
> **Ticket Status:** Escalated - Awaiting Tier 2 Assignment

**Evaluation:** The note gives Tier 2 everything needed to start work immediately without re-contacting the user or re-running basic checks - exactly what a handover note should achieve.

![Escalation handover note added to the incident activity log](screenshots/06-servicenow-escalation-note-added.png)

---

## Prompt 4: Draft a Resolution Note

**Prompt:**
```
Write a professional ticket resolution note for the following scenario: the
issue was a corrupted Outlook profile. The fix was to delete and recreate
the profile. The user confirmed email is now working. Include resolution
code, root cause, and resolution steps in plain English.
```

**Response:**

> **TICKET RESOLUTION NOTE**
> **Resolved By:** Tier 1 - Service Desk Analyst
> **Date/Time of Resolution:** 22 May 2026
> **Resolution Status:** Resolved - User Confirmed
> **Resolution Code:** SR1 - Software Fix / Configuration Repair
>
> **Root Cause:** The issue was caused by a corrupted Microsoft Outlook profile on the user's local machine. The Outlook profile stores key configuration data including account settings, cached credentials, and mailbox connection details. When this profile becomes corrupted - due to reasons such as an improper shutdown, a failed update, or file system errors - Outlook is unable to load correctly, preventing the user from sending, receiving, or accessing emails.
>
> **Resolution Steps:**
> 1. Confirmed the fault by replicating the issue in Outlook.
> 2. Accessed Mail settings via Control Panel to manage Outlook profiles.
> 3. Identified and removed the corrupted profile, with the user's confirmation.
> 4. Created a new Outlook profile using Autodiscover to configure mail server settings automatically.
> 5. Launched Outlook and verified the mailbox, folders, and connectivity loaded correctly.
> 6. Walked the user through sending and receiving a test email to confirm full functionality.
>
> **Additional Notes:** No data loss occurred, as mailbox data is stored server-side on Exchange/Microsoft 365. The user was advised to report any recurrence, as repeated profile corruption can indicate a failing hard drive. No further action required.
>
> **User Satisfaction Confirmed:** Yes
> **Ticket Status:** Closed - Resolved
> **Follow-Up Required:** No

**Evaluation:** The resolution code, root cause, and steps are clearly separated, which is exactly the structure a resolution note needs for reporting and knowledge-base reuse.

![Resolution code and resolution notes applied in ServiceNow](screenshots/07-servicenow-resolution-code-and-notes.png)

---

## Prompt 5: Build a Reusable Template Library

**Prompt:**
```
Create a set of five ticket documentation templates for an IT service desk:
(1) initial incident note, (2) investigation update note, (3) escalation
handover note, (4) resolution note, (5) closure note. Each template should
have placeholder fields in square brackets.
```

**Response:**

> Claude generated a complete five-template documentation library, delivered as a formatted Word document (`IT_ServiceDesk_Ticket_Templates.docx`), covering:
>
> | # | Template | Purpose |
> |---|---|---|
> | 1 | Initial Incident Note | Log a new incident with user details, symptoms, and first actions |
> | 2 | Investigation Update Note | Record findings and progress during active troubleshooting |
> | 3 | Escalation Handover Note | Formally hand over to Tier 2/3 with all steps documented |
> | 4 | Resolution Note | Document root cause, fix steps, and user confirmation |
> | 5 | Closure Note | Formally close the ticket with a closure statement and follow-up flags |
>
> Each template includes clearly labelled placeholder fields in square brackets, structured sections for what was reported, investigated, actioned, and planned, and a formal statement section, with consistent headers and footers across all five pages.

**Evaluation:** This is the deliverable this lab is built around. The five templates were converted into individual markdown files and published in [`documentation-templates/`](documentation-templates/) so they can be copied straight into any ticketing tool.

![Prompt used to generate the five-template documentation library](screenshots/08-prompt-template-library-generation.png)

---

## Summary

Five prompts were used across this lab to demonstrate the full documentation lifecycle: initial logging, work note improvement, escalation, resolution, and reusable templating. In every case, the AI-assisted output was more complete and more consistently structured than the unassisted equivalent - and in one case (Prompt 1) it also surfaced a useful discrepancy to check manually, showing that AI output still needs a human review step rather than blind copy-paste.
