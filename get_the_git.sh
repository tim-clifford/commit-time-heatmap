#!/bin/sh

# I mean this could be python but is it bad to want to flex your shell skills?

read -p 'Enter your github username: ' GH_USERNAME
read -p 'Enter your real name (as set by `git config user.name`): ' GH_NAME

# pfffffffftttt json parsing?? All I need is a sexy regex, baby
repos=$(wget https://api.github.com/users/$GH_USERNAME/repos -O - 2>/dev/null \
	| sed -n 's/[[:space:]]*"clone_url":[[:space:]]*"\(.*\)",[[:space:]]*/\1/p')

times=""
for i in $repos; do
	git clone $i
	cd $(echo $i | sed 's|.*/\(.*\)\.git|\1|')
	commits="$(git log --no-patch --no-notes --pretty='%cd----%an' --date=iso)"
	IFS="
	"
	for c in $commits; do
		# Make sure we only count commits by the right user
		if [ "$(echo "$c" | awk -F'----' '{print $2}')" = "$GH_NAME" ]; then
			times="$times $(echo "$c" | awk '{print $2}')"
		fi
	done
	cd -
	rm -rf $(echo $i | sed 's|.*/\(.*\)\.git|\1|')
done

# Just get rid of anything after the hour mark
times=$(echo $times | sed 's/\(..\):..:../\1/g; s/[^ ]*:[^ ]*//')
echo -n $times > times.txt

if ! [ "$1" = "--running-it-from-the-python-file" ]; then
	python3 do_the_plot.py --running-it-from-the-shell-file
fi


