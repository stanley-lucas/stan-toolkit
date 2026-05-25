#!/bin/bash
# harden.sh — Apply security hardening to a GitHub repo
# Usage: ./harden.sh <owner/repo>
#
# Applies:
#   - Branch ruleset on main/master: no force push, no deletion, require PR (0 approvals)
#   - Secret scanning + push protection
#   - Dependabot vulnerability alerts

set -e

if [ -z "$1" ]; then
  echo "Usage: ./harden.sh <owner/repo>"
  echo "Example: ./harden.sh stanley-lucas/my-new-project"
  exit 1
fi

REPO="$1"

echo "Hardening $REPO..."

echo ""
echo "→ Branch ruleset (protect main/master)"
gh api --method POST "/repos/$REPO/rulesets" --input - <<'EOF'
{
  "name": "protect-main",
  "target": "branch",
  "enforcement": "active",
  "conditions": {
    "ref_name": {
      "include": ["refs/heads/main", "refs/heads/master"],
      "exclude": []
    }
  },
  "rules": [
    { "type": "deletion" },
    { "type": "non_fast_forward" },
    {
      "type": "pull_request",
      "parameters": {
        "required_approving_review_count": 0,
        "dismiss_stale_reviews_on_push": false,
        "require_code_owner_review": false,
        "require_last_push_approval": false,
        "required_review_thread_resolution": false
      }
    }
  ],
  "bypass_actors": [
    {
      "actor_id": 5,
      "actor_type": "RepositoryRole",
      "bypass_mode": "always"
    }
  ]
}
EOF

echo ""
echo "→ Secret scanning + push protection"
RESULT=$(gh api --method PATCH "/repos/$REPO" --input - <<'EOF'
{
  "security_and_analysis": {
    "secret_scanning": { "status": "enabled" },
    "secret_scanning_push_protection": { "status": "enabled" }
  }
}
EOF
)
SECRET=$(echo "$RESULT" | jq -r '.security_and_analysis.secret_scanning.status')
PUSH=$(echo "$RESULT" | jq -r '.security_and_analysis.secret_scanning_push_protection.status')
echo "   secret_scanning: $SECRET | push_protection: $PUSH"

echo ""
echo "→ Dependabot vulnerability alerts"
gh api --method PUT "/repos/$REPO/vulnerability-alerts"
echo "   dependabot: enabled"

echo ""
echo "Done. $REPO is hardened."
