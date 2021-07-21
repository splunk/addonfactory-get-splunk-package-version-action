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
BETA_REGEX='^v[0-9]+\.[0-9]+\.[0-9]+-beta\.[0-9]+$'
echo working with version $INPUT_SEMVER

if [[ $INPUT_SEMVER =~ $SEMVER_REGEX ]];

then
    echo using provided semver
    VERSION=$INPUT_SEMVER
elif [[ $INPUT_SEMVER =~ $BETA_REGEX ]];
    VERSION=$(echo $INPUT_SEMVER | awk '{gsub("-beta\.", "B");print}')
else
    if [[ $GITHUB_EVENT_NAME != 'pull_request' ]];
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
    FINALVERSION=$(echo $VERSION | sed 's/v\(.*\)/\1/')
    echo "Version to build is $FINALVERSION"
    echo "::set-output name=VERSION::$FINALVERSION"
    exit 0
else
    exit 1
fi
