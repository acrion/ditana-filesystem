#!/bin/bash

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help function
show_help() {
    echo "Usage: $0 <source-repo-path>"
    echo ""
    echo "Updates the current repository from upstream source."
    echo ""
    echo "Arguments:"
    echo "  source-repo-path    Path to the checked out upstream repository"
    echo ""
    echo "Example:"
    echo "  # First checkout the upstream repo:"
    echo "  pikaur -G filesystem"
    echo "  # Then run this script:"
    echo "  $0 /path/to/filesystem"
    echo ""
    echo "Requirements:"
    echo "  - Must be on 'arch-base' branch"
    echo "  - Must be in a git repository"
    echo "  - No untracked files (run 'git clean -xfd' first)"
    echo "  - Source repo must be on an official tag"
}

# Check for mandatory parameter
if [[ $# -ne 1 ]]; then
    echo -e "${RED}Error: Missing required parameter${NC}"
    echo ""
    show_help
    exit 1
fi

source_repo="$1"

# Check if source repository exists
if [[ ! -d "$source_repo" ]]; then
    echo -e "${RED}Error: Source repository directory '$source_repo' does not exist${NC}"
    exit 1
fi

# Check if source is a git repository
if [[ ! -d "$source_repo/.git" ]]; then
    echo -e "${RED}Error: Source directory '$source_repo' is not a git repository${NC}"
    exit 1
fi

# Check if we're in a git repository
if [[ ! -d ".git" ]]; then
    echo -e "${RED}Error: Current directory is not a git repository (.git directory not found)${NC}"
    exit 1
fi

# Check if we're on the arch-base branch
current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "arch-base" ]]; then
    echo -e "${RED}Error: Not on arch-base branch (current: $current_branch)${NC}"
    exit 1
fi

# Check if there are untracked files (git clean -xfd should have been run)
if [[ -n $(git ls-files --others --exclude-standard) ]]; then
    echo -e "${RED}Error: Untracked files found. Please run 'git clean -xfd' first:${NC}"
    git ls-files --others --exclude-standard
    exit 1
fi

# Check if source repo is on an official tag
pushd "$source_repo" > /dev/null
if ! tag_name=$(git describe --exact-match HEAD 2>/dev/null); then
    echo -e "${RED}Error: Source repository is not on an official tag${NC}"
    echo -e "${YELLOW}Please checkout the latest official tag first:${NC}"
    echo "  cd $source_repo"
    echo "  git tag --sort=-version:refname | head -5"
    echo "  git checkout <tag-name>"
    popd > /dev/null
    exit 1
fi
popd > /dev/null

echo -e "${GREEN}Updating from upstream tag: $tag_name${NC}"
echo -e "${YELLOW}Source: $source_repo${NC}"
echo -e "${YELLOW}Destination: .${NC}"

# Perform rsync with exclusions
rsync -av --delete \
    --exclude='.git' \
    --exclude='update-from-upstream.sh' \
    "$source_repo/" "."

echo -e "${GREEN}Update completed successfully${NC}"

# Generate commit message (just the tag name)
commit_message="$tag_name"
echo -e "${GREEN}Suggested commit message:${NC}"
echo "$commit_message"
