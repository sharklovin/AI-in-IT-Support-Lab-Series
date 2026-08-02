# Prompts Log - Lab 3: Advanced Prompting Techniques for IT Support

Full record of every prompt and Claude's response used in this lab. Documented in sequence to show the progression of techniques.

---

## Prompt 1: Unstructured (Bad Prompt - Baseline)

**Technique:** None - this is the control/baseline

**Prompt:**
```
How do I fix a blue screen error?
```

**Screenshot:** `screenshots/01-bad-prompt-unstructured.png`

**Claude's Response:**

Here are the most effective ways to fix a blue screen of death (BSOD) error:

**1. Note the Error Code**
The blue screen displays a stop code (e.g., SYSTEM_THREAD_EXCEPTION_NOT_HANDLED). Search that exact code online for targeted fixes.

**2. Restart and Check for Recurrence**
Sometimes it's a one-time glitch. Restart and see if it happens again before doing anything else.

**3. Undo Recent Changes**
- Uninstall recently installed software or drivers
- Roll back Windows updates (Settings - Windows Update - Update History - Uninstall updates)

**4. Update or Roll Back Drivers**
Outdated or corrupt drivers are the #1 cause. Focus on: Graphics card drivers, Network/Wi-Fi drivers, Chipset drivers. Go to Device Manager, right-click a device, and choose Update driver or Roll back driver.

**5. Run Windows Diagnostics**
- Memory check: Search for Windows Memory Diagnostic and run it to test your RAM
- Disk check: Open Command Prompt as admin and run `chkdsk /f /r`
- System file repair: Run `sfc /scannow` in an admin Command Prompt

**6. Check for Overheating**
Dust buildup can cause thermal shutdowns that look like BSODs. Clean vents, check fans, and monitor temps with a tool like HWMonitor.

**7. Scan for Malware**
Run a full scan with Windows Defender or another trusted antivirus.

**8. Use System Restore**
If it started recently, restore to a previous point via Control Panel - Recovery - Open System Restore.

**9. Check Event Viewer**
Search for Event Viewer - Windows Logs - System to find critical errors logged around the time of the crash.

**10. Reinstall Windows (Last Resort)**
If nothing works, a clean Windows install usually resolves persistent BSODs.

What's the stop code on your blue screen? That'll help narrow down the exact cause.

---

**Analysis:** Generic 10-step list. No prioritisation by likelihood. No specific commands for the scenario. The final question ("What's the stop code?") is useful but comes after 10 steps of generic advice. This response requires mental filtering during a live call.

---

## Prompt 2: Role Prompting

**Technique:** Role prompting - assigns expert persona and provides specific stop code

**Prompt:**
```
You are a senior Windows 11 support engineer. A user has experienced a blue screen
with stop code MEMORY_MANAGEMENT. Walk me through the diagnostic steps in order of likelihood.
```

**Screenshot:** `screenshots/02-good-prompt-role-prompting.png`

**Claude's Response:**

**MEMORY_MANAGEMENT BSOD - Diagnostic Walkthrough**

This stop code (0x0000001A) means Windows encountered a critical error in its memory management subsystem. It's almost always hardware or driver-level. Here's the order I'd work through it:

**Step 1 - Run Windows Memory Diagnostic (Most Likely Cause: Bad RAM)**
This is your first move. Faulty RAM causes the majority of MEMORY_MANAGEMENT BSODs.
- Start - search "Windows Memory Diagnostic" - Restart now and check for problems
- After reboot, check results in Event Viewer - Windows Logs - System, filter for MemoryDiagnostics-Results
- If it reports errors, reseat or replace the RAM. Test each stick solo to isolate the faulty one

**Step 2 - Run MemTest86 (Deeper RAM Test)**
Windows Memory Diagnostic misses errors that MemTest86 catches. Download from memtest86.com, boot from USB, run at least 2 full passes. Any errors = faulty RAM.

**Step 3 - Check for Corrupt System Files**
Run in admin Command Prompt:
```
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
```
Reboot after each. SFC repairs from local cache; DISM pulls clean files from Windows Update.

**Step 4 - Analyse the Minidump File**
Minidumps are at `C:\Windows\Minidump\`. Open with WinDbg or upload to an online analyzer. Look for the faulting module - it will name a specific .sys or .dll file. That filename is your smoking gun.

**Step 5 - Update or Roll Back Drivers**
If the minidump implicates a driver: GPU drivers (use DDU for clean uninstall), Storage/NVMe drivers, Network adapter drivers, Chipset drivers.

**Step 6 - Check Storage Health**
```
chkdsk C: /f /r /x
```
Also check SSD health with CrystalDiskInfo - look for reallocated sectors or uncorrectable errors.

**Step 7 - Check for Overclocking**
If the system is overclocked, enter BIOS and reset to defaults. XMP profiles can destabilise memory timings. Test for 24-48 hours at stock.

**Step 8 - Check Physical RAM Seating**
Power off, remove RAM, clean gold contacts with an eraser, reseat firmly in correct dual-channel slots.

**Step 9 - Windows Update and BIOS/Firmware**
Ensure Windows 11 is fully updated. Check motherboard manufacturer's site for BIOS update.

**Step 10 - Replace RAM**
If MemTest86 confirms errors, the RAM is defective. Check manufacturer warranty (most carry lifetime warranty from Corsair, Kingston, G.Skill).

**Quick Decision Tree:**
```
BSOD occurred?
 - Run WinDiag / MemTest86
     - RAM errors found - Replace RAM
     - RAM clean
         - Check minidump for faulting module
             - Third-party driver - DDU + reinstall driver
             - Windows core file - SFC/DISM - chkdsk - consider reinstall
```

---

**Analysis:** Same topic, completely different usefulness. Ordered by likelihood. Specific commands. Decision tree for routing. Escalation logic. Ready for a live call with no additional mental work.

---

## Prompt 3: Chain-of-Thought

**Technique:** Chain-of-thought - "Think step by step" instruction

**Prompt:**
```
Think step by step. A user's laptop cannot connect to the office Wi-Fi but can connect
to their mobile hotspot. What does this tell us about where the fault is likely to be?
```

**Screenshot:** `screenshots/03-chain-of-thought-prompt.png`

**Claude's Response:**

Good diagnostic puzzle. Let's reason through what this evidence actually tells us.

**What We Know**
- Works: Mobile hotspot
- Fails: Office Wi-Fi only

**Step-by-Step Logical Deduction**

**Step 1 - The Hardware is Fine**
The Wi-Fi adapter is physically working. The laptop can discover, authenticate, and maintain a connection to a wireless network. This eliminates: faulty Wi-Fi card, broken antenna, disabled wireless hardware switch, driver crash (a dead driver wouldn't work on hotspot either).

Conclusion: The laptop's wireless hardware and drivers are not the root cause.

**Step 2 - The OS Network Stack is Mostly Fine**
Windows can associate with an access point, obtain an IP, and route traffic via the hotspot. The core TCP/IP stack, DHCP client, and DNS resolver are all functional in at least one environment.

Conclusion: A wholesale OS networking failure is unlikely.

**Step 3 - The Fault is Environmental or Configuration-Specific**
Since the variable that changes between the two scenarios is the network being joined, the fault lies in one of these:
- The office network itself - AP down, wrong SSID broadcast, overloaded DHCP pool
- The interaction between this specific laptop and the office network - a configuration mismatch
- Authentication/policy - the office network may use WPA2-Enterprise, 802.1X, or MAC filtering

**Step 4 - Narrow by Authentication Type**

| Office Wi-Fi Type | Likely Fault |
|-------------------|-------------|
| WPA2-Enterprise / 802.1X | Certificate expired, missing, or wrong credentials |
| WPA2-Personal (password) | Saved profile corrupt or wrong password |
| Open / captive portal | Portal not loading, browser redirect failing |
| MAC filtering | Laptop's MAC not whitelisted |

The hotspot uses simple WPA2-Personal, bypassing all enterprise auth complexity - which is exactly why it works.

**Step 5 - Ask Whether Others Are Affected**
Other users also can't connect - fault is on the infrastructure side (AP, DHCP, RADIUS server). Take it to network admin.
Only this laptop affected - fault is in this laptop's profile, credentials, or configuration for that specific network.

**Where the Fault Is Most Likely**
1. Corrupt or outdated saved Wi-Fi profile - forget the network and rejoin fresh
2. 802.1X / certificate issue - machine cert or user credential expired
3. IP address conflict or DHCP exhaustion
4. MAC address filtering - laptop's MAC not whitelisted
5. Office AP or infrastructure fault - least likely if other devices connect fine

**The Core Insight**
The hotspot working is not just a workaround - it's a diagnostic instrument. It tells you the fault boundary is outside the laptop's hardware and OS, and inside the relationship between this laptop and this specific network.

---

**Analysis:** Chain-of-thought produced a step-by-step elimination of causes, with a clear fault boundary conclusion and a prioritised list of likely causes. The reasoning is visible and teachable.

---

## Prompt 4: Few-Shot Prompting

**Technique:** Few-shot - two examples train the pattern before the real question

**Prompt:**
```
I want you to ask diagnostic questions. Here are two examples of good first questions:

Example 1 - User says: "my email won't open"
Good first question: Is the issue affecting Outlook only, or also the browser-based version of email?

Example 2 - User says: "my printer is offline"
Good first question: Is the printer showing as offline for everyone on the floor, or just you?

Now apply the same approach to this user complaint:
"my Teams calls keep dropping"
Give me one good first question following the pattern above.
```

**Screenshot:** `screenshots/04-few-shot-prompting.png`

**Claude's Response:**

> Is the call dropping for everyone in the meeting, or just you - meaning, do others stay connected while you get kicked out?

---

**Analysis:** The few-shot examples taught Claude the pattern of "scope-narrowing diagnostic question" without describing it abstractly. The response correctly applies the same logic: scope the issue to one user vs. everyone before attempting any fix.

---

## Prompt 5: Output Formatting

**Technique:** Output formatting - structured table with specified columns

**Prompt:**
```
Respond only in a structured table with three columns:
Possible Cause, Likelihood (High/Medium/Low), First Action.
Issue: Windows 11 laptop is running very slowly after a recent update.
```

**Screenshot:** `screenshots/05-output-formatting-table.png`

**Claude's Response:**

| Possible Cause | Likelihood | First Action |
|----------------|-----------|-------------|
| Windows Update still indexing/optimising in background | High | Wait 24-48 hours and check if performance recovers on its own |
| Corrupt update causing system file damage | High | Run `sfc /scannow` in an admin Command Prompt |
| Update reset power plan to Balanced or Power Saver | High | Check Settings - System - Power & Sleep - Additional power settings and set to High Performance |
| Update installed a faulty driver (especially GPU or storage) | High | Open Device Manager and check for yellow warning flags; roll back flagged drivers |
| Windows Search or Delivery Optimisation hammering the disk | Medium | Open Task Manager and check which process is consuming CPU or disk at 100% |
| Antivirus running a full scan triggered by new update files | Medium | Check antivirus console for active scan; pause and observe if performance improves |
| Startup programs re-enabled by update | Medium | Task Manager - Startup tab - disable non-essential entries |
| Insufficient RAM for updated OS requirements | Medium | Check RAM usage in Task Manager; if consistently above 85%, consider upgrade |
| Update enabled unwanted background services | Medium | Run msconfig - Services tab - hide Microsoft services - disable unfamiliar entries |
| SSD degraded and struggling with update write load | Low | Run CrystalDiskInfo to check drive health; look for caution or bad status |
| Update incompatible with third-party software causing conflicts | Low | Boot into Safe Mode and test performance; improvement points to a software conflict |
| Insufficient disk space after update files were written | Low | Check that C: drive has at least 10-15% free space; clear with Disk Cleanup |

---

**Analysis:** Table format allows scanning the Likelihood column, jumping to High, and reading the First Action without parsing a paragraph. Immediately usable during a live call.

---

## Prompt 6: Context Chaining - Turn 1

**Technique:** Context chaining - base scenario

**Prompt:**
```
A user reports their laptop is slow after a Windows update. Give me the first diagnostic step.
```

**Screenshot:** `screenshots/06-context-chaining-step1.png`

**Claude's Response:**

Open Task Manager - Performance tab and check whether CPU, Memory, or Disk is consistently pegged high over 30-60 seconds of observation - not just a spike.

Then switch to the Processes tab, sort each column from highest to lowest, and tell me the top offender in whichever resource is maxed out. The process name will determine the next move.

---

## Prompt 7: Context Chaining - Turn 2 (Constraint Added)

**Technique:** Context chaining - constraint added to running conversation

**Prompt:**
```
The user says they already tried restarting twice. What's the next step?
```

**Screenshot:** `screenshots/07-context-chaining-step2.png`

**Claude's Response:**

Open Task Manager - Performance tab and check whether CPU, Memory, or Disk is consistently pegged high over 30-60 seconds of observation - not just a spike.

Then switch to the Processes tab, sort each column from highest to lowest, and tell me the top offender in whichever resource is maxed out. The process name will determine the next move.

---

**Analysis:** Claude retained the context from Turn 1 and updated its advice based on the new constraint (already restarted twice). The restart suggestion was skipped and deeper triage was offered.

---

## Prompt 8: Context Chaining - Turn 3 (Urgency Added)

**Technique:** Context chaining - urgency constraint changes the priority

**Prompt:**
```
Now the user says they have a client meeting in 10 minutes. What do I tell them?
```

**Screenshot:** `screenshots/08-context-chaining-urgency.png`

**Claude's Response:**

Tell them:

**Get through the meeting first - here's how to squeeze the most performance out right now:**

1. **Close everything except Teams** (or whatever they're using for the meeting) - every browser tab, Office doc, and background app
2. **Plug in the charger** if they're on battery - laptops throttle hard on battery when slow
3. **Restart once more right now** if they have 3 minutes to spare - it's faster than any other fix at this point

**Reassure them:** A slow laptop won't stop the meeting from working - it'll just feel sluggish. Teams calls prioritise network over CPU so the call itself should hold.

Then pick up the full diagnostic straight after the meeting.

---

**Analysis:** Claude pivoted from diagnostic mode to triage mode based on the urgency constraint. The response is immediately actionable and appropriate for the real-world situation. This is context chaining working correctly.

---

## Prompt 9: Combined Techniques - Role + Output Formatting

**Technique:** Role prompting combined with output formatting

**Prompt:**
```
You are a Tier 2 support analyst. A user reports Outlook keeps crashing on launch.
Respond in a table with: Symptom, Likely Cause (1-5 scale), Triage Step, Escalation Trigger
```

**Screenshot:** `screenshots/09-combined-role-plus-formatting.png`

**Claude's Response:**

| Symptom | Likely Cause (1-5) | Triage Step | Escalation Trigger |
|---------|-------------------|-------------|-------------------|
| Outlook crashes immediately on launch, before profile loads | Corrupt Outlook profile - 5 | Open Run - `outlook.exe /safe` - if it opens, the profile or an add-in is the cause | Crashes in Safe Mode too - escalate to Tier 3 for OST/profile rebuild |
| Outlook opens briefly then closes with no error | Faulty or conflicting add-in - 4 | Safe Mode launch confirmed working - File - Options - Add-ins - Manage COM Add-ins - disable all, re-enable one at a time | Add-ins all disabled and crash persists - escalate for deeper COM investigation |
| Crash accompanied by "Cannot open your default email folders" error | Corrupt OST file - 4 | Close Outlook, navigate to `%localappdata%\Microsoft\Outlook`, rename the .ost file, relaunch to rebuild | OST rebuild fails or Exchange connection error appears - escalate to Exchange/M365 admin |
| Crash only on a specific machine, works fine on another | Machine-level Office installation corruption - 3 | Run Office Quick Repair via Apps & Features - Microsoft 365 - Modify | Quick Repair and Online Repair both fail - escalate for full Office reinstall |
| Crash after recent Windows or Office update | Bad update interaction - 3 | Check update history, roll back the most recent Office or Windows update and retest | Rollback not possible or crash persists after rollback - escalate to Tier 3 |
| Crash with Windows Event Viewer error pointing to a specific DLL | Corrupt or missing system/Office DLL - 2 | Note the DLL name from Event Viewer - run `sfc /scannow`, then DISM if needed | SFC/DISM cannot repair the file - escalate for OS-level intervention |
| Crash only when connected to corporate network/VPN | Network or Exchange policy conflict - 2 | Test launch off VPN; if stable, check Exchange connectivity and Autodiscover settings | Off-network Outlook stable but VPN config confirmed correct - escalate to network/Exchange team |
| Crash accompanied by antivirus alert or quarantine notice | Antivirus falsely flagging an Outlook component - 1 | Check AV quarantine log, restore any flagged Outlook files, add Outlook to AV exclusions | Repeated quarantine after exclusion set - escalate to security team for policy review |

---

**Analysis:** Role prompting (Tier 2 analyst) combined with table output formatting produces a professional runbook-quality triage table. The likelihood scale (1-5) and explicit escalation triggers make this directly usable for live escalation calls and team documentation.

---

*Prompts Log - Lab 3 | All prompts tested in Claude.ai using claude-sonnet-4-6*
