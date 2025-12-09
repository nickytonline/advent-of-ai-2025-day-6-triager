# PRD — Festival Feedback System (Day 6)

Date: 2025-12-08 21:24:14
Owner: Festival Coordinator / AI Engineer

---

## 1. Summary / Purpose

Create a GitHub-based feedback tracking and automated triage system for the Winter Festival using GitHub Actions and goose. The system should automatically analyze new issues (the coordinator’s notes), categorize and label them (urgent/feature/question/bug), add helpful comments, and provide a minimal workflow for future automation and analytics.

## 2. Goals & Success Metrics

Goals
- Centralize feedback into a GitHub repository.
- Automatically triage new issues using goose.
- Apply appropriate labels and add contextual comments.
- Create at least 3 triaged issues from coordinator notes (heating, photo booth, lost & found).

Success metrics
- 100% of new issues receive a triage label and comment within 2 minutes of creation.
- At least 3 coordinator notes created as issues and triaged automatically.
- Low false-positive label rate (<10%) after one week of use (measured manually).
- Demonstrated workflow run in GitHub Actions (screenshot/log).

## 3. Stakeholders

- Festival Coordinator — primary user and note provider.
- Attendees — indirect beneficiaries (issues solved faster).
- Engineering / Festival Ops — will act on triaged issues.
- Maintainers — manage goose, secrets, workflows.
- Organizers — want periodic reports/metrics.

## 4. Assumptions & Prerequisites

- goose CLI is installed and authenticated (can run in CI).
- GitHub account and repository access (or GH organization).
- GitHub Actions enabled on the repository.
- LLM provider API key stored in GitHub Secrets (e.g., GOOSE_API_KEY or LLM_API_KEY).
- GitHub CLI (gh) or GitHub MCP extension optionally available locally for initial repo creation.

## 5. Scope

Must-have (MVP)
- Create a GitHub repository for festival feedback.
- Create GitHub Actions workflow that triggers on new issues.
- Use goose in the workflow to:
  - Analyze issue text.
  - Assign a category label (urgent/feature/question/bug).
  - Add a helpful comment tailored to the issue.
- Configure API key as GitHub Secret.
- Create three sample issues from coordinator notes and show they get triaged.

Out-of-scope (for MVP)
- Full analytics dashboard (advanced bonus).
- 24/7 monitoring bot (ultimate challenge).
- Deep integration with external ticketing (optional later).

## 6. Functional Requirements

- FR1: New issue triggers GitHub Actions workflow.
- FR2: Workflow runs goose to analyze title/body and returns:
  - Category label (one of: urgent, feature, question, bug)
  - Priority (optional bonus: high/medium/low)
  - Suggested assignees/tags (optional)
  - Suggested issue links (duplicate detection - bonus)
  - A reason summary in a comment
- FR3: Workflow applies labels and posts a comment on the issue.
- FR4: A GitHub Secret (GOOSE_API_KEY) is present and used securely.
- FR5: Provide at least three issues seeded (heating, photo booth, lost & found).
- FR6: Issue templates created to guide submitters (optional beginner bonus elements).

## 7. Non-Functional Requirements

- NFR1: Triage runs within 2 minutes of issue creation.
- NFR2: Actions run reliably (retries for transient failures).
- NFR3: Logs stored in workflow run for auditing.
- NFR4: Least privilege for secrets; do not expose API key in logs.

## 8. Labels & Metadata

Core labels (MVP):
- urgent
- feature
- question
- bug

Optional extra labels:
- priority:high | priority:medium | priority:low
- status:triaged
- sentiment:positive/neutral/negative
- duplicate

Label color suggestions (optional):
- urgent — #b60205 (red)
- feature — #0e8a16 (green)
- question — #0366d6 (blue)
- bug — #d93f0b (orange)

## 9. User Flow (textual)

1. Coordinator or attendee creates an issue via GitHub web UI or mobile.
2. GitHub triggers the "issue opened" event.
3. GitHub Actions workflow runs:
   - Checks out repo (if needed)
   - Runs goose CLI (or calls goose endpoint) with issue title/body & metadata
   - Receives classification, suggested labels, comment text
   - Applies labels and posts comment
4. Assignees / ops team act on labeled issues.
5. Optionally: daily summary issue or report is generated.

## 10. System Architecture

- GitHub Issues (input)
- GitHub Actions Workflow (trigger)
- Steps:
  - Setup environment
  - Authenticate goose using secret
  - Call goose (CLI or API) to analyze the issue
  - Use GitHub REST API / gh to set labels and post comments
- Data persisted in GitHub Issues and workflow logs.

## 11. Example GitHub Actions Workflow (skeleton)

Place this as .github/workflows/triage-on-issue.yml

```yaml
name: goose-issue-triage
on:
  issues:
    types: [opened]

jobs:
  triage:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Set up Node
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install goose CLI
        run: |
          # Install goose CLI - replace with actual install method for your goose CLI
          # Example if distributed via npm:
          # npm install -g @goose/cli
          # Or if you have a binary, curl it:
          # curl -sSL https://github.com/your-org/goose/releases/latest/download/goose-linux -o ./goose && chmod +x ./goose
          echo "Install step: replace with real goose install"

      - name: Triage issue with goose
        env:
          GOOSE_API_KEY: ${{ secrets.GOOSE_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          ISSUE_NUMBER: ${{ github.event.issue.number }}
          ISSUE_TITLE: ${{ github.event.issue.title }}
          ISSUE_BODY: ${{ github.event.issue.body }}
          REPO: ${{ github.repository }}
        run: |
          echo "Calling goose to triage issue #$ISSUE_NUMBER"
          # Example placeholder: replace with real CLI call
          goose triage --title "$ISSUE_TITLE" --body "$ISSUE_BODY" --output triage_result.json

          LABELS=$(jq -r '.labels | join(",")' triage_result.json)
          COMMENT=$(jq -r '.comment' triage_result.json)

          echo "Labels to add: $LABELS"
          gh issue edit $ISSUE_NUMBER --add-label $LABELS --repo $REPO

          gh issue comment $ISSUE_NUMBER --body "$COMMENT" --repo $REPO
```

Notes:
- Replace install & goose invocation with the actual goose CLI command you use.
- Use jq or other JSON parsing to handle goose output.
- Use secrets.GOOSE_API_KEY for authentication. Keep secrets out of logs.

## 12. Example goose input & expected outputs

Example input (issue):
- Title: "Heating system failing in the Main Tent"
- Body: "The heaters in the Main Tent stopped working tonight. It's very cold and several booths reported no heat. Needs immediate attention."

Expected goose output (json):

```json
{
  "labels": ["urgent"],
  "priority": "high",
  "comment": "Thanks for reporting this — this looks like an urgent facilities issue. I've labeled it 'urgent' and set priority:high. Suggested next steps: (1) dispatch facilities team, (2) check thermostat and power to heaters, (3) update issue with actions taken. If you can provide vendor contact or a photo, please add it."
}
```

## 13. Seed issues (Coordinator's Notes)

Create these as issues to demonstrate the system:

1) Urgent Problem — Heating system
- Title: Heating system failing in the Main Tent
- Body: The heaters in the Main Tent stopped working tonight. It's very cold and several booths reported no heat. Needs immediate attention.

2) Feature Request — Photo booth suggestion
- Title: Photo booth should print festival-themed frames
- Body: Suggestion: Add printed frames with festival graphics so people can take physical souvenirs.

3) Question — Lost and found location
- Title: Where is the lost & found located?
- Body: Visitor found a jacket and wants to return it. Where should they go?

## 14. Issue Templates

Add .github/ISSUE_TEMPLATE/ files to guide submissions (e.g., bug_report.md, feature_request.md, question.md). Example frontmatter for bug_report.md:

```markdown
---
name: Bug / Urgent issue
about: For problems that require immediate attention
title: ''
labels: bug, urgent
assignees: ''
---

**Describe the issue**
<!-- short description -->

**Location / Context**
<!-- where and when -->

**Steps to reproduce**
<!-- optional -->

**Contact / photos**
<!-- add any useful info -->
```

## 15. Acceptance Criteria

- [ ] Repository created and accessible (link provided).
- [ ] GitHub Actions workflow present and triggers on issue creation.
- [ ] Workflow runs goose and applies correct labels & comments.
- [ ] GOOSE_API_KEY (or LLM API key) stored as GitHub Secret.
- [ ] 3 seed issues created and successfully triaged (evidence: screenshot or link).
- [ ] README documents how to run and how goose is used in the workflow.

## 16. Testing Plan

- Unit test: Simulate an issues webhook with a test action dispatch and verify labels/comments applied.
- End-to-end: Create the 3 seed issues in the repo and validate the Actions run and triage results.
- Edge cases:
  - Long issue bodies
  - Non-English text
  - Missing API key (workflow should fail gracefully and post a comment to maintainers)

## 17. Timeline & Milestones

- Day 0: Repo creation, basic README, configure secrets.
- Day 1: Implement GitHub Actions workflow + basic goose invocation.
- Day 2: Create issue templates, seed the 3 sample issues, test triage.
- Day 3: Add priority labels and emoji in comments (beginner bonus).
- Day 4-5: Implement intermediate bonuses (daily summary, sentiment) if desired.

## 18. Risks & Mitigations

- Exposing API keys in logs — mitigation: do not echo sensitive env variables and use GitHub secrets.
- goose CLI differences across OS — mitigation: standardize runner (ubuntu-latest) and include install steps.
- Misclassification — mitigation: add manual override and a status:triaged label; log errors for retraining.

## 19. Bonus Features (pick what you want)

Beginner:
- Add priority:high/medium/low
- Add emoji in comments
- Add issue templates and welcome message for first-time contributors

Intermediate:
- Trigger on issue comments and let goose respond
- Daily summary issue of new feedback
- Sentiment analysis label
- Slack/Discord notifications (via webhook)

Advanced:
- Multi-stage triage with clarifying questions (requires multi-step Actions or checks)
- Smart duplicate detection and auto-linking
- Weekly report generation

Ultimate:
- Full automated routing and analytics dashboard
- 24/7 bot monitoring (requires hosting and more advanced security)

## 20. Deliverables

- Public GitHub repo (or private with link)
- .github/workflows/triage-on-issue.yml
- .github/ISSUE_TEMPLATE/*.md
- README with setup instructions, secrets needed, sample issues and screenshots
- Evidence of triage runs (workflow run screenshot or link) and the three triaged issues

## 21. Next steps / How I can help

Tell me which of these you want me to do next:
- Create the repository structure and files (README, workflow, issue templates) in this project (I can create files here).
- Generate the final GitHub Actions workflow YAML with exact goose install/CLI commands if you tell me how goose is installed (npm package name, binary URL, or pip package).
- Create the three seed issues automatically (requires GH token or I can provide you curl/gh commands).
- Add bonus features (pick from the list above).
- Or I can produce a ready-to-copy README + workflow + templates you can paste into your repo.

Please confirm:
- Repo name (suggestion: winter-festival-feedback)
- Public or private repo?
- Which LLM provider / goose setup method to use (e.g., Claude Sonnet via OpenRouter; or other). Provide the exact CLI install method for goose if available, or say “I’ll tell you how to install” and I’ll include multiple options.
- Which bonus features (if any) you want included.

Would you like me to generate the workflow and files now (I can create the files locally in this project and show diffs / contents)?
