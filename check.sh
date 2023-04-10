#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

# 環境変数 読み込み
source ./envfile

# VPC
echo "[START] check VPC"
## VPC ID を Name タグで検索して取得
VPC_ID=$(aws ec2 describe-vpcs --query "Vpcs[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-vpc']].VpcId" --output text)

## VPC ID が取得できなかった場合はエラー
if [ "${VPC_ID}" = "" ]; then
    echo "VPC ID が取得できませんでした"
    exit 1
fi

## VPC の CIDR が envfile の値と一致するか確認
VPC_CIDR=$(aws ec2 describe-vpcs --vpc-ids "${VPC_ID}" --query "Vpcs[].CidrBlock" --output text)
if [ "${VPC_CIDR}" != "${VpcCidrBlock}" ]; then
    echo "VPC の CIDR が一致しません"
    echo "envfile: ${VpcCidrBlock}"
    echo "AWS: ${VPC_CIDR}"
    exit 1
fi
echo "[FINISH] check VPC"

# サブネット
echo "[START] check Subnet"
## サブネット ID を Name タグで検索して取得
### Public1a
SUBNET_ID_PUBLIC_1A=$(aws ec2 describe-subnets --query "Subnets[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-subnet-public-1a']].SubnetId" --output text)
if [ "${SUBNET_ID_PUBLIC_1A}" = "" ]; then
    echo "Subnet ID が取得できませんでした"
    exit 1
fi
### Public1c
SUBNET_ID_PUBLIC_1C=$(aws ec2 describe-subnets --query "Subnets[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-subnet-public-1c']].SubnetId" --output text)
if [ "${SUBNET_ID_PUBLIC_1C}" = "" ]; then
    echo "Subnet ID が取得できませんでした"
    exit 1
fi
### Protected1a
SUBNET_ID_PROTECTED_1A=$(aws ec2 describe-subnets --query "Subnets[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-subnet-protected-1a']].SubnetId" --output text)
if [ "${SUBNET_ID_PROTECTED_1A}" = "" ]; then
    echo "Subnet ID が取得できませんでした"
    exit 1
fi
### Protected1c
SUBNET_ID_PROTECTED_1C=$(aws ec2 describe-subnets --query "Subnets[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-subnet-protected-1c']].SubnetId" --output text)
if [ "${SUBNET_ID_PROTECTED_1C}" = "" ]; then
    echo "Subnet ID が取得できませんでした"
    exit 1
fi
### Private1a
SUBNET_ID_PRIVATE_1A=$(aws ec2 describe-subnets --query "Subnets[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-subnet-private-1a']].SubnetId" --output text)
if [ "${SUBNET_ID_PRIVATE_1A}" = "" ]; then
    echo "Subnet ID が取得できませんでした"
    exit 1
fi
### Private1c
SUBNET_ID_PRIVATE_1C=$(aws ec2 describe-subnets --query "Subnets[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-subnet-private-1c']].SubnetId" --output text)
if [ "${SUBNET_ID_PRIVATE_1C}" = "" ]; then
    echo "Subnet ID が取得できませんでした"
    exit 1
fi

## サブネットの CIDR が envfile の値と一致するか確認
### Public1a
SUBNET_CIDR_PUBLIC_1A=$(aws ec2 describe-subnets --subnet-ids "${SUBNET_ID_PUBLIC_1A}" --query "Subnets[].CidrBlock" --output text)
if [ "${SUBNET_CIDR_PUBLIC_1A}" != "${SubnetCidrBlockPublic1a}" ]; then
    echo "Subnet の CIDR が一致しません"
    echo "envfile: ${SubnetCidrBlockPublic1a}"
    echo "AWS: ${SUBNET_CIDR_PUBLIC_1A}"
    exit 1
fi
### Public1c
SUBNET_CIDR_PUBLIC_1C=$(aws ec2 describe-subnets --subnet-ids "${SUBNET_ID_PUBLIC_1C}" --query "Subnets[].CidrBlock" --output text)
if [ "${SUBNET_CIDR_PUBLIC_1C}" != "${SubnetCidrBlockPublic1c}" ]; then
    echo "Subnet の CIDR が一致しません"
    echo "envfile: ${SubnetCidrBlockPublic1c}"
    echo "AWS: ${SUBNET_CIDR_PUBLIC_1C}"
    exit 1
fi
### Protected1a
SUBNET_CIDR_PROTECTED_1A=$(aws ec2 describe-subnets --subnet-ids "${SUBNET_ID_PROTECTED_1A}" --query "Subnets[].CidrBlock" --output text)
if [ "${SUBNET_CIDR_PROTECTED_1A}" != "${SubnetCidrBlockProtected1a}" ]; then
    echo "Subnet の CIDR が一致しません"
    echo "envfile: ${SubnetCidrBlockProtected1a}"
    echo "AWS: ${SUBNET_CIDR_PROTECTED_1A}"
    exit 1
fi
### Protected1c
SUBNET_CIDR_PROTECTED_1C=$(aws ec2 describe-subnets --subnet-ids "${SUBNET_ID_PROTECTED_1C}" --query "Subnets[].CidrBlock" --output text)
if [ "${SUBNET_CIDR_PROTECTED_1C}" != "${SubnetCidrBlockProtected1c}" ]; then
    echo "Subnet の CIDR が一致しません"
    echo "envfile: ${SubnetCidrBlockProtected1c}"
    echo "AWS: ${SUBNET_CIDR_PROTECTED_1C}"
    exit 1
fi
### Private1a
SUBNET_CIDR_PRIVATE_1A=$(aws ec2 describe-subnets --subnet-ids "${SUBNET_ID_PRIVATE_1A}" --query "Subnets[].CidrBlock" --output text)
if [ "${SUBNET_CIDR_PRIVATE_1A}" != "${SubnetCidrBlockPrivate1a}" ]; then
    echo "Subnet の CIDR が一致しません"
    echo "envfile: ${SubnetCidrBlockPrivate1a}"
    echo "AWS: ${SUBNET_CIDR_PRIVATE_1A}"
    exit 1
fi
### Private1c
SUBNET_CIDR_PRIVATE_1C=$(aws ec2 describe-subnets --subnet-ids "${SUBNET_ID_PRIVATE_1C}" --query "Subnets[].CidrBlock" --output text)
if [ "${SUBNET_CIDR_PRIVATE_1C}" != "${SubnetCidrBlockPrivate1c}" ]; then
    echo "Subnet の CIDR が一致しません"
    echo "envfile: ${SubnetCidrBlockPrivate1c}"
    echo "AWS: ${SUBNET_CIDR_PRIVATE_1C}"
    exit 1
fi

echo "[FINISH] check Subnet"

# IGW
echo "[START] check IGW"
## IGW ID を取得
IGW_ID=$(aws ec2 describe-internet-gateways --query "InternetGateways[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-igw']].InternetGatewayId" --output text)
if [ "${IGW_ID}" = "" ]; then
    echo "IGW ID が取得できませんでした"
    exit 1
fi
## IGW が VPC にアタッチされているか確認
IGW_ATTACHED=$(aws ec2 describe-internet-gateways --internet-gateway-ids "${IGW_ID}" --query "InternetGateways[].Attachments[].VpcId" --output text)
if [ "${IGW_ATTACHED}" != "${VPC_ID}" ]; then
    echo "IGW が VPC にアタッチされていません"
    exit 1
fi
echo "[FINISH] check IGW"

# NAT ゲートウェイ
echo "[START] check NAT Gateway"
## NAT ゲートウェイ ID を取得
NAT_GATEWAY_ID=$(aws ec2 describe-nat-gateways --query "NatGateways[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-ngw-1a']].NatGatewayId" --output text)
if [ "${NAT_GATEWAY_ID}" = "" ]; then
    echo "NAT ゲートウェイ ID が取得できませんでした"
    exit 1
fi
## NAT ゲートウェイが Public1a のサブネットにアタッチされているか確認
NAT_GATEWAY_ATTACHED_SUBNET=$(aws ec2 describe-nat-gateways --nat-gateway-ids "${NAT_GATEWAY_ID}" --query "NatGateways[].SubnetId" --output text)
if [ "${NAT_GATEWAY_ATTACHED_SUBNET}" != "${SUBNET_ID_PUBLIC_1A}" ]; then
    echo "NAT ゲートウェイが Public1a のサブネットにアタッチされていません"
    exit 1
fi

## マルチAZの時のみパブリックサブネット1cにNATゲートウェイがアタッチされているか確認
if [ "${MultiAz}" = "true" ]; then
    ## NAT ゲートウェイ ID を取得
    NAT_GATEWAY_ID=$(aws ec2 describe-nat-gateways --query "NatGateways[?Tags[?Key=='Name' && Value=='${Prefix}-${Environment}-ngw-1c']].NatGatewayId" --output text)
    if [ "${NAT_GATEWAY_ID}" = "" ]; then
        echo "NAT ゲートウェイ ID が取得できませんでした"
        exit 1
    fi
    ## NAT ゲートウェイが Public1c のサブネットにアタッチされているか確認
    NAT_GATEWAY_ATTACHED_SUBNET=$(aws ec2 describe-nat-gateways --nat-gateway-ids "${NAT_GATEWAY_ID}" --query "NatGateways[].SubnetId" --output text)
    if [ "${NAT_GATEWAY_ATTACHED_SUBNET}" != "${SUBNET_ID_PUBLIC_1C}" ]; then
        echo "NAT ゲートウェイが Public1c のサブネットにアタッチされていません"
        exit 1
    fi
fi
echo "[FINISH] check NAT Gateway"