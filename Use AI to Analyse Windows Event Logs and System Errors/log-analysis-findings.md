# Log Analysis Findings - Lab 05

> **Lab:** Lab 05 - Use AI to Analyse Windows Event Logs and System Errors
>
> **Platform:** Claude.ai - Sonnet 4.6
>
> **Conversation:** Diagnosing Windows crash errors from event logs
>
> **Completed:** May 2026

---

## System Log Analysis

**Input:** Sample Log file.csv - 23 entries, Event ID 7034, 5/13-5/14/2026

**Claude's finding:**
All 23 entries are Event ID 7034 from Service Control Manager. The counter in the message climbs from 72 to 94, confirming a single service crashing in a tight loop. The Windows Camera Frame Server service crashed 94 times in roughly 20 minutes on the evening of 5/13/2026 - approximately every 8-10 seconds at peak.

**Plain-language explanation (from Claude):** "The Windows Camera Frame Server service is crashing and immediately restarting, over and over. Every time it restarts it fails again within seconds, which floods system resources (CPU, handles, memory) and can destabilise other processes or cause a full system hang or BSOD."

**Claude's caution flag:** "This sample only captured one event type, which is unusual for a genuinely crashing machine. A real crashing laptop would typically also show disk errors (Event ID 7, 11, 51), memory faults, WHEA hardware errors, or kernel power events (Event ID 41). The absence here almost certainly means the export was filtered or scoped too narrowly."

**Analyst evaluation - Accuracy: High (5/5)**

What Claude got right: crash loop correctly identified, counter escalation noted, resource exhaustion risk flagged, absence of other event types correctly questioned, minidump check recommended. What Claude did not cover: did not note the 7034 counter increment mechanism (Service Control Manager logs 7034 only when a service crashes a configurable number of times; each logged event represents multiple crashes).

---

## Remediation Plan - Event ID 7034

**Phase 1 - Stop the crash loop**
```
net stop FrameServer
sc config FrameServer start= disabled
```
Run in elevated Command Prompt. Halts resource drain while investigating.

**Phase 2 - Diagnose root cause**
- Check C:\Windows\Minidump\ for BSOD dump files
- Check Device Manager (Win + X) - Cameras / Imaging devices - yellow triangle = driver fault
- Export broader logs: `wevtutil epl System C:\Logs\System.evtx`

**Phase 3 - Fix in order**
1. Roll back webcam driver: Device Manager - camera device - Properties - Driver - Roll Back Driver
2. If unavailable: Update Driver - Search automatically
3. If unresolved: Uninstall device - tick "Delete the driver software" - Scan for hardware changes
4. Run SFC: `sfc /scannow`
5. If SFC fails: `DISM /Online /Cleanup-Image /RestoreHealth`
6. Re-enable service: `sc config FrameServer start= demand && net start FrameServer`

**Phase 4 - Escalate if unresolved**
Hand off: original CSV, broader EVTX exports, minidump files, laptop make/model, Windows build (winver).

---

## Application Log Analysis

**Input:** Sample app logs .csv - 14 entries, Event ID 100 Bonjour Service, 5/14/2026

**Claude's finding:**
All 14 entries are Event ID 100 from Bonjour Service, in two bursts: 11:18 AM (7 entries) and 12:10 PM (7 entries), 52 minutes apart. Message: "Local Hostname Shark007.local already in use; will try Shark007-2.local instead."

**Plain-language explanation (from Claude):** "This is Apple's mDNS/Bonjour service detecting that another device on the network is already using the hostname Shark007.local, logging a burst of conflicts, renaming itself to Shark007-2.local, and moving on. This resolves itself in seconds and has no pathway to destabilise Windows."

**Analyst evaluation - Accuracy: Very High (5/5)**

Claude correctly assessed the Bonjour conflict as harmless, explained the mDNS mechanism accurately, and identified the two-burst pattern. Did not note that Bonjour is installed by iTunes, Apple TV, or Zoom - identifying which application installed it would determine whether it can be safely removed.

---

## Cross-Log Pattern Analysis

**Verdict: Coincident - same upstream trigger, different effects.**

**Claude's timeline reconstruction:**
- 11:18 AM: Bonjour burst 1 - network event triggers hostname conflict re-probe
- 12:10 PM: Bonjour burst 2 - second network event (reconnection or IP renewal)
- 5/13 evening: Camera crash loop - same class of network or wake event destabilises camera driver

**Claude's upstream root cause hypothesis:** "Both events likely fire when the machine joins or re-joins a network (waking from sleep, switching Wi-Fi). The network change causes Bonjour to re-probe for hostname conflicts, and may also cause the camera driver to lose its hardware context and begin crashing. Two separate subsystems reacting to the same stimulus - not one causing the other."

**Recommended next diagnostic step (from Claude):** Filter System log for Event ID 6013 (uptime), Event ID 1 from Kernel-Power, and Wi-Fi connection events at the same timestamps. If these align with both the Bonjour bursts and camera crash loop, the upstream cause is the network adapter driver or Windows power management mishandling reconnection.

**Analyst evaluation - Accuracy: Very High (5/5)**

Coincident-not-causal reasoning is correct. Shared trigger hypothesis is well-supported. Kernel-Power event correlation is the correct next step. The specific upstream hypothesis (network adapter or power management) is a Tier 2-quality finding produced from a Tier 1 analysis.

---

## AI Accuracy Summary

| Analysis | Rating | Key Strength |
|---|---|---|
| System log - Event ID 7034 identification | 5/5 | Crash loop, counter escalation, resource risk all correct |
| System log - data completeness flag | 5/5 | Correctly flagged unusual absence of disk/memory errors |
| Application log - Bonjour assessment | 5/5 | Correctly assessed as harmless, mDNS mechanism explained |
| Cross-log correlation | 5/5 | Coincident-not-causal correct, shared trigger hypothesis accurate |
| Remediation plan | 5/5 | Correct phase sequence, copy-pasteable commands |
| PowerShell one-liner | 5/5 | Correct Level codes, dynamic time, appropriate format |
