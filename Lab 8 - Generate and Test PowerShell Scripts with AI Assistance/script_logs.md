# Script Logs: AI Assisted PowerShell Scripting for Active Directory Administration

This file records the exact console output and results produced when each script was run in the lab environment. All output below is copied directly from the PowerShell ISE console.

---

## Run 1: Reset-ADUserPassword.ps1

**Environment:** PowerShell ISE, run as Administrator
**Target account:** Jayson419 (Jayson Sule), confirmed beforehand in Active Directory Users and Computers

**Command:**

```
PS C:\Users\Administrator> cd C:\Users\Administrator\Desktop
PS C:\Users\Administrator\Desktop> .\Reset-ADUserPassword.ps1 -Username "Jayson419"
```

**Console output:**

```
Password for user 'Jayson419' has been reset successfully.
Temporary password: )IwY]}?kL-;Q
The user will be required to change this password at next logon.
```

**Result:** Success. The account's password was reset and the "user must change password at next logon" flag was set, matching the script's intended behaviour.

**Screenshots:**
`screenshots/05_navigating_to_directory_prepping_script.png` (before running)
`screenshots/06_password_reset_success.png` (after running)

---

## Run 2: Export-InactiveADUsers.ps1

**Environment:** PowerShell ISE (x86), run from the desktop
**Parameters used:** none (default 90 day threshold, default output path)

**Command:**

```
PS C:\Users\Administrator> cd C:\Users\Administrator\Desktop
PS C:\Users\Administrator\Desktop> .\Export-InactiveADUsers.ps1
```

**Console output:**

```
Finding users who have not logged on since 2026-05-01 (threshold: 90 days)...
Export complete: .\inactive-users.csv
Total inactive users exported: 7
```

**Resulting CSV (`inactive-users.csv`):**

| Username | DisplayName | LastLogonDate | Department | Manager | Enabled |
|---|---|---|---|---|---|
| Choko101 | Otobong Mkpong | 2026-03-28 16:47:11 | | | True |
| Hcode | Hogan Hogan | Never logged on | Sales | | True |
| Jayson419 | Jayson Sule | 2026-03-28 15:54:45 | | | True |
| lab.user1 | lab user1 | Never logged on | | | True |
| lab.user2 | lab user2 | Never logged on | | | True |
| lab.user3 | lab user3 | Never logged on | | | True |
| old.user | old user | Never logged on | | | True |

**Result:** Success. Seven accounts were correctly identified as inactive under the 90 day threshold, including accounts that have never logged on, and each row captured the expected fields. Department and Manager are blank for most rows because those attributes were not populated on the corresponding test accounts in this lab domain, which is expected lab data rather than a script defect.

**Screenshots:**
`screenshots/09_navigated_directory_ran_export_script_success.png` (console output)
`screenshots/10_inactive_users_csv_result.png` (CSV contents)

---

## Run 3: Check-DiskSpace.ps1

**Environment:** PowerShell ISE, run from the desktop
**Input file (`computers.txt`):** one entry, `localhost`

**Command:**

```
PS C:\Users\Administrator> cd C:\Users\Administrator\Desktop
PS C:\Users\Administrator\Desktop> .\Check-DiskSpace.ps1 -ComputerListPath .\computers.txt
```

**Console output:**

```
Checking C: drive free space on 1 computer(s)...

localhost              41.07 GB free  /  59.37 GB total

Done.
```

**Result:** Success. The script correctly queried the local C drive, calculated 41.07 GB free out of 59.37 GB total, and printed the result in green, matching the script's logic since the free space was above the 20 GB threshold.

**Screenshots:**
`screenshots/12_computers_txt_created_before_running.png` (input file)
`screenshots/13_navigated_directory_ran_diskspace_script_success.png` (console output)

---

## Summary of Runs

| # | Script | Target | Result | Verified against |
|---|---|---|---|---|
| 1 | Reset-ADUserPassword.ps1 | Jayson419 (lab account) | Success | Account properties in Active Directory Users and Computers |
| 2 | Export-InactiveADUsers.ps1 | Domain wide query | Success, 7 users exported | Manual review of inactive-users.csv |
| 3 | Check-DiskSpace.ps1 | localhost | Success, correct free space and colour | Known local disk size |

Every script produced a clean exit with no errors on its first run, and every result was independently checked against the source system rather than accepted on the strength of the console message alone.
