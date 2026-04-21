markdown# AgentForce CPQ Advisor

> AI-powered Salesforce Agentforce agent that helps sales representatives 
> instantly look up CPQ quote status, pricing details, and expiration dates 
> using natural language.

---

## 🎯 Project Purpose

Built to demonstrate production-quality Agentforce implementation skills 
combining deep CPQ domain expertise with modern AI agent architecture.

Sales reps at B2B companies spend significant time checking quote statuses 
across multiple systems. This agent eliminates that friction — a rep simply 
asks "What's the status of Q-DEMO-001?" and gets an instant answer.

---

## 🏗️ Architecture
Sales Rep (Natural Language)
│
▼
Agentforce Agent: CPQ Advisor
│
├── Topic: Quote Assistance
│   ├── Classification: Routes quote-related queries
│   ├── Instructions: Behavioral guardrails
│   └── Action: Get Quote Status
│           └── QuoteStatusAction.cls (@InvocableMethod)
│                   └── Salesforce Quote Object (SOQL)
│
└── Topic: Escalation
└── Routes complex issues to human reps

---

## ✅ What's Built

### Apex Actions
| Class | Purpose | Coverage |
|---|---|---|
| `QuoteStatusAction.cls` | Retrieves Quote status, amount, expiration by quote number | 76% |
| `QuoteStatusActionTest.cls` | 4 test methods — happy path, not found, bulk, empty list | 100% pass |

### Agentforce Configuration
| Component | Details |
|---|---|
| Agent | CPQ Advisor (Service Agent template) |
| Topic | Quote Assistance — classification, scope, instructions |
| Action | Get Quote Status — input/output mappings configured |
| Escalation | Human handoff for complex requests |

### Key Technical Decisions
- **Bulkified SOQL** — Set/Map pattern prevents governor limit violations
- **WITH USER_MODE** — Enforces field-level security on all queries  
- **Safe navigation (?.)** — Prevents null pointer exceptions on Account lookup
- **Separation of concerns** — Input/Output wrapper classes isolate agent contract

---

## 🛠️ Tech Stack

- Salesforce Agentforce (Service Agent)
- Apex (API v66.0)
- SOQL with USER_MODE security
- Salesforce CLI (sf) + VS Code
- Copado-ready metadata structure
- Git/GitHub for version control

---

## 📁 Project Structure
agentforce-cpq-advisor/
├── force-app/main/default/
│   ├── classes/
│   │   ├── QuoteStatusAction.cls
│   │   ├── QuoteStatusAction.cls-meta.xml
│   │   ├── QuoteStatusActionTest.cls
│   │   └── QuoteStatusActionTest.cls-meta.xml
│   └── (additional actions coming)
├── docs/
│   └── architecture/
└── README.md

---

## 🚀 Setup Instructions

### Prerequisites
- Salesforce Developer Edition org with Agentforce licenses
- Salesforce CLI installed
- VS Code with Salesforce Extension Pack

### Deploy
```bash
# Authenticate
sf org login web --alias cpq-advisor-dev

# Deploy Apex classes
sf project deploy start --source-dir force-app/main/default/classes

# Run tests
sf apex run test --class-names QuoteStatusActionTest \
  --code-coverage --result-format human \
  --target-org cpq-advisor-dev --synchronous
```

### Create Test Data
```bash
sf apex run --target-org cpq-advisor-dev --file scripts/create-demo-data.apex
```

---

## 🧪 Test Results
TEST NAME                                OUTCOME   RUNTIME
QuoteStatusActionTest.testBulkRequest    Pass      152ms
QuoteStatusActionTest.testHappypath      Pass       61ms
QuoteStatusActionTest.testNoQuoteFound   Pass       64ms
QuoteStatusActionTest.testSOQLException  Pass       56ms
Pass Rate: 100% | Coverage: 76%

---

## 🎓 Key Learnings

- Agentforce topic routing uses LLM-based classification — 
  prompt engineering of Classification Description directly 
  impacts routing accuracy
- Actions must be registered during subagent creation wizard 
  to properly surface in the LLM runtime context
- Dev org LLM has limitations vs production Einstein — 
  diagnosed using Agent Builder debug panel

---

## 👤 Author

**Nithin Kaveripakam**  
Senior Salesforce Developer / CPQ Engineer  
7x Salesforce Certified | Agentforce Specialist  
[LinkedIn](https://www.linkedin.com/in/nithinkaveripakam) | 
[GitHub](https://github.com/nithink0110-del)

---

## 📌 Roadmap

- [ ] PricingInquiryAction — look up product pricing by SKU
- [ ] RenewalEligibilityAction — check contract renewal windows  
- [ ] LWC embedded chat component on Opportunity record
- [ ] Prompt Templates for consistent response formatting