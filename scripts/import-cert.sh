#!/bin/bash
aws acm import-certificate --certificate fileb://$CERT_PATH --private-key fileb://$PRIVATE_KEY_PATH --certificate-chain fileb://$CERT_CHAIN_PATH --profile $AWS_PROFILE