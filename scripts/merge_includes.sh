#!/bin/bash

#docRepos=("ssh://git@stash.ecovate.com/fox/foxden-js.git")
docRepos=("https://github.com/RTGeorge/docs_ios.git" "https://github.com/RTGeorge/docs_js.git")

sedExec=sed
if [ "$(uname -s)" == 'Darwin' ]; then
  sedExec=gsed
fi
if ! which $sedExec > /dev/null 2>&1; then
  echo 'Can't find GNU `sed` executable.'
  echo 'If on OS X, try `brew install gnu-sed`.
  echo 'Aborting merge.'
  exit 1
fi

docCategories=($(${sedExec} -n '/^includes:$/,/^$/p' source/index.html.md | ${sedExec} '1d;$d' | awk '{print $2}' 2> /dev/null))
if [ "${#docCategories[@]}" == "0" ]; then
  echo 'Unable to extract categories from source/index.html.md'
  echo 'exiting'
  exit 1
fi

mkdir -p stage/{includes,remotes}
inputPath=stage
outputPath=source/includes

function obtain_doc_src {
  # $1 - URL repo containing documentation you want to include
  repoName=${1##*/}
  repoName=${repoName%.git}
  repoPath=${inputPath}/remotes/${repoName}
  if [ -d "${repoPath}" ]; then
    git -C "${repoPath}" pull
  else 
    git clone ${1} ${repoPath}
  fi
  rsync -av ${repoPath}/docs ${inputPath}/includes/${repoName}/ > /dev/null
  rsync -av ${outputPath}/ ${inputPath}/ > /dev/null
}

function extract_headers {
  # $1 - Files to search for headers
  grep -h '^#' ${1} | awk '!seen[$0]++'
}

function extract_section {
  # $1 - Section header of the the form '# Header Name'
  # $2 - Filename/path that contains section documentation content
  # Print out lines from section header to next section header,
  # then remove first and last lines (i.e. section headers)
  ${sedExec} -n "/^${1}\$/,/^#/p" ${2} | ${sedExec} '1d;$d'
}

function parse_includes {
  # $1 - Documeation cateogory of include file
  headerFile=${inputPath}/${1}_headers.txt
  outputFile=${outputPath}/${1}.md
  inputFileList="$(find ${inputPath}/includes -type f -name "${1}*md" | tr '\n' ' ')"
  rm -f ${headerFile}
  rm -f ${outputFile}

  extract_headers "${inputFileList}" "${inputPath}/${1}*md" > ${headerFile}
  while read line; do
    echo ${line} >> ${outputFile}
    for fily in ${inputFileList}; do
      extract_section "${line}" "${fily}" >> ${outputFile}
    done
    extract_section "${line}" "${inputPath}/${1}*md" >> ${outputFile}
  done < ${headerFile}
}


for repo in ${docRepos[*]}; do
  echo "### Attempting to pull docs from remote repos."
  echo "### You may be prompted for authentication."
  obtain_doc_src ${repo}
done

for category in ${docCategories[*]}; do
  parse_includes "_${category}"
done
