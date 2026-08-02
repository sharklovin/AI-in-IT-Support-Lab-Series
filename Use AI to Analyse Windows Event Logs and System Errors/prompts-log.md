# Prompts Log - Lab 05

> **Lab:** Lab 05 - Use AI to Analyse Windows Event Logs and System Errors
>
> **Platform:** Claude.ai - Sonnet 4.6
>
> **Conversation:** Diagnosing Windows crash errors from event logs
>
> **Completed:** May 2026

---

## Prompt 1 - System Log Analysis

**Attachment:** Sample Log file.csv (23 System log entries, Event ID 7034)

**Prompt:**
> I am a Tier 1 IT support analyst. Attached is a sample of Windows System Event Log entries from a user's laptop that has been crashing intermittently. Identify the most significant errors, explain what each one means in plain language, and rank them by likely contribution to the crashes.

**Response summary:** 23 entries, 1 unique event type, crash count 94. Event ID 7034 - Camera Frame Server crash loop. Plain-language explanation of crash loop and resource exhaustion. Caution flag on export completeness. Five next steps including minidump check.

**One-line evaluation:** Correctly identified the crash loop, counter escalation, and resource risk - and appropriately flagged the incomplete export.

**Rating:** 5/5

---

## Prompt 2 - Remediation Steps

**Prompt:**
> For the error you ranked as most likely to cause the crash, what are the step-by-step remediation steps I should take?

**Response summary:** Four-phase plan: (1) stop crash loop with net stop FrameServer and sc config disabled, (2) diagnose with minidump check, Device Manager, and wevtutil export, (3) fix with driver rollback/update/uninstall, sfc /scannow, DISM, and re-enable service, (4) escalate with specific data points if unresolved.

**One-line evaluation:** Complete four-phase plan with exact commands, correct phase sequence (stop before diagnose before fix), and clear escalation trigger.

**Rating:** 5/5

**Key commands:**
```
net stop FrameServer
sc config FrameServer start= disabled
wevtutil epl System C:\Logs\System.evtx
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth
sc config FrameServer start= demand
net start FrameServer
```

---

## Prompt 3 - Cross-Log Pattern Analysis

**Attachment:** Sample app logs .csv (14 Application log entries, Event ID 100)

**Prompt:**
> Attached is an application log. Based on the System and Application log samples I provided, identify whether there is a pattern that could explain the intermittent crashes. Explain whether the events appear related or unrelated and justify your reasoning.

**Response summary:** Verdict - coincident, same trigger, different effects. Timeline: Bonjour bursts at 11:18 AM and 12:10 PM (52 min apart), camera crash loop 5/13 evening. Bonjour correctly assessed as harmless. Shared trigger: network reconnection or wake from sleep. Next step: Kernel-Power Event ID 1 and Wi-Fi events at matching timestamps.

**One-line evaluation:** Correct coincident-not-causal reasoning, accurate Bonjour assessment, specific upstream root cause hypothesis - the most diagnostically valuable output in the lab.

**Rating:** 5/5

---

## Prompt 4 - PowerShell One-Liner

**Prompt:**
> Generate a PowerShell one-liner that extracts all Critical and Error events from the Windows System log from the last 24 hours and outputs them to the console.

**Response summary:** Three variants: console output, CSV export, and System + Application combined. All use FilterHashtable with Level=1,2 and dynamic StartTime. Note to run as Administrator.

**One-line evaluation:** Correct Level codes, dynamic time window, appropriate format, and three useful variants with parameter explanations.

**Rating:** 5/5

**Primary command:**
```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddHours(-24)} | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message | Format-List
```

**CSV export variant:**
```powershell
Get-WinEvent -FilterHashtable @{LogName='System'; Level=1,2; StartTime=(Get-Date).AddHours(-24)} | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message | Export-Csv -Path "$env:USERPROFILE\Desktop\SystemErrors.csv" -NoTypeInformation
```

**Multi-log variant:**
```powershell
'System','Application' | ForEach-Object { Get-WinEvent -FilterHashtable @{LogName=$_; Level=1,2; StartTime=(Get-Date).AddHours(-24)} } | Select-Object TimeCreated, Id, LevelDisplayName, ProviderName, Message | Sort-Object TimeCreated | Format-List
```

---

## Cross-Prompt Notes

All four prompts ran in the same conversation. Claude retained System log context across Prompts 1, 2, and 3. When the Application log was uploaded in Prompt 3, Claude correctly referenced Event ID 7034 from Prompt 1 without needing context re-establishment - demonstrating effective follow-up chaining.

The cross-log analysis produced the most valuable output because it had two data sources to correlate. Richer, multi-source log samples produce more specific AI output. A filtered export with multiple event types (disk errors, memory faults, Kernel-Power events) would have allowed Claude to rank causes and identify secondary contributors.
