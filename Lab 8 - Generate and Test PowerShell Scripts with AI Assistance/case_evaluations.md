# Case Evaluations — Lab 11: AI Assisted PowerShell Scripting for Active Directory Administration

This file evaluates how well Claude performed on each of the three scripting tasks in this lab, judged against correctness, safety, and how much editing was needed before the script could be trusted to run.

---

## Evaluation 1: Reset-ADUserPassword.ps1

**Prompt purpose:** Generate a script that resets one AD user's password to a temporary value, forces a change at next logon, and handles a user not found scenario cleanly.

**Evaluation:**

The script correctly used `Get-ADUser` to verify the account exists before attempting any password change, and specifically caught `ADIdentityNotFoundException` to produce a clear, specific error rather than letting a generic AD exception surface. The password reset itself used `Set-ADAccountPassword` with a `SecureString`, which is the correct, current approach rather than a deprecated cmdlet. The `ChangePasswordAtLogon` flag was set as a separate, explicit step, matching exactly what was asked for.

One point worth flagging for anyone reusing this script: it prints the generated temporary password directly to the console in plain text. This is functionally correct and matches the prompt's requirement to communicate the password, but in a real production environment this would need a safer delivery mechanism (a secure channel to the user, not a console that may be logged or screen shared). This is exactly the kind of operational judgment call that sits with the analyst, not something to expect the AI to have solved unprompted.

**Rating:** Correct, safe to review, and ran successfully on the first attempt. The console password output is a reasonable default for a lab script but would need review before any production use.

---

## Evaluation 2: Export-InactiveADUsers.ps1

**Prompt purpose:** Generate a script that finds AD users inactive for 90 days and exports them to CSV with username, last logon date, department, and manager, plus a total count.

**Evaluation:**

This was the most technically involved of the three scripts, and Claude's choice of `LastLogonTimestamp` over `LastLogon` was the correct call for a domain wide inactivity check, along with a clear explanation of the replication lag tradeoff that comes with it. The script also correctly handled two edge cases that were not explicitly asked for: accounts that have never logged on (`LastLogonTimestamp` is null) were still included and labelled "Never logged on" rather than dropped or erroring, and the Manager attribute, which is stored as a distinguished name, was resolved to a readable display name with its own error handling in case a manager reference was stale.

Running the script produced a clean export of 7 users with a matching line count message, and the CSV content lined up correctly with the accounts visible in the lab domain.

**Rating:** Strong, defensively written script that anticipated real world data messiness (missing manager links, never logged on accounts) without being asked to. Ran correctly on the first attempt.

---

## Evaluation 3: Check-DiskSpace.ps1

**Prompt purpose:** Generate a script that reads a computer list from a text file, checks C drive free space on each, and prints colour coded output using the specified thresholds.

**Evaluation:**

The script correctly used `Get-CimInstance`, the modern replacement for `Get-WmiObject`, and applied the exact thresholds requested (red below 10 GB, yellow below 20 GB, green at or above 20 GB) as variables at the top of the script, making them easy to adjust later without touching the query logic. Blank lines in the input file are trimmed and skipped, which is a small but practical detail that avoids a wasted query against an empty string. Unreachable computers are caught per machine and printed in a distinct colour with the actual error message, so a genuinely low disk reading is never confused with a machine that simply could not be reached.

Run against a single entry list (`localhost`), the script correctly reported 41.07 GB free of 59.37 GB total in green, matching the expected threshold logic.

**Rating:** Clean, correctly thresholded, and defensive against unreachable machines. Ran correctly on the first attempt with no editing required.

---

## Overall Assessment

Across all three scripts, Claude produced working, well structured PowerShell on the first attempt in every case, with no script needing correction before it was run. The consistent strength was defensive handling of edge cases, missing data, unreachable machines, accounts that have never logged on, that were not always explicitly asked for but were exactly the kind of edge case a script like this needs to handle to be trustworthy in a real environment.

The consistent responsibility that stayed with the analyst was validation and safe operation: reviewing each script before running it, running the password reset only against a known test account with the correct elevated privileges, and independently checking every result (account properties, CSV contents, known disk size) rather than trusting a success message alone. AI assisted scripting sped up the writing stage substantially in this lab, it did not reduce the need for the analyst to verify behaviour before and after execution.
