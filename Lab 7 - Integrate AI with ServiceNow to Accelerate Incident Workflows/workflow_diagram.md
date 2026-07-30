# Dual Tool Workflow Diagram — Lab 10

This diagram maps the full lifecycle of INC0010010 across both tools, showing exactly which system was active at each stage and who (analyst or AI) drove the action.

## Full Lifecycle Diagram

```
 STAGE                    SERVICENOW                         CLAUDE
 ------------------------------------------------------------------------------
 1. Intake          [Incident created]
                     INC0010010, New
                     "Cannot print to
                     HP-LJ-3F-01"
                            |
                            |------------------------->  [Analyst prompts Claude]
                            |                             "Give me diagnostic
                            |                              questions + first steps"
                            |
                            |<-------------------------  Claude returns 3 questions
                            |                             + 3 first steps
                            |
 2. First call      [Analyst calls user,
                     asks Claude's
                     questions]
                            |
 3. Finding         User confirms: offline
    isolated        for them only, floor
                     is unaffected
                            |
                            |------------------------->  [Analyst prompts Claude]
                            |                             "Draft a work note for
                            |                              this finding"
                            |
                            |<-------------------------  Claude drafts work note
                            |                             (no live connector,
                            |                              text returned for
                            |                              manual paste)
                            |
 4. Note posted     [Analyst pastes and
                     posts Work Note]
                     Activity log updated
                            |
                            |------------------------->  [Analyst prompts Claude]
                            |                             "What's the most likely
                            |                              cause, what next?"
                            |
                            |<-------------------------  Claude reasons through
                            |                             ranked hypothesis list
                            |
 5. Investigation   [Analyst tests port/IP,
                     spooler, and driver
                     on user's machine]
                            |
                            |------------------------->  [Analyst prompts Claude]
                            |                             "Draft a work note for
                            |                              this investigation
                            |                              update"
                            |
                            |<-------------------------  Claude drafts work note
                            |
 6. State change    [Analyst pastes note,
                     sets State: In Progress]
                     Activity log updated
                            |
 7. Fix applied     [Analyst removes and
                     re-adds printer,
                     confirms fix with
                     user]
                            |
                            |------------------------->  [Analyst prompts Claude]
                            |                             "Draft a resolution
                            |                              note" (issue, root
                            |                              cause, fix, verified)
                            |
                            |<-------------------------  Claude drafts
                            |                             resolution note
                            |
 8. Closure         [Analyst pastes note,
                     sets State: Resolved]
                     Activity log updated,
                     full lifecycle
                     captured
```

## Stage by Stage Ownership Table

| Stage | Action | Owner |
|---|---|---|
| 1 | Incident created and assigned | Analyst (ServiceNow) |
| 2 | Diagnostic questions and first steps generated | Claude |
| 3 | First call, questions asked, evidence gathered | Analyst |
| 4 | Work note text drafted | Claude |
| 5 | Work note reviewed and posted | Analyst |
| 6 | Root cause hypothesis and next checks generated | Claude |
| 7 | Physical/technical investigation carried out | Analyst |
| 8 | Investigation update note drafted | Claude |
| 9 | Note reviewed, posted, state changed to In Progress | Analyst |
| 10 | Fix (printer removed and re-added) carried out and tested | Analyst |
| 11 | Fix confirmed with user | Analyst |
| 12 | Resolution note drafted | Claude |
| 13 | Note reviewed, posted, state changed to Resolved | Analyst |

## Reading the Diagram

The pattern that repeats through the whole ticket is: **Claude drafts, the analyst decides.** Every arrow going into Claude is a request for a question set, a hypothesis, or a piece of writing. Every arrow coming out of Claude lands back with the analyst for review before anything changes in ServiceNow. Claude never gathered evidence directly from the user, never touched the affected machine, and never posted anything to the ticket on its own, all of that stayed with the analyst throughout the lifecycle.
