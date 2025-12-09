# Issue Triage Criteria

This document defines how issues should be categorized and prioritized by the automated triage system.

## Categories (Primary Labels)

### urgent
**When to use:**
- Safety hazards (fire, medical, security threats)
- Critical system failures (heating, power, water, emergency exits)
- Issues blocking event operations
- Situations requiring immediate action (within minutes/hours)

**Examples:**
- "Heating system failing in Main Tent"
- "Fire exit blocked"
- "Medical emergency supplies missing"

### bug
**When to use:**
- Something that should work but doesn't
- Equipment malfunctions
- Technical problems with systems
- Service failures

**Examples:**
- "Photo booth not printing"
- "Payment system down at food court"
- "Microphone not working in auditorium"

### feature
**When to use:**
- Enhancement requests
- New capabilities or improvements
- Suggestions for future events
- Ideas for better experiences

**Examples:**
- "Add festival-themed frames to photo booth"
- "Provide mobile charging stations"
- "Create a festival app"

### question
**When to use:**
- Information requests
- Location/direction queries
- Policy clarifications
- "How do I...?" questions

**Examples:**
- "Where is the lost & found?"
- "What time does the main stage open?"
- "Can I bring outside food?"

## Priority Levels (Secondary Labels)

### priority:high
**Criteria:**
- Safety or security concerns
- Critical systems completely down
- Affects majority of attendees or multiple areas
- Time-sensitive (needs resolution within hours)
- Regulatory/legal compliance issues

**Impact:** Severe disruption to event

### priority:medium
**Criteria:**
- Partial system degradation
- Affects specific area or subset of attendees
- Can be worked around but impacts experience
- Should be resolved within 24 hours

**Impact:** Moderate disruption to experience

### priority:low
**Criteria:**
- Nice-to-have improvements
- General questions
- Cosmetic issues
- Future enhancements
- Can be resolved when resources available

**Impact:** Minimal or no disruption

## Sentiment (Optional Enhancement Labels)

### sentiment:positive
- Compliments, praise
- Positive suggestions
- Appreciation

### sentiment:neutral
- Factual questions
- Technical reports
- Standard requests

### sentiment:negative
- Complaints
- Frustration expressed
- Problems reported with negative tone

## Additional Considerations

### Escalation Triggers
Issues should be escalated (tagged with `needs-attention`) if:
- Multiple related reports received
- Issue persists after initial response
- Involves VIP attendees or sponsors
- Media/PR implications

### Duplicate Detection
When similar issues exist:
- Add `duplicate` label
- Link to original issue in comment
- Close duplicate if appropriate

## Decision Matrix

| Scenario | Category | Priority |
|----------|----------|----------|
| Critical safety issue | urgent | high |
| Equipment completely broken | bug | high/medium |
| Equipment degraded but working | bug | medium |
| Coordinator question | question | medium |
| Attendee question | question | low |
| Enhancement idea | feature | low |
| Multiple complaints same issue | bug/urgent | high |
