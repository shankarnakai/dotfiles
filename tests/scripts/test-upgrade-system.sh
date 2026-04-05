#!/usr/bin/env bash
set -e

# Configuration
TEST_ROLE="ast-grep"
TEMP_VERSION="0.0.1"
VERSIONS_FILE="versions.yml"
BACKUP_FILE="versions.yml.bak"

echo "### Starting Upgrade System Test ###"

# 1. Backup versions.yml
cp "$VERSIONS_FILE" "$BACKUP_FILE"
echo "Backed up $VERSIONS_FILE to $BACKUP_FILE"

# 2. Force an old version into versions.yml for testing
# We use ast-grep because its upgrade is fast (npm)
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/^ast_grep_version: \".*\"/ast_grep_version: \"$TEMP_VERSION\"/" "$VERSIONS_FILE"
else
    sed -i "s/^ast_grep_version: \".*\"/ast_grep_version: \"$TEMP_VERSION\"/" "$VERSIONS_FILE"
fi
echo "Downgraded $TEST_ROLE to $TEMP_VERSION in $VERSIONS_FILE"

# 3. Run dot-upgrade in a simulated interactive way
# We expect it to find a newer version and ask for confirmation
# We pipe 'y' to the upgrade command to simulate user acceptance
echo "Running: yes y | ./bin/dot-bootstrap upgrade $TEST_ROLE --skip-become-pass"
yes y | ./bin/dot-bootstrap upgrade "$TEST_ROLE" --skip-become-pass

# 4. Verify that versions.yml was updated back
UPDATED_VERSION=$(grep "^ast_grep_version:" "$VERSIONS_FILE" | sed -E 's/.*: "([^"]+)".*/\1/')

if [ "$UPDATED_VERSION" != "$TEMP_VERSION" ]; then
    echo "SUCCESS: $TEST_ROLE version updated from $TEMP_VERSION to $UPDATED_VERSION"
else
    echo "FAILURE: $TEST_ROLE version remained at $TEMP_VERSION"
    # Restore backup before failing
    mv "$BACKUP_FILE" "$VERSIONS_FILE"
    exit 1
fi

# 5. Restore original versions.yml
mv "$BACKUP_FILE" "$VERSIONS_FILE"
echo "Restored original $VERSIONS_FILE"
echo "### Upgrade System Test PASSED ###"
