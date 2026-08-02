# Prompt Logs: AI Assisted PowerShell Scripting for Active Directory Administration

This file contains every prompt sent to Claude during this lab, in the order they were sent, along with the full response received. Screenshots of each exchange are included for verification. Full script contents are in the [scripts](./scripts) folder rather than repeated here in full.

---

## 1. Password Reset Script

**Prompt:**

> Write a PowerShell script that resets a single Active Directory user's password. The script should accept a username as a parameter, set the password to a temporary value, and force a password change at next login. Add error handling for a user not found scenario. Include comments explaining each section.

**Response summary:**

Claude returned a complete script, `Reset-ADUserPassword.ps1`, using the ActiveDirectory module. Key points from the response:

- Usage: `.\Reset-ADUserPassword.ps1 -Username "jdoe"` auto generates a temporary password, or a specific one can be supplied with `-TempPassword`.
- User not found handling: the script specifically catches `ADIdentityNotFoundException` from `Get-ADUser` before attempting any password change, giving a clear "user not found" message rather than a confusing error further down.
- Requirements: needs the ActiveDirectory module (RSAT) and an account with delegated rights to reset passwords in the target OU.

The full generated script is at [scripts/Reset-ADUserPassword.ps1](./scripts/Reset-ADUserPassword.ps1).

**Screenshot:** `screenshots/01_claude_prompt_password_reset_script.png`

---

## 2. Inactive Users Export Script

**Prompt:**

> Write a PowerShell script that exports all Active Directory user accounts that have not logged in within the last 90 days to a CSV file called inactive-users.csv. Include the username, last logon date, department, and manager. Add a line count at the end.

**Response summary:**

Claude returned a complete script, `Export-InactiveADUsers.ps1`. Key implementation notes from the response:

- Default output: `.\inactive-users.csv` in the current directory, matching what was asked for, with an `-OutputPath` override available.
- Inactivity logic: uses `LastLogonTimestamp`, the replicated attribute, rather than `LastLogon`, since `LastLogon` is per domain controller and not replicated, checking it domain wide would require querying every domain controller individually. The tradeoff is that `LastLogonTimestamp` can lag real logon time by up to roughly 9 to 14 days by default AD replication settings, so the response noted the 90 day threshold should be treated as approximate rather than exact to the day.
- Accounts that have never logged on are also included as inactive, with a `Never logged on` value in place of a date.

The full generated script is at [scripts/Export-InactiveADUsers.ps1](./scripts/Export-InactiveADUsers.ps1).

**Screenshot:** `screenshots/07_claude_prompt_export_inactive_users_script.png`

---

## 3. Disk Space Checking Script

**Prompt:**

> Write a PowerShell script that reads a list of computer names from a text file, checks the free disk space on the C drive of each one, and outputs a colour coded result in the console. Red if below 10 GB, yellow if below 20 GB, green if above 20 GB.

**Response summary:**

Claude returned a complete script, `Check-DiskSpace.ps1`. Key implementation notes from the response:

- Usage: `.\Check-DiskSpace.ps1 -ComputerListPath .\computers.txt`, where the text file has one computer name per line, blank lines are ignored.
- Query method: uses `Get-CimInstance`, the modern replacement for `Get-WmiObject`, against `Win32_LogicalDisk`, filtered to the C drive. This needs WinRM (or DCOM as a fallback) reachability and permissions on each target machine.
- Colour logic: red below 10 GB, yellow 10 to 20 GB, green at or above 20 GB, with the thresholds defined as variables at the top of the script so they can be adjusted in one place.
- Unreachable machines: errors (offline, access denied, no WinRM, etc.) are caught per computer and shown in dark red with the specific error message, so a failed query is never confused with a genuine low disk space reading.

The full generated script is at [scripts/Check-DiskSpace.ps1](./scripts/Check-DiskSpace.ps1).

**Screenshot:** `screenshots/11_claude_prompt_disk_space_script.png`

---

## Summary of Prompts Sent

| # | Purpose | Script produced | Used as generated? |
|---|---|---|---|
| 1 | Reset a single AD user's password with error handling | Reset-ADUserPassword.ps1 | Yes, run without modification |
| 2 | Export inactive AD users to CSV with department and manager | Export-InactiveADUsers.ps1 | Yes, run without modification |
| 3 | Colour coded disk space check across a list of computers | Check-DiskSpace.ps1 | Yes, run without modification |

Each script was reviewed in full before it was run in the lab environment. No script was edited before its first run; all three worked as generated against the intended test targets.
