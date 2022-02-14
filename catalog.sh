#! /bin/bash
# Chukwudi Ikem | CPSC 449-01

# 0.) http --body GET "https://catalog.fullerton.edu/search_advanced.php?cur_cat_oid=70&ecpage=1&cpage=1&ppage=1&pcpage=1&spage=1&tpage=1&search_database=Search&filter%5Bkeyword%5D=CPSC ${CourseNumber}&filter%5Bexact_match%5D=1&filter%5B3%5D=1&filter%5B31%5D=1" | grep "Best Match: "
# I used developer tools to understand what kind of query was being made after I hit go.
# I looked in the Network tab and found that a search_advanced.php file was the first to pop up.
# Assuming the query had to do with this PHP file I looked at the headers to find the request url.
# This request url is 0.) ^.
# We can look at the payload tab to see the various query parameters that define our search.

# The various lines down below inlude the different query parameters that I defined in order to get the query's hypertext response that
# will be used as input for grep via the pipe symbol (|).

# CourseNumber means more semantically than $1. It is a variable that holds the second argument in the execution of this script.
# ex.) ./catalog.sh 449. CourseNumber will be 449.
CourseNumber=$1
echo "You are searching for a CPSC course at CSUF with the title CPSC ${CourseNumber}!"
sleep 2s
http --body GET "https://catalog.fullerton.edu/search_advanced.php" \
		"filter[keyword]"=="CPSC ${CourseNumber}" \
		"filter[exact_match]"=="1" \
		"filter[3]"=="1" \
		"filter[31]"=="1" \
		"search_database"=="Search" \
		"cur_cat_oid"=="70" \
		| grep "Best Match: "
