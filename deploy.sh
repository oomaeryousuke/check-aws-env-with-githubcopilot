#!/bin/bash

source ./envfile

STACK_NAME="checkaws-test"
REGION="ap-northeast-1"

if [ -n "$1" ]; then
    echo "CloudFormationテンプレートを指定した S3 バケットから取得します"
    TEMPLATE_URL=$1
fi

# スタック作成
aws cloudformation create-stack --stack-name "${STACK_NAME}" --template-url "${TEMPLATE_URL}/root-stack.yml" \
    --parameters \
    ParameterKey=TemplateS3Path,ParameterValue="${TEMPLATE_URL}" \
    ParameterKey=Prefix,ParameterValue="${Prefix}" \
    ParameterKey=Environment,ParameterValue="${Environment}" \
    ParameterKey=MultiAz,ParameterValue="${MultiAz}" \
    ParameterKey=VpcCidrBlock,ParameterValue="${VpcCidrBlock}" \
    ParameterKey=SubnetCidrBlockPublic1a,ParameterValue="${SubnetCidrBlockPublic1a}" \
    ParameterKey=SubnetCidrBlockPublic1c,ParameterValue="${SubnetCidrBlockPublic1c}" \
    ParameterKey=SubnetCidrBlockProtected1a,ParameterValue="${SubnetCidrBlockProtected1a}" \
    ParameterKey=SubnetCidrBlockProtected1c,ParameterValue="${SubnetCidrBlockProtected1c}" \
    ParameterKey=SubnetCidrBlockPrivate1a,ParameterValue="${SubnetCidrBlockPrivate1a}" \
    ParameterKey=SubnetCidrBlockPrivate1c,ParameterValue="${SubnetCidrBlockPrivate1c}" \
    --capabilities CAPABILITY_NAMED_IAM \
    --region "${REGION}"

exit 0