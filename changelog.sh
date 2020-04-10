#!/bin/bash
VARIANTNAME=$1
StatusFile=$VARIANTNAME/status.env
NewStatusFile=$VARIANTNAME/newstatus.env
RepoUsedPathFile=$VARIANTNAME/repo_used_path.env
URLFile=name_and_urls.env
ChangeLogFile=$VARIANTNAME/CHANGELOG.md
BuildTag="$VARIANTNAME-$(date +%Y-%m-%d)-$BuilderHash"
env | grep "Hash" > $NewStatusFile
ChangeLog=""
while read l; do
    IFS='='
    read -ra Parts <<< "$l"
    name=${Parts[0]/Hash/}
    hash=${Parts[1]}
    hash=$(echo $hash | cut -c -7)
    url=""
    if [ -f "$URLFile" ]; then
        urlLine=$(grep $URLFile -e ${name}URL)
        url=$(echo "${urlLine/${name}URL=/}")
    fi

    oldLine=""
    if [ -f "$StatusFile" ]; then
        oldLine=$(grep $StatusFile -e ${name}Hash)
    fi

    logPathLine=""
    if [ -f "$RepoUsedPathFile" ]; then
        logPathLine=$(grep $RepoUsedPathFile -e ${name})
    fi

    title=""
    body=""
    if [ "$oldLine" == "" ]; then
        title="${name} [$hash]($url/commit/$hash)"
    else
        read -ra Parts <<< "$oldLine"
        oldHash=${Parts[1]}
        oldHash=$(echo $oldHash | cut -c -7)
        if ! [ "$oldHash" == "$hash" ]; then
            logPath=""
            if ! [ "$logPathLine" == "" ]; then
                read -ra Parts <<< "$logPathLine"
                logPath=${Parts[1]}
                echo "only log repo $name for $logPath"
            fi

            title="${name} [${oldHash}..$hash]($url/compare/$oldHash..$hash)"
            branch=master
            if [ "$name" == "Argon" ]; then
                branch="18.06"
            fi
            if [ "$name" == "FriendlyWRT" ]; then
                branch="master-v19.07.1"
            fi

            mkdir -p .temprepo
            cd .temprepo
            git init
            git remote add $name ${url}.git
            git fetch $name
            body="
| Commit | Author | Desc |
| :----- | :------| :--- |
"
            echo "Generating Change Log for ${name}/${branch} ${oldHash}..${hash} -- ${logPath}"
            table=$(git log --no-merges --invert-grep --author="action@github.com" --pretty=format:"| [%h](${url}/commit/%h) | %an | %s |" ${oldHash}..${hash} ${name}/${branch} -- ${logPath})
            if [ "$table" == "" ]; then
                body=""
                title=""
            else
                body="$body$table"
            fi
            cd ..
        fi
    fi
    if ! [ "$title" == "" ]; then
    ChangeLog="${ChangeLog}#### $title

$body


"
    fi
done <$NewStatusFile

echo "$ChangeLog"

ChangeLogEscaped="${ChangeLog//'%'/'%25'}"
ChangeLogEscaped="${ChangeLogEscaped//$'\n'/'%0A'}"
ChangeLogEscaped="${ChangeLogEscaped//$'\r'/'%0D'}" 
echo "::set-output name=changelog::$ChangeLogEscaped" 
echo "::set-output name=buildtag::$BuildTag"
if [ "$ChangeLog" == "" ]; then
    echo "No Change Happened, We Should Not Build."
    exit 0
fi

ChangeLogFull="## $BuildTag

$ChangeLog

--------------
"
touch $ChangeLogFile
printf '%s\n%s\n' "$ChangeLogFull" "$(cat $ChangeLogFile)" >$ChangeLogFile
rm $StatusFile
mv $NewStatusFile $StatusFile
git add $StatusFile
git add $ChangeLogFile
git commit -m "ChangeLog for $BuildTag"
# git push
