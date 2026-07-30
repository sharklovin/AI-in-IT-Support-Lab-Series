# Case Evaluations — Lab 10: AI Augmented ServiceNow Incident Workflow

This file evaluates how well Claude performed at each stage of INC0010010, judged against accuracy, usefulness, and appropriateness for a live support ticket.

---

## Evaluation 1: Initial Triage Questions and First Steps

**Prompt purpose:** Get a fast, structured starting point for the very first call with the user.

**Evaluation:**

Strong output. The three diagnostic questions correctly targeted the two variables that matter most in a printer offline ticket: scope (is this one user or many) and recent change (what altered on the machine or network). The three first steps followed a logical order, network reachability first, then server side queue, then local spooler, which mirrors how an experienced analyst would triage the same ticket. Nothing in the output required correction before use.

**Rating:** Accurate, well ordered, immediately usable. No hallucinated detail; every suggestion was a standard, verifiable troubleshooting action.

---

## Evaluation 2: Work Note Drafting, Isolated User Finding

**Prompt purpose:** Turn a verbal finding from the user into a properly worded ticket entry.

**Evaluation:**

The drafted note accurately reflected the finding as reported (offline for one user, working for a colleague on the same floor) and correctly reasoned that this rules out a printer-wide or network-wide fault. Claude was transparent that it could not post to ServiceNow directly, since no live connector was active in the session, and it offered the text as a ready to paste block instead of pretending to have completed an action it could not perform. This transparency is important: an AI tool that silently claims to have done something it did not do would break trust in the workflow immediately.

**Rating:** Accurate and honest about its own limitations. The analyst still had to manually post the note, which is the correct control point.

---

## Evaluation 3: Root Cause Reasoning

**Prompt purpose:** Interpret the isolated user finding and produce a prioritized next action list.

**Evaluation:**

This is the most technically demanding prompt in the sequence, and Claude handled it well. The reasoning correctly eliminated the printer, network, and print server as causes once the isolated user detail was given, and it produced a ranked, testable checklist (port/IP mismatch, spooler fault, local network/profile issue) rather than a vague list of possibilities. Each step included the specific Windows path or command needed to check it, which is exactly the level of detail a Tier 1 analyst needs without having to go look it up separately.

One point worth flagging for a new analyst: Claude's most likely cause (port/IP mismatch) was a reasonable statistical guess, but the actual confirmed root cause later turned out to be a corrupted driver. This is a useful teaching moment. AI reasoning on likely cause is a starting hypothesis to test, not a diagnosis to accept unverified. The analyst still had to test and confirm before writing up the true root cause.

**Rating:** Strong structured reasoning, correctly caveated as "most likely," and this lab is a good demonstration of why the analyst must verify rather than assume the AI's top guess is correct.

---

## Evaluation 4: Work Note Drafting, Investigation Update

**Prompt purpose:** Document the planned fix before it was carried out.

**Evaluation:**

The note is clearly structured (Investigation Update, Root Cause suspected, Next Step, Status) and uses hedged, professional language for the still unconfirmed root cause ("suspected"), which is exactly correct at this stage of the ticket, nothing was confirmed yet. This is a good example of Claude matching its language precision to the actual state of the investigation rather than overstating certainty.

**Rating:** Professionally worded, appropriately hedged, ready to post with no editing required.

---

## Evaluation 5: Resolution Note Drafting

**Prompt purpose:** Close out the ticket with a clear record of issue, root cause, fix, and verification.

**Evaluation:**

The resolution note is complete and follows a standard ITSM resolution format: issue, root cause, resolution, verification, status. Claude again correctly disclosed that it had no live ServiceNow connection in this session rather than fabricating a confirmation of posting. All facts in the note came directly from what the analyst supplied in the prompt (root cause, fix action, confirmation by user), Claude did not invent or add any unverified detail.

**Rating:** Accurate, complete, and correctly scoped to only the facts provided by the analyst.

---

## Overall Assessment

Across all five prompts, Claude performed reliably at two tasks: generating a structured triage checklist and producing clean, professional ServiceNow documentation. It was measurably less reliable, though still useful, at predicting the exact root cause, which is expected since Claude cannot see the machine, run diagnostics, or observe symptoms directly; it can only reason from what the analyst describes.

The workflow demonstrated in this lab is sound: use Claude to accelerate the parts of the ticket that are about structuring information (questions to ask, notes to write, plausible causes to test), and keep the analyst fully responsible for the parts that require direct observation, hands on action, and judgment about the user (identity checks, escalation, fix verification, and communication tone). No output from Claude was posted to the ticket without analyst review, and no action was taken based on AI output alone without independent verification.
