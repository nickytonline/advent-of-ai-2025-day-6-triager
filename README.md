# Festival Feedback System

An automated GitHub-based feedback tracking and triage system for the Winter Festival, powered by AI-driven issue analysis using goose.

## Overview

This repository provides an intelligent issue management system that automatically analyzes, categorizes, and labels GitHub issues submitted by festival coordinators and attendees. When a new issue is created, a GitHub Actions workflow triggers goose to analyze the content and automatically apply appropriate labels and contextual comments.

## Features

- **Automatic Triage**: New issues are automatically analyzed and categorized within 2 minutes of creation
- **Smart Categorization**: Issues are labeled as `urgent`, `feature`, `question`, or `bug`
- **Contextual Comments**: AI-generated helpful comments provide guidance and next steps
- **Issue Templates**: Structured templates guide users to provide relevant information
- **Audit Trail**: Complete workflow logs for transparency and debugging

## How It Works

1. A festival coordinator or attendee creates an issue via GitHub
2. GitHub Actions workflow is triggered on the `issues:opened` event
3. goose analyzes the issue title and body using LLM capabilities
4. The system automatically:
   - Assigns appropriate category labels
   - Determines priority level
   - Posts a helpful, context-aware comment
   - Suggests next steps or relevant information
5. Festival operations team can act on properly labeled and triaged issues

## Labels

The system uses the following core labels:

- **urgent** (🔴 #b60205) - Issues requiring immediate attention
- **feature** (🟢 #0e8a16) - Feature requests and suggestions
- **question** (🔵 #0366d6) - Questions about the festival
- **bug** (🟠 #d93f0b) - Problems or issues that need fixing

Optional priority labels:
- `priority:high`
- `priority:medium`
- `priority:low`

## Setup

### Prerequisites

- GitHub repository with Actions enabled
- goose CLI installed (or installable in CI environment)
- LLM provider API key (e.g., OpenAI, Anthropic, or OpenRouter)

### Configuration

1. **Add API Key as Secret**:
   - Go to your repository Settings → Secrets and variables → Actions
   - Add a new secret named `GOOSE_API_KEY` with your LLM provider API key

2. **Enable GitHub Actions**:
   - The workflow file is located at `.github/workflows/triage-on-issue.yml`
   - It will automatically trigger when new issues are created

3. **Create Issue Templates** (optional):
   - Issue templates are provided in `.github/ISSUE_TEMPLATE/`
   - These guide users to provide structured information

## Example Issues

The system is designed to handle various types of festival feedback:

### Urgent Problem
> **Title**: Heating system failing in the Main Tent  
> **Body**: The heaters in the Main Tent stopped working tonight. It's very cold and several booths reported no heat. Needs immediate attention.
>
> **Expected triage**: `urgent` label, high priority, immediate action suggestions

### Feature Request
> **Title**: Photo booth should print festival-themed frames  
> **Body**: Suggestion: Add printed frames with festival graphics so people can take physical souvenirs.
>
> **Expected triage**: `feature` label, suggestion acknowledgment

### Question
> **Title**: Where is the lost & found located?  
> **Body**: Visitor found a jacket and wants to return it. Where should they go?
>
> **Expected triage**: `question` label, location information

## Success Metrics

- ✅ 100% of new issues receive triage labels and comments within 2 minutes
- ✅ Low false-positive label rate (<10%)
- ✅ Complete audit trail via GitHub Actions logs
- ✅ Demonstrated automated workflow execution

## Architecture

```
GitHub Issues (Input)
      ↓
GitHub Actions Workflow (Trigger)
      ↓
goose CLI (Analysis via LLM)
      ↓
GitHub API (Apply labels & comments)
      ↓
Triaged Issue (Output)
```

## Development

### Testing the Workflow

Create a test issue to see the triage system in action:

```bash
gh issue create --title "Test issue" --body "This is a test of the automated triage system"
```

Watch the workflow run:

```bash
gh run watch
```

### Workflow Logs

View logs for debugging and auditing:
- Navigate to the Actions tab in your repository
- Select the workflow run
- Expand steps to see detailed logs

## Security

- API keys are stored as GitHub Secrets and never exposed in logs
- Workflow runs with least-privilege permissions
- All actions are audited in workflow run logs

## Future Enhancements

Potential additions to the system:
- Multi-stage triage with clarifying questions
- Duplicate issue detection and auto-linking
- Sentiment analysis
- Daily/weekly summary reports
- Slack/Discord notifications
- Analytics dashboard

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]

---

**Created for**: Advent of AI 2025 - Day 6  
**Purpose**: Automated festival feedback management and triage
