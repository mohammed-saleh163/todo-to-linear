#!/bin/bash

git fetch origin $GITHUB_BEFORE $GITHUB_AFTER

git diff $GITHUB_BEFORE $GITHUB_AFTER | grep "^+" | grep "TODO" | while IFS= read -r line; do

  title=$(echo "$line" | sed 's/^+.*\(TODO:[ ]*\)/\1/')
  
  compare_url="https://github.com/${REPO_NAME}/compare/${GITHUB_BEFORE}...${GITHUB_AFTER}?diff=split"

  description="This issue was created using an automated script invoked by github workflow actions. \nYou can check all the details of the push commits here: \n$compare_url"


  curl https://api.linear.app/graphql \
    -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: $LINEAR_API_KEY" \
    --data "{\"query\":\"mutation CreateI(\$input: IssueCreateInput!) { issueCreate(input: \$input) { success issue { id title } } }\",\"variables\":{\"input\":{\"title\":\"$title\",\"description\":\"$description\",\"teamId\":\"$TEAM_ID\"}}}"

done


