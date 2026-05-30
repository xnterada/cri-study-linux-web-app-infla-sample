# CRI Study Linux Web App Infra

本リポジトリは、Terraformを使用して「CRI Study Linux Web App」のAWS基盤を管理するリポジトリである。

## ビルド構成
省略（自由に変更してもらって構わない）

## デプロイ手順
ビルド前にTerraformステート管理用のS3バケットが作成する。
AWS CLIを使用して、以下のコマンドでS3バケットを作成する。
```bash
# アカウントIDを自動取得・変数代入
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# 確認
echo $ACCOUNT_ID

# バケット作成
aws s3api create-bucket \
    --bucket "${ACCOUNT_ID}-cri-study-linux-terraform-state" \
    --region ap-northeast-1 \
    --create-bucket-configuration LocationConstraint=ap-northeast-1
```

CDNレイヤーのリモートステートをWebレイヤーが参照するため、以下の順序でデプロイする。

### 1. CDN のデプロイ
1. デプロイ前に、`env/prod/cdn/terraform.tfvars` 内の変数値を自身のAWS環境に合わせて編集する。
```hcl
# 実際のドメイン名に変更すること
domain_name = "cri.example.com"
# Route53ホストゾーンIDに変更すること
zone_id = "ZXXXXXXXXXXXXXXXXXXXX"
```

2. `env/prod/cdn/backend.tf` 内のS3バケット名を、上記で作成したTerraformステート管理用のS3バケット名に変更する。s3`ブロック内の`bucket`属性を上記で作成したS3バケット名に変更する。

3. 以下のコマンドでデプロイを実行する。
```bash
# CDNレイヤーのルートディレクトリに移動
cd env/prod/cdn
# Terraformの初期化とデプロイ
terraform init
# バリデーションチェック
terraform validate
# デプロイ（変更内容の確認であっていれば「yes」を入力して実行）
terraform apply
```

### 2. Webサーバ用のキーペアの作成
WebサーバにSSH接続するためのキーペアを作成する。これはGitHub ActionsなからWebサーバにSSH接続する際にも使用する。
```bash
# キーペア作成
ssh-keygen -t ed25519 -C "deploy@github-actions" -f ~/.ssh/cri_study_linux_deploy_key -N ""
# 公開鍵の内容を変数に代入
DEPLOY_PUBLIC_KEY=$(cat ~/.ssh/cri_study_linux_deploy_key.pub)
# 確認
echo $DEPLOY_PUBLIC_KEY
```

### 3. Web のデプロイ
デプロイ前に、`env/prod/web/terraform.tfvars` 内の変数値を自身のAWS環境に合わせて編集する。
```hcl
# 実際のドメイン名に変更すること
domain_name = "cri.example.com"
# Route53ホストゾーンIDに変更すること
zone_id = "ZXXXXXXXXXXXXXXXXXXXX"
# Packerで作成したWebアプリ用のAMI IDに変更すること
ami = "ami-xxxxxxxxxxxxxxxxx"
# 上記で作成したTerraformリモートステート用のS3バケット名に変更すること
terraform_state_bucket = "{ACCOUNT_ID}-terraform-state-bucket-name"
# 他のCIDRブロックと重複しないように注意（マネコンで確認して適宜変更すること）
cidr_block = "10.1.0.0/16"
# WebサーバにSSH接続するための公開鍵（上記で作成したキーペアの公開鍵を変数に代入して使用すること）
deploy_public_key = "ssh-ed25519 (中略) deploy@github-actions"
```

2. `env/prod/web/backend.tf` 内のS3バケット名を、上記で作成したTerraformステート管理用のS3バケット名に変更する。s3`ブロック内の`bucket`属性を上記で作成したS3バケット名に変更する。

3. 以下のコマンドでデプロイを実行する。
```bash
# Webレイヤーのルートディレクトリに移動
cd env/prod/web
# Terraformの初期化とデプロイ
terraform init
# バリデーションチェック
terraform validate
# デプロイ（変更内容の確認であっていれば「yes」を入力して実行）
terraform apply
```

## 次のステップ
アプリリポジトリ（`cri-study-linux-web-app`）のGitHub Actionsワークフローで、Webサーバへのデプロイする。ここで作成したSSHキーペアの秘密鍵は次のステップで使用する。