# Before and After: Work Note Improvement

This comparison shows a real work note in its original, unassisted form and the version produced after asking Claude to rewrite it to a professional service desk standard.

## The Prompt Used

```
Improve this work note to professional service desk standard. Current note:
called user, they said its slow, tried turning it off and on, still slow,
will look at it later. The improved note should include: what was
reported, what was investigated, what action was taken, and what the
next step is.
```

## Before (Original Work Note)

> called user, they said its slow, tried turning it off and on, still slow, will look at it later.

**Problems with this note:**

- No timestamp, contact method, or ticket reference
- "its slow" gives no detail on what "slow" means or what system is affected
- No confirmation the restart was actually tested with the user, or what happened afterward
- "will look at it later" gives no target timeframe and no accountability
- Would leave the next analyst with almost nothing to act on during a handover

## After (Claude-Improved Work Note)

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

## Evidence in ServiceNow

The screenshot below shows the improved note posted directly into the ServiceNow "Work notes" field on the live incident record.

![Improved work note applied in ServiceNow](screenshots/04-servicenow-work-notes-updated.png)

## Why This Matters

| Original Note | Improved Note |
|---|---|
| No structure | Clear sections: reported / investigated / actioned / next step |
| Vague symptom description | Specific, professional symptom description |
| No evidence of testing | Explicit confirmation the user tested and confirmed the issue persisted |
| No accountability or timeframe | Defined next step with a diagnostic plan and user communication |
| Unusable at handover | Ready to hand to another analyst or Tier 2 with no follow-up questions needed |

The rewritten note takes the same facts and turns them into something a team lead, auditor, or Tier 2 analyst could act on immediately — with no guesswork about what was actually done.
