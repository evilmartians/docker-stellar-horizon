#!/bin/sh

set -eux

cd /tmp

curl -fsSLO https://github.com/golang/dep/releases/download/v${DEP_VERSION}/dep-linux-amd64

echo "${DEP_SHA256SUM}  dep-linux-amd64" | sha256sum -c -

mv dep-linux-amd64 /usr/local/bin/dep

chown root.root /usr/local/bin/dep
chmod a+x /usr/local/bin/dep

cd -
