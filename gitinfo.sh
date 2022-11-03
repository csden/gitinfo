#!/bin/bash
#
# Print some quick information about a git repository.

repo_dir=$1
if [ -z $repo_dir ]; then
    repo_dir=.
fi

git_flags="-C $repo_dir"

gr=$(git $git_flags rev-parse 2>&1)
if [[ $? -ne 0 ]]; then
    >&2 echo "Not a git repository.";
    exit 128
fi

repo_name=$(basename `git $git_flags rev-parse --show-toplevel`)

# count of commit objects.
obj_count=$(git $git_flags rev-list --count --all)

# default branch of the repository.
default_branch=$(git $git_flags rev-parse --abbrev-ref HEAD)

all_branches=$(git $git_flags branch -a)

# git shortlog outputs a list of contributors and
# indicates their commit count and email, ordered
# by their commit count in descending order.
contribs_table=$(git $git_flags shortlog -sne)

cat <<EOF

Details for repository: $repo_name
N. of commits: $obj_count
Default branch: $default_branch

=============== Branches ================
$all_branches
=========================================

============= Contributions =============
$contribs_table
=========================================

EOF
