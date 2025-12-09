# Workflow Implementation Summary

## ✅ Completed Implementation

Your GitHub Actions workflow is now fully configured to automatically triage festival feedback issues using goose.

## What Was Added

### 1. Priority Criteria Definition (`.github/TRIAGE_CRITERIA.md`)

**Categories:**
- **urgent**: Safety hazards, critical system failures, immediate action needed
- **bug**: Equipment malfunctions, technical problems  
- **feature**: Enhancement requests, new capabilities
- **question**: Information requests, location queries

**Priority Levels:**
- **priority:high**: Safety/security, critical failures, affects many, time-sensitive
- **priority:medium**: Partial degradation, specific area, has workaround
- **priority:low**: Nice-to-have, general questions, cosmetic issues

**Optional Sentiment:**
- **sentiment:positive**: Compliments, appreciation
- **sentiment:neutral**: Factual reports
- **sentiment:negative**: Complaints, frustration

### 2. Complete Workflow (`.github/workflows/triage-on-issue.yml`)

The workflow now includes:

**Trigger Events:**
- ✅ Issue opened
- ✅ Issue edited

**Triage Process:**
1. **Goose Analysis**: Runs goose with detailed triage criteria embedded in the prompt
2. **JSON Parsing**: Extracts categorization and comment from goose's response
3. **Label Application**: Applies labels (category + priority + optional sentiment) via GitHub CLI
4. **Comment Posting**: Posts goose's analysis as a comment on the issue

**Output Format:**
```json
{
  "labels": ["category", "priority:level", "sentiment:type"],
  "comment": "Professional explanation with next steps"
}
```

## How It Works

### When an issue is created or edited:

1. **GitHub Actions triggers** the workflow
2. **Goose is installed** and configured with OpenRouter
3. **Triage prompt is created** with:
   - Full criteria definitions
   - Issue title and body
   - Required JSON output format
4. **Goose analyzes** the issue and returns structured JSON
5. **Workflow parses** the JSON to extract labels and comment
6. **Labels are applied** automatically to the issue
7. **Comment is posted** explaining the triage decision

### Example Flow

**Input Issue:**
```
Title: Heating system failing in Main Tent
Body: The heaters stopped working. Very cold, needs immediate attention.
```

**Goose Analysis:**
```json
{
  "labels": ["urgent", "priority:high", "sentiment:negative"],
  "comment": "This is a critical facilities issue affecting attendee comfort and safety. I've labeled it as urgent with high priority. Suggested next steps: (1) dispatch facilities team immediately, (2) check thermostat and power connections, (3) update issue with resolution status."
}
```

**Result on GitHub:**
- Labels: `urgent`, `priority:high`, `sentiment:negative`
- Comment posted with 🤖 header and explanation

## Priority Criteria Examples

| Issue Type | Category | Priority | Reasoning |
|------------|----------|----------|-----------|
| Heating system down | urgent | high | Safety/comfort, affects many, immediate |
| Photo booth not printing | bug | medium | Equipment failure, specific area |
| Add themed frames | feature | low | Enhancement, future improvement |
| Where's lost & found? | question | low | Information request, non-urgent |
| Fire exit blocked | urgent | high | Safety hazard, immediate danger |

## What You Need To Test

### Before Testing:
1. **Create the required labels** in your GitHub repository:
   ```
   urgent, bug, feature, question
   priority:high, priority:medium, priority:low
   sentiment:positive, sentiment:neutral, sentiment:negative
   ```

2. **Verify GitHub Secret** is set:
   - `OPENROUTER_API_KEY` must be configured in repo settings

### To Test:
1. Create a test issue (e.g., one of the three seed issues from the PRD)
2. Watch the Actions tab for the workflow run
3. Verify labels are applied correctly
4. Check that goose's comment appears on the issue

### Expected Test Cases (from PRD):

**Test 1: Heating System (Urgent)**
- Title: "Heating system failing in the Main Tent"
- Expected: `urgent`, `priority:high`, `sentiment:negative`

**Test 2: Photo Booth (Feature)**
- Title: "Photo booth should print festival-themed frames"  
- Expected: `feature`, `priority:low`, `sentiment:positive` or `neutral`

**Test 3: Lost & Found (Question)**
- Title: "Where is the lost & found located?"
- Expected: `question`, `priority:low`, `sentiment:neutral`

## Debugging

If the workflow fails, check:
1. **Actions logs** - Full goose output is logged
2. **JSON parsing** - Ensure goose returns valid JSON
3. **Label names** - Must match exactly (case-sensitive)
4. **API key** - OpenRouter secret must be valid
5. **Permissions** - Workflow has `issues: write` permission ✓

## Next Steps

- [ ] Create labels in GitHub repository (or use script below)
- [ ] Create the three seed issues to test
- [ ] Monitor first workflow runs
- [ ] Adjust triage criteria if needed based on results
- [ ] Consider adding issue templates (`.github/ISSUE_TEMPLATE/`)

## Quick Label Creation Script

Run this in your terminal (requires `gh` CLI and repo access):

```bash
REPO="your-username/advent-of-ai-2025-day-6-triager"

# Category labels
gh label create urgent --color b60205 --description "Safety hazards, critical failures" --repo $REPO
gh label create bug --color d93f0b --description "Equipment malfunctions, technical problems" --repo $REPO
gh label create feature --color 0e8a16 --description "Enhancement requests, new capabilities" --repo $REPO
gh label create question --color 0366d6 --description "Information requests, location queries" --repo $REPO

# Priority labels
gh label create priority:high --color d93f0b --description "Critical, affects many, time-sensitive" --repo $REPO
gh label create priority:medium --color fbca04 --description "Moderate impact, resolve within 24h" --repo $REPO
gh label create priority:low --color 0e8a16 --description "Low impact, nice-to-have" --repo $REPO

# Sentiment labels (optional)
gh label create sentiment:positive --color 0e8a16 --description "Positive feedback, appreciation" --repo $REPO
gh label create sentiment:neutral --color d4c5f9 --description "Neutral, factual reports" --repo $REPO
gh label create sentiment:negative --color b60205 --description "Complaints, frustration" --repo $REPO
```

## Files Modified/Created

- ✅ `.github/workflows/triage-on-issue.yml` - Complete workflow with goose triage
- ✅ `.github/TRIAGE_CRITERIA.md` - Detailed priority and category definitions
- ✅ `WORKFLOW_SUMMARY.md` - This file

Ready to test! 🚀
