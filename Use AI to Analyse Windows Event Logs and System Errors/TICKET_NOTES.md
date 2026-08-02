# Ticket Notes - Lab 05

> **Lab:** Lab 05 - Use AI to Analyse Windows Event Logs and System Errors
>
> **Module:** AI-Assisted Scripting - Event Log Analysis
>
> **Completed:** May 2026

---

## Incident Summary

| Field | Value |
|---|---|
| **Issue** | Intermittent laptop crashes, 3 days |
| **Machine** | Shark007 (WORKSTATION01) |
| **Primary finding** | Event ID 7034 - Camera Frame Server crash loop (94 crashes) |
| **Secondary finding** | Event ID 100 - Bonjour hostname conflict (harmless) |
| **Root cause hypothesis** | Network reconnection destabilises camera driver |
| **Upstream cause** | Network adapter driver or Windows power management |
| **Resolution path** | Tier 1: stop service + driver rollback / Tier 2: if unresolved |

---

## Key Event IDs

| Event ID | Source | Log | Meaning | Crash risk |
|---|---|---|---|---|
| 7034 | Service Control Manager | System | Service terminated unexpectedly (counter shows loop count) | High if looping |
| 41 | Kernel-Power | System | Dirty shutdown / BSOD | Critical |
| 1 | Kernel-Power | System | Power state change | Context for timing |
| 6013 | EventLog | System | System uptime in seconds | Crash timing reference |
| 7 | Disk | System | Bad sector detected | High |
| 11 | Disk | System | Controller error | High |
| 51 | Disk | System | Paging error | High |
| 1000 | Application Error | Application | Application crash (faulting module logged) | Medium |
| 100 | Bonjour Service | Application | mDNS hostname conflict - self-resolving | None |
| 8198 | Security-SPP | Application | Software licensing event | Low unless pattern |

---

## Sanitisation Checklist

Before uploading any Event Log CSV to Claude:
- [ ] Replace real usernames in User field with USER01
- [ ] Replace personal hostnames (firstname.lastname-laptop) with WORKSTATION01
- [ ] Check message text for embedded usernames or employee IDs
- [ ] Check for email addresses in message text
- [ ] Check file paths containing usernames (C:\Users\firstname...)
- [ ] Confirm organisation policy on uploading log data to cloud AI tools

---

## Event Viewer Navigation

| Task | Path |
|---|---|
| Open Event Viewer | Win + R - eventvwr.msc |
| Filter System log | Windows Logs - System - Actions - Filter Current Log |
| Filter Application log | Windows Logs - Application - Actions - Filter Current Log |
| Export selected | Select events - right-click - Save Selected Events |
| Export all filtered | Right-click log name - Save Filtered Log File As |
| Export full log | Right-click log name - Save All Events As |

---

## PowerShell Commands

All require elevated PowerShell (Run as Administrator).

```powershell
# Critical + Error, System log, last 24 hours (console)
Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddHours(-24)} | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message | Format-List

# Export to CSV
Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddHours(-24)} | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message | Export-Csv -Path "$env:USERPROFILE\Desktop\SystemErrors.csv" -NoTypeInformation

# Stop Camera Frame Server
net stop FrameServer
sc config FrameServer start= disabled

# Re-enable after fix
sc config FrameServer start= demand
net start FrameServer

# Export full log for Tier 2
wevtutil epl System C:\Logs\System.evtx

# Run SFC
sfc /scannow

# DISM repair (if SFC fails)
DISM /Online /Cleanup-Image /RestoreHealth
```

---

## AI Triage Decision

| Scenario | AI leads | Human leads |
|---|---|---|
| Single event type - need explanation | Yes | No |
| Multiple event types - rank by crash contribution | Yes | No |
| Cross-log pattern correlation | Yes | No |
| PowerShell command generation | Yes | No |
| Physical hardware inspection | No | Yes |
| Determining if log absence = no errors | No | Yes |
| Security event classification | No | Yes |
| Escalation timing based on business impact | No | Yes |
| Minidump / kernel crash analysis | Tier 2 + tools | Yes |
