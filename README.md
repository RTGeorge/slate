# Overview
This project provides documentation for the FoxDen Platform.
It is based on the https://github.com/lord/slate project.

Code samples in the form of MarkDown are pulled from the remote GIT repos defined in the `docRepos` variable in `scripts/merge_includes.sh`.
For each repo in `docRepos` and each category in `docCategories`, code samples are incorporated into the documentation.

For example, with the following values:

```bash
docCategories=(_objects _operations)
docRepos=("https://github.com/RTGeorge/docs_ios.git" "https://github.com/RTGeorge/docs_js.git")
```

Code samples from the following files are included in the documentation:

https://github.com/RTGeorge/docs_js/blob/master/docs/_objects.md
https://github.com/RTGeorge/docs_js/blob/master/docs/_operations.md
https://github.com/RTGeorge/docs_ios/blob/master/docs/_objects.md
https://github.com/RTGeorge/docs_ios/blob/master/docs/_operations.md

## Notes
* Code samples are searched for recursively in the docs subdirectory of the remote repos.
* Code samples must be named in the form `<category>.md`.
* Remote code samples should only contain MarkDown headers and code in the languages specificed in `source/index.html.md`.
* Descriptions should only be included in `source/index.html.md` and `source/includes` and should apply to all languages.
* The categories in `docCategories`, should match the includes specified in `source/index.html.md`.
* The files in `source/includes` are altered by the build process, do not check these changes into source control.

# BUILD
To build the docker image hosting the FoxDen Platform documentaion:
```bash
docker build -t fdocs -f docker/Dockerfile .
```
# RUN
To run the docker image hosting the FoxDen Platform:
```bash
docker run -t -p 4567:4567 --rm fdocs
```
Change the port mappings to match your environment/config.
