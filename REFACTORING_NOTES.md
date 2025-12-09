# Refactoring Notes - Externalized Configuration Files

**Date:** December 8, 2025, 23:01  
**Change:** Extracted inline scripts and messages into separate files for easier customization

---

## 🎯 Why This Change?

**Before:** The first-time contributor detection logic and welcome message were hardcoded inline in the GitHub Actions workflow YAML file.

**Problem:** 
- Hard to find and edit (buried in workflow file)
- Requires editing YAML (error-prone)
- Mixed infrastructure with content
- Not obvious to non-technical users

**After:** Extracted to separate, clearly-named files in `.github/` directory.

**Benefits:**
- ✅ Easy to find and edit
- ✅ No YAML knowledge needed to customize messages
- ✅ Clear separation of concerns
- ✅ Better maintainability
- ✅ Can be edited independently without touching workflow

---

## 📁 New Files Created

### 1. `.github/check_first_time_contributor.sh`
**Purpose:** Contains the logic to detect first-time contributors

**How it works:**
- Takes two arguments: `AUTHOR` and `REPO`
- Queries GitHub API for user's issues and PRs
- Returns exit code 0 (success) if first-time, 1 otherwise
- Prints debug information to logs

**When to customize:**
- Change definition of "first-time" (e.g., first 3 issues instead of 1)
- Add different criteria (e.g., check for comments)
- Modify detection logic

**Example customization - Consider first 3 issues as "new":**
```bash
# Change this line:
if [ "$ISSUE_COUNT" -eq 1 ] && [ "$PR_COUNT" -eq 0 ]; then
# To this:
if [ "$ISSUE_COUNT" -le 3 ] && [ "$PR_COUNT" -eq 0 ]; then
```

---

### 2. `.github/WELCOME_MESSAGE.md`
**Purpose:** Contains the welcome message template for first-time contributors

**Template variable:**
- `{{AUTHOR}}` - Gets replaced with the GitHub username

**How it's used:**
- Read by the workflow
- `{{AUTHOR}}` is substituted with actual username
- Posted as an issue comment

**When to customize:**
- Change the welcome message tone
- Add project-specific instructions
- Include links to documentation
- Add emoji or formatting

**Example customization:**
```markdown
👋 **Welcome @{{AUTHOR}}!**

Thanks for your first contribution to the Winter Festival! 🎉

Here's what happens next:
1. Our AI will automatically categorize your issue
2. A team member will review within 24 hours
3. You'll get updates via email

**Need help?** Check our [FAQ](https://example.com/faq) or ask in comments!

---
*Automated welcome for new contributors*
```

---

## 🔧 Workflow Changes

### Before (Inline):
```yaml
- name: Check if First-Time Contributor
  run: |
    echo "Checking if $AUTHOR is a first-time contributor..."
    ISSUE_COUNT=$(gh issue list --repo "$REPO" --author "$AUTHOR" ...)
    PR_COUNT=$(gh pr list --repo "$REPO" --author "$AUTHOR" ...)
    if [ "$ISSUE_COUNT" -eq 1 ] && [ "$PR_COUNT" -eq 0 ]; then
      echo "is_first_time=true" >> $GITHUB_OUTPUT
    else
      echo "is_first_time=false" >> $GITHUB_OUTPUT
    fi

- name: Welcome First-Time Contributors
  run: |
    WELCOME_MESSAGE="👋 **Welcome to the Winter Festival...[20 lines]..."
    gh issue comment $ISSUE_NUMBER --body "$WELCOME_MESSAGE"
```

### After (External Files):
```yaml
- name: Check if First-Time Contributor
  run: |
    chmod +x .github/check_first_time_contributor.sh
    if .github/check_first_time_contributor.sh "$AUTHOR" "$REPO"; then
      echo "is_first_time=true" >> $GITHUB_OUTPUT
    else
      echo "is_first_time=false" >> $GITHUB_OUTPUT
    fi

- name: Welcome First-Time Contributors
  run: |
    WELCOME_MESSAGE=$(cat .github/WELCOME_MESSAGE.md | sed "s/{{AUTHOR}}/${AUTHOR}/g")
    gh issue comment $ISSUE_NUMBER --body "$WELCOME_MESSAGE"
```

**Much cleaner!** 🎉

---

## 📚 Documentation Updates

Updated `README.md` with new "Customization" section covering:

1. **Customizing the Triage Prompt** (existing)
2. **Customizing the Welcome Message** (NEW)
3. **Customizing First-Time Detection Logic** (NEW)

Added to **Project Structure** section:
- `.github/WELCOME_MESSAGE.md`
- `.github/check_first_time_contributor.sh`

---

## ✅ Testing Checklist

Before deploying, verify:

- [ ] `.github/check_first_time_contributor.sh` has execute permissions (handled by `chmod +x` in workflow)
- [ ] `.github/WELCOME_MESSAGE.md` contains `{{AUTHOR}}` placeholder
- [ ] Workflow references correct file paths
- [ ] Files are committed to repository
- [ ] Test with a first-time contributor (first seed issue)
- [ ] Verify message substitution works correctly

---

## 🎓 Design Patterns Used

### Separation of Concerns
- **Infrastructure:** GitHub Actions workflow orchestration
- **Logic:** Bash script for detection algorithm  
- **Content:** Markdown file for user-facing message

### Template Pattern
- `{{AUTHOR}}` placeholder in welcome message
- `{{ISSUE_TITLE}}` and `{{ISSUE_BODY}}` in triage prompt
- Allows dynamic content without code changes

### Configuration as Code
- All customizable elements in version-controlled files
- Changes tracked in git history
- Easy to review and roll back

---

## 💡 Future Enhancements

Easy additions now that we have this structure:

1. **Multiple welcome messages** based on issue type
   - `WELCOME_MESSAGE_BUG.md`
   - `WELCOME_MESSAGE_FEATURE.md`
   - Script chooses which one to use

2. **Localization support**
   - `WELCOME_MESSAGE_en.md`
   - `WELCOME_MESSAGE_es.md`
   - Detect user language preference

3. **A/B testing**
   - Randomly select from multiple message variants
   - Track which gets better engagement

4. **Conditional sections**
   - Add template variables like `{{IF_URGENT}}`
   - Script includes/excludes sections based on triage results

---

## 📊 Impact Summary

| Aspect | Before | After |
|--------|--------|-------|
| **Lines in workflow** | ~30 lines inline | ~10 lines (calls external files) |
| **Ease of editing** | Need YAML skills | Plain text/markdown editing |
| **Discoverability** | Hidden in workflow | Clear filenames in `.github/` |
| **Reusability** | N/A | Script could be reused in other workflows |
| **Maintainability** | 3/10 | 9/10 |

---

## 🚀 Deployment

Files ready to commit:

```bash
git add .github/check_first_time_contributor.sh
git add .github/WELCOME_MESSAGE.md
git add .github/workflows/triage-on-issue.yml
git add README.md
git add REFACTORING_NOTES.md
git commit -m "refactor: Extract first-time contributor logic into separate files"
git push
```

---

**Status: Ready for Production** ✅

All refactoring complete. The system is now more maintainable and user-friendly!
