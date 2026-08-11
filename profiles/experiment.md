# Experiment profile

Activate this profile for a visual exploration, an alternative technology stack, a demonstration, a prototype, or a feature that has no adoption decision.

This profile implements `P02`, `P03`, `P06`, `P07`, `P08`, and `P12`.

## Experiment contract

Document these items before work starts:

| Field | Question |
| --- | --- |
| Assumption | What will we learn? |
| Owner | Who makes the conclusion? |
| Duration | When will we review it? |
| Budget | What are the maximum time, cost, and infrastructure? |
| Data | Is the data synthetic, anonymized, or real? |
| Surface | Where is the experiment visible? |
| Success | What evidence justifies promotion? |
| Stop | What evidence or deadline causes removal? |

## Isolation

- Use a clearly separate directory, route, environment, or branch.
- Do not silently replace the canonical implementation.
- Do not use an irreversible migration for a simple comparison.
- Do not use secrets or production data by default.
- Identify synthetic data in the interface.
- Use `noindex` for a public surface that is not for search engines.
- Keep experimental dependencies out of the canonical build path when possible.

## Reversibility

- Provide a stop command or procedure.
- Provide an exact list of files, routes, services, and data to remove.
- Do not modify a shared contract without a separate decision.
- Verify a return to the canonical surface.
- Retain artifacts that support learning. Do not retain unnecessary infrastructure.

## Conclusion

On the planned date, explicitly select one action:

- **promote**: Write an ADR, integrate the change into the canonical implementation, and apply product profiles.
- **extend**: Justify a new budget and date.
- **stop**: Remove the experiment and record the conclusion.

An experiment without a conclusion becomes an unmanaged dependency.
