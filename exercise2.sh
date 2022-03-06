#!/bin/bash
# Creates a persistent session via --session=SESSION_NAME_OR_PATH option such that cookies persist between requests to the same host. The session object is created locally! (line 8)

# Use jq to process the contents of a local JSON file. Specify the name as the last argument. If error set current_page to -1. (line 10)
# i - iv.

for i in {1..2}
  do
    http --quiet --session=./foo.json httpbin.org/cookies/set?page=${i} # sets cookie for user foo
    current_page=`jq --raw-output '.cookies.page.value//-1' foo.json` # retrieves the page number set in the cookie
    http --body "jsonplaceholder.typicode.com/posts?_page=${current_page}" # uses page number to retrieve page from JSONPlaceholder
  done

http --quiet --session=./bar.json httpbin.org/cookies/set?page=3 # sets new value for cookie associated with user bar.
current_page_from_foo=`jq --raw-output '.cookies.page.value//-1' foo.json` # gets page number set in the cookie for user foo
current_page_from_bar=`jq --raw-output '.cookies.page.value//-1' bar.json` # gets page number set in the cookie for user bar

if [[ $current_page_from_foo == 2 && $current_page_from_bar == 3 ]]; then
  printf "First test of persistent sessions working properly with different users:\nFoo: ${current_page_from_foo}\nBar: ${current_page_from_bar}\n"
  echo "Fetching page..."
  sleep 5s
  http --body "jsonplaceholder.typicode.com/posts?_page=${current_page_from_foo}" # uses page number to retrieve page from JSONPlaceholder for foo
  http --body "jsonplaceholder.typicode.com/posts?_page=${current_page_from_bar}" # uses page number to retrieve page from JSONPlaceholder for bar 
else
  echo "Not working properly"
fi

http --quiet --session=./bar.json httpbin.org/cookies/set?page=4 # sets new value for cookie associated with user bar.
current_page_from_bar=`jq --raw-output '.cookies.page.value//-1' bar.json`
if [[ $current_page_from_foo == 2 && $current_page_from_bar == 4 ]]; then
  printf "Second test of persistent sessions working properly with different users:\nFoo: ${current_page_from_foo}\nBar: ${current_page_from_bar}\n"
   echo "Fetching page..."
  sleep 5s
  http --body "jsonplaceholder.typicode.com/posts?_page=${current_page_from_foo}" # uses page number to retrieve page from JSONPlaceholder for foo
  http --body "jsonplaceholder.typicode.com/posts?_page=${current_page_from_bar}" # uses page number to retrieve page from JSONPlaceholder for bar 
else
  echo "Not working properly"
fi
