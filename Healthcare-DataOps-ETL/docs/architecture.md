# Pipeline Architecture

```text
                 ┌─────────────────────────┐
                 │   Client Source Data    │
                 │  3 fictional hospitals │
                 └────────────┬────────────┘
                              │
                              ▼
                 ┌─────────────────────────┐
                 │       raw schema        │
                 │ Preserves source format │
                 └────────────┬────────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
                    ▼                   ▼
        ┌───────────────────┐   ┌──────────────────────┐
        │ Validation passes │   │ Validation failures  │
        └─────────┬─────────┘   └──────────┬───────────┘
                  │                        │
                  ▼                        ▼
        ┌───────────────────┐   ┌──────────────────────┐
        │  staging.Encounter│   │audit.Validation_Error│
        │ Standardized rows │   │ Rejected row details │
        └─────────┬─────────┘   └──────────────────────┘
                  │
                  ▼
        ┌───────────────────────┐
        │ production.Encounter  │
        │ Final clean dataset   │
        └───────────┬───────────┘
                    │
                    ▼
        ┌───────────────────────┐
        │ Reconciliation + Run  │
        │       Audit Log       │
        └───────────────────────┘