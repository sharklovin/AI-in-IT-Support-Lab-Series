# Dual Tool Workflow Diagram — Lab 11

This diagram maps how Claude and the lab environment (PowerShell ISE plus Active Directory) were used together across all three scripting tasks.

## Full Workflow Diagram

```
 STAGE                    LAB ENVIRONMENT                     CLAUDE
 ------------------------------------------------------------------------------
 1. Define the task
                            |------------------------->  [Analyst prompts Claude]
                            |                             "Write a script that
                            |                              does X, handles Y,
                            |                              includes comments"
                            |
                            |<-------------------------  Claude returns a full
                            |                             script + explanation
                            |                             of design choices
                            |
 2. Review           [Analyst reads the
                      full script before
                      running it]
                            |
 3. Prepare          [Download script to
                      lab machine, confirm
                      target account/file
                      exists, open ISE with
                      correct privileges]
                            |
 4. Execute          [Run script from
                      PowerShell ISE]
                            |
 5. Verify           [Check console output
                      AND check the actual
                      system state: AD
                      account properties,
                      exported CSV, known
                      disk size]
                            |
 6. Document         [Result and evidence
                      captured for this
                      repository]
```

## Stage by Stage Ownership Table

| Stage | Action | Owner |
|---|---|---|
| 1 | Task defined in plain language | Analyst |
| 2 | Script generated with comments and explanation of design choices | Claude |
| 3 | Script reviewed line by line before use | Analyst |
| 4 | Script downloaded to the lab machine | Analyst |
| 5 | Target account, file, or list prepared and confirmed | Analyst |
| 6 | PowerShell ISE opened with the correct privilege level | Analyst |
| 7 | Script executed | Analyst |
| 8 | Console output reviewed | Analyst |
| 9 | Result independently verified against the real system state | Analyst |
| 10 | Outcome documented | Analyst |

## Reading the Diagram

The pattern here is narrower than a live incident workflow but just as important: **Claude writes the script, the analyst decides whether to trust it and runs it.** Claude never touched the lab environment directly. It had no visibility into the actual Active Directory domain, the target machine, or the real disk space, everything it produced was based purely on the requirements stated in the prompt. Every verification step, checking the account in Active Directory Users and Computers, opening the CSV, confirming the disk size, happened entirely on the analyst's side after execution. This is the core safety property of the workflow: AI can write the code, but it cannot confirm the code did the right thing in the real environment, only the analyst running it can do that.
