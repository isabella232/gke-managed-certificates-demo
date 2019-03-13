#!/usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Helper script to generate terraform variables        -"
# "-  file based on gcloud defaults.                       -"
# "-                                                       -"
# "---------------------------------------------------------"

# Stop immediately if something goes wrong
set -euo pipefail

ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "$ROOT/scripts/common.sh"

# Get the default project and use it or die
PROJECT=$(gcloud config get-value core/project)
if [[ -z "${PROJECT}" ]]; then
    echo "gcloud cli must be configured with a default project."
    echo "run 'gcloud config set core/project PROJECT'."
    echo "replace 'PROJECT' with the project name."
    exit 1;
fi

# Get the default zone and use it or die
ZONE=$(gcloud config get-value compute/zone)
if [ -z "${ZONE}" ]; then
    echo "gcloud cli must be configured with a default zone."
    echo "run 'gcloud config set compute/zone ZONE'."
    echo "replace 'ZONE' with the zone name like us-west1-a."
    exit 1;
fi

#Get the default region and use it or die
REGION=$(gcloud config get-value compute/region)
if [ -z "${REGION}" ]; then
    echo "gcloud cli must be configured with a default region."
    echo "run 'gcloud config set compute/region REGION'."
    echo "replace 'REGION' with the region name like us-west1."
    exit 1;
fi

TFVARS_FILE="$ROOT/terraform/terraform.tfvars"

if [[ -f "${TFVARS_FILE}" ]]
then
    rm "${TFVARS_FILE}"
fi
# Write out all the values we gathered into a tfvars file so you don't
# have to enter the values manually
cat <<-EOF > "${TFVARS_FILE}"
	project="${PROJECT}"
	region="${REGION}"
	cluster_name="${CLUSTER_NAME}"
	domain="${DOMAIN}"
	managed_zone="${MANAGED_ZONE}"
EOF
