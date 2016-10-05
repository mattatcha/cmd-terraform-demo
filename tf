#!/bin/sh
cat | tar -xpf -
terraform remote config \
      -backend=s3 \
      -backend-config="bucket=$TF_STATE_bucket" \
      -backend-config="key=$TF_STATE_key" > /dev/null
terraform $@
