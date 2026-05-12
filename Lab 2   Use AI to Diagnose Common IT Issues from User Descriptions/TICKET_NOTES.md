# Ticket Notes - Lab 02

> **Lab:** Lab 02 - Use AI to Diagnose Common IT Issues from User Descriptions
>
> **Module:** AI Foundations - Claude for IT Support Diagnosis
>
> **Completed:** May 2026

---

## Session Configuration

| Field | Value |
|---|---|
| **Platform** | Claude.ai - Sonnet 4.6, Free plan |
| **Conversation title** | Tier 1 IT support diagnosis framework |
| **Role prompt** | Tier 1 IT support analyst at a 500-person company |
| **Output format** | Ranked causes, three diagnostic questions, three troubleshooting steps |
| **Total prompts** | 7 (1 role + 5 cases + 1 follow-up) |
| **All prompts in one session** | Yes - context carried across all cases |

---

## Case Quick Reference

| Case | Issue | Top Cause (AI) | Key AI Value | Override |
|---|---|---|---|---|
| 1 | Screen flickering | Loose display cable | External monitor as hardware/software splitter | No |
| 2 | Login failure | Background device with stale cached password | Lockout risk flag at 3/5 attempts | No (AD check required) |
| 3 | Printer faded stripe | Dirty/damaged drum unit | Fixed vs. shifting stripe question | Yes (physical access) |
| 4 | Display resolution small | Accidental resolution change | Scaling check as separate variable from resolution | No |
| 5 | HDD clicking + slow | HDD click of death | URGENT flag + backup before diagnostics | YES |

---

## Critical Technical Details by Case

### Case 1 - Screen Flickering

**Key diagnostic action:** Connect to external monitor via HDMI or DisplayPort.
- External stable = internal panel/cable/backlight fault
- External flickers = GPU or driver fault

**Driver rollback path:** Device Manager - Display Adapters - right-click GPU - Roll Back Driver

**Escalation trigger:** Screen goes black and does not recover without reboot, or flickering worsens rapidly within the day.

---

### Case 2 - Login Failure

**Critical first action:** Tell the user to stop attempting logins. 3 of 5 attempts used.

**AD check fields:**
- Account locked (yes/no)
- Password expired (yes/no)
- Account disabled (yes/no)
- Last bad password date and count
- Caller Computer Name (Event ID 4740) - identifies the device causing repeated lockouts

**Lockout source investigation:** Event ID 4740 in Windows Security Event Log. Caller Computer Name field identifies the offending device. Clear saved/cached credentials on that device.

**Escalation trigger:** Account active and unlocked in AD but password still rejected at machine - cached credentials conflict or domain controller connectivity failure.

---

### Case 3 - Printer Faded Stripe

**First action (before any tools):** Power off printer, remove toner cartridge, rock it side to side 5-6 times, reinstall, run test page. Resolves approximately 40% of toner stripe issues.

**Cleaning cycle path:** Printer control panel - Maintenance - Drum/Roller Clean

**Drum life check:** Control panel or web admin page - supply levels. Drum units typically rated 10K-30K pages depending on model.

**Fixed vs. shifting stripe:**
- Fixed position = drum or roller structural damage
- Shifting position = toner distribution issue

**Escalation trigger:** All three steps fail to resolve it. Drum unit replacement or on-site hardware inspection needed. Attach test page and supply counter readings to escalation ticket.

---

### Case 4 - Display Resolution

**Two separate checks required:**
1. Resolution: Right-click desktop - Display Settings - Display Resolution - select (Recommended)
2. Scaling: In Display Settings - Scale - confirm 100% or system-recommended (not 75% or lower)

Both must be checked. Correct resolution with low scaling produces the same symptom.

**Driver rollback path:** Device Manager - Display Adapters - right-click GPU - Roll Back Driver (if issue started after an update)

**Escalation trigger:** Recommended resolution not available in dropdown (missing or corrupt driver) or monitor showing as "Generic Monitor" (driver missing or cable/port fault).

---

### Case 5 - HDD Clicking Noise (Critical)

**Prohibited actions - do not do any of these:**
- Do not restart or shut down the machine
- Do not run chkdsk /f or any disk repair tool (write operations accelerate failure)
- Do not install anything or trigger Windows Update
- Do not clone the drive without Tier 2 present

**Priority order of actions:**
1. Keep machine powered on and idle (powering off a mechanically failing drive can be its last action)
2. Identify critical files to back up (Desktop, Documents, Downloads, Pictures, Outlook PST)
3. Copy to network share or OneDrive/SharePoint
4. Escalate to Tier 2 with full handoff data
5. SMART diagnostic (Tier 2 action, not Tier 1)

**Outlook PST default path:** C:\Users\[username]\AppData\Local\Microsoft\Outlook

**Robocopy command for backup:**
```
robocopy C:\Users\[username]\Documents \\networkshare\backup\[username] /E /Z /LOG:backup_log.txt
```
- /E copies subdirectories including empty
- /Z restartable mode (resumes partial copies)
- /LOG creates a transfer log file

**SMART quick check command:**
```
wmic diskdrive get status
```
Result of anything other than OK confirms drive fault.

**Detailed SMART check:** CrystalDiskInfo. Look for: Reallocated Sectors, Pending Sectors, Uncorrectable Errors. Status of Caution or Bad = escalate immediately.

**Tier 2 escalation handoff data:**
- Machine name and asset tag
- User name and floor
- SMART status result
- What data has and hasn't been copied
- How long symptoms have been occurring

**Ticket documentation requirements:**
- When issue was reported
- When backup was started
- When backup was completed
- What was escalated and when
- Whether data loss occurred

---

## The Human Judgment Rule - Quick Reference

The categories of IT support issue where AI output is a starting point and the human analyst must lead:

**Category 1 - Mechanical hardware failure with data loss risk**
Symptoms: clicking, grinding, smell, heat, physical damage. The analyst must act immediately - before AI output finishes loading. AI provides the checklist; the analyst provides the urgency.

**Category 2 - Potential security incident**
Symptoms: login failure without obvious cause, unusual network behaviour, account changes the user did not make, access to data the user should not have. AI surfaces the possibility; the security team investigates.

**Category 3 - User distress and emotional communication**
AI provides communication scripts. The analyst adapts them in real time based on the user's emotional state, the severity of the situation, and the operational context. The script is a starting point; the conversation is human.

---

## CompTIA A+ Troubleshooting Framework Alignment

| CompTIA A+ Step | AI Output Element |
|---|---|
| 1. Identify the problem | Response heading (names and frames the issue) |
| 2. Establish a theory | Ranked causes (most likely to least likely) |
| 3. Test the theory | Diagnostic questions (gather information to confirm theory) |
| 4. Establish a plan | First three troubleshooting steps |
| 5. Implement the solution | Steps 2 and 3 of troubleshooting steps |
| 6. Verify full system functionality | Escalation flag (what would indicate the issue is not resolved) |
| 7. Document findings | Not in AI output - analyst responsibility |

The AI output covers steps 1-6 of the CompTIA framework in every case. Step 7 (documentation) is the analyst's responsibility and is explicitly noted in the hard drive emergency response as a timestamped ticket requirement.
