#!/usr/bin/env bash
#   ########################################################################
#   Copyright 2021 Splunk Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#   ######################################################################## 

SEMVER_REGEX='^v[0-9]+\.[0-9]+\.[0-9]+$'
if [[ $INPUT_SEMVER =~ $SEMVER_REGEX ]];
then
    echo using provided semver
    VERSION=$INPUT_SEMVER
else
    if [[ $GITHUB_EVENT_NAME != 'pull_request' ]]
    then
        echo this is not a release build and NOT PR RUNID + run ID
        VERSION=v0.0.${GITHUB_RUN_ID}
    else 
        echo this is not a release build and is a PR use run ID
        VERSION=v0.${INPUT_PRNUMBER}.${GITHUB_RUN_ID}
    fi
fi

if [[ $VERSION =~ $SEMVER_REGEX ]];
then
    echo "::set-output name=VERSION::echo $(echo $VERSION | sed 's/v\(.*\)/\1/')"
    exit 0
else
    exit 1
fi
