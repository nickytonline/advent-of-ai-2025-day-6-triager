# Winter Festival Feedback Triage System 🎄

Automated GitHub issue triage system using [goose](https://github.com/block/goose) to categorize and prioritize festival feedback.

## Overview

This system automatically triages festival feedback issues using AI:
- 🏷️ **Auto-categorizes**: urgent, bug, feature, or question
- ⚡ **Assigns priority**: high, medium, or low
- 💬 **Adds helpful comments**: Explains the triage decision and suggests next steps
- 😊 **Detects sentiment**: positive, neutral, or negative (optional)

## How It Works

1. **Create an issue** (or edit existing one)
2. **GitHub Actions triggers** the workflow
3. **Goose analyzes** the issue using AI
4. **Labels are applied** automatically
5. **Comment is posted** with triage explanation

## Setup Instructions

### 1. Configure GitHub Secret (Required)

Add your OpenRouter API key as a repository secret:

1. Go to Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `OPENROUTER_API_KEY`
4. Value: Your OpenRouter API key
5. Click "Add secret"

### 2. Enable GitHub Actions

Ensure GitHub Actions is enabled:
- Go to Settings → Actions → General
- Under "Actions permissions", select "Allow all actions and reusable workflows"

## Testing the System

### Test with Sample Issues

Create these three test issues to verify the system works:

**Test 1: Urgent Issue**
```
Title: Heating system failing in the Main Tent
Body: The heaters in the Main Tent stopped working tonight. It's very cold and several booths reported no heat. Needs immediate attention.
```
Expected labels: `urgent`, `priority:high`, `sentiment:negative`

**Test 2: Feature Request**
```
Title: Photo booth should print festival-themed frames
Body: Suggestion: Add printed frames with festival graphics so people can take physical souvenirs.
```
Expected labels: `feature`, `priority:low`, `sentiment:positive` or `sentiment:neutral`

**Test 3: Question**
```
Title: Where is the lost & found located?
Body: Visitor found a jacket and wants to return it. Where should they go?
```
Expected labels: `question`, `priority:low`, `sentiment:neutral`

### Watch the Workflow Run

1. Go to the **Actions** tab in your repository
2. Find the "goose-issue-triage" workflow run
3. Click on it to see the logs
4. Verify:
   - ✅ Goose analyzed the issue
   - ✅ Labels were applied
   - ✅ Comment was posted

## Triage Criteria

The system uses these criteria to categorize issues:

### Categories

| Label | When to Use | Examples |
|-------|-------------|----------|
| **urgent** | Safety hazards, critical failures, immediate action needed | "Heating system down", "Fire exit blocked" |
| **bug** | Equipment malfunctions, technical problems | "Photo booth not printing", "Payment system down" |
| **feature** | Enhancement requests, new capabilities | "Add themed frames", "Mobile charging stations" |
| **question** | Information requests, location queries | "Where is lost & found?", "What time does stage open?" |

### Priority Levels

| Label | Criteria | Impact |
|-------|----------|--------|
| **priority:high** | Safety/security, critical systems down, affects many, time-sensitive | Severe disruption |
| **priority:medium** | Partial degradation, specific area affected, has workaround | Moderate disruption |
| **priority:low** | Nice-to-have, general questions, cosmetic issues | Minimal disruption |

See [`.github/TRIAGE_CRITERIA.md`](.github/TRIAGE_CRITERIA.md) for detailed criteria.

## Customizing the Triage Prompt

The triage logic is defined in `.github/triage_prompt.txt`. To customize:

1. Edit `.github/triage_prompt.txt`
2. Modify categories, priorities, or instructions
3. Commit and push changes
4. Next issue will use the updated prompt

**No need to modify the workflow file!**

## Project Structure

```
.github/
├── workflows/
│   └── triage-on-issue.yml      # GitHub Actions workflow (includes auto-label creation)
├── triage_prompt.txt             # Goose triage prompt (easy to customize)
└── TRIAGE_CRITERIA.md            # Detailed triage criteria documentation

prd.md                            # Product Requirements Document
README.md                         # This file
WORKFLOW_SUMMARY.md               # Technical implementation summary
```

## How the Workflow Works

1. **Trigger**: Issue is created or edited
2. **Install goose**: Downloads and installs goose CLI
3. **Configure goose**: Sets up OpenRouter provider
4. **Ensure labels exist**: Automatically creates missing labels (no manual setup needed!)
5. **Load prompt**: Reads `.github/triage_prompt.txt`
6. **Substitute variables**: Replaces `{{ISSUE_TITLE}}` and `{{ISSUE_BODY}}`
7. **Run goose**: Analyzes issue and returns JSON
8. **Parse output**: Extracts labels and comment
9. **Apply labels**: Uses GitHub CLI to add labels
10. **Post comment**: Adds triage explanation to issue

## Troubleshooting

### Labels Not Applied

**Problem**: Workflow runs but labels aren't added

**Solution**: 
- Check workflow logs - the "Ensure Required Labels Exist" step should create them automatically
- Verify the GITHUB_TOKEN has permissions to create labels
- Check workflow logs for errors

### API Key Errors

**Problem**: `OPENROUTER_API_KEY not found`

**Solution**:
- Verify secret is named exactly `OPENROUTER_API_KEY`
- Check it's a repository secret (not environment secret)
- Ensure you have a valid OpenRouter API key

### Workflow Doesn't Trigger

**Problem**: Creating issues doesn't start the workflow

**Solution**:
- Check GitHub Actions is enabled
- Verify workflow file is in `.github/workflows/`
- Check workflow permissions (Settings → Actions)

### JSON Parsing Fails

**Problem**: `ERROR: Could not parse JSON from goose output`

**Solution**:
- Check goose output in workflow logs
- Goose might need clearer instructions in the prompt
- Verify the prompt asks for JSON output only

## Example Output

When the workflow runs successfully, you'll see:

**Issue #1** gets:
- Labels: `urgent`, `priority:high`, `sentiment:negative`
- Comment:
  ```
  🤖 Automated Triage
  
  This is a critical facilities issue affecting attendee comfort and safety. 
  I've labeled it as urgent with high priority. Suggested next steps: 
  (1) dispatch facilities team immediately, (2) check thermostat and power 
  connections, (3) update issue with resolution status.
  
  ---
  This issue was automatically triaged by goose. If the categorization seems 
  incorrect, please adjust the labels or mention a maintainer.
  ```

## License

See repository license file.

## Contributing

Feel free to open issues or submit PRs to improve the triage system!

## Acknowledgments

Built with [goose](https://github.com/block/goose) by Block.
