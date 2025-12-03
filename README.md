# n8nをGoogle Cloudにかんたんデプロイ

このプロジェクトでは、ほぼ無料のGoogle CloudとSupabase を使って、ノーコード自動化ツール「n8n」をクラウドにデプロイできます。

## 💻 パソコンに入れておくツール
以下のツールをパソコンにインストールしてください。どれも無料です。

### 1. Terraform (クラウドに「こんな環境を作って」と指示するツール)
* **Mac**:

  ```bash
  brew install terraform
  ```

* **Windows**:

  ```powershell
  choco install terraform
  ```

* その他の方法 (公式サイト):
  [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)

### 2. Google Cloud SDK (Google Cloud を操作するコマンド)
* **Mac**:

  ```bash
  $ brew install --cask google-cloud-sdk
  ```

* ダウンロード:
  [https://cloud.google.com/sdk/docs/install?hl=ja](https://cloud.google.com/sdk/docs/install?hl=ja)

### 3. Task (コマンドをまとめて実行できる便利ツール)

* **Mac**:

  ```bash
  brew install go-task/tap/go-task
  ```

* **Windows**:
  [https://taskfile.dev/installation/#windows](https://taskfile.dev/installation/#windows)

---

## ⚡️ このあとの手順
### GCP 側
1. GCP でプロジェクトを作成
2. 以下の API を有効化
   * Cloud Run API
   * Secret Manager API
   * Cloud Storage API
3. `.env.example`ファイルの名前を`.env`に変更する
`.env` ファイル内の下記2行を自分のプロジェクトに合わせて書き換えてください。
```bash
export PROJECT_ID="あなたのGCPプロジェクトID"
```

### Supabase 側
1. Supabase でプロジェクトを作成
2. Table を作成
3. `secrets/terraform.tfvars.example`ファイルの名前を`secrets/terraform.tfvars` に変更し、接続情報を記入
```hcl
initial_db_host     = "db.xxxxxx.supabase.co"
initial_db_user     = "postgres"
initial_db_password = "パスワード"
```
---

## 実行
1. 環境変数を読み込む

```bash
source .env
gcloud auth application-default login
unset GOOGLE_APPLICATION_CREDENTIALS
task setup-backend
```

2. n8nの環境を作成する
```bash
# 一括実施
task deploy-all

# 個別実施
task deploy-secrets-auto
task deploy-app-auto
```
---
## 🌐 n8n にアクセス
最後に出力される URL をブラウザで開けば、n8n が利用できます。

## 🚳️ 全て削除したいとき

```bash
task destroy-all
```

---

## ✨ お疲れさまでした

Google Cloud 無料枠 + Supabase を使えば、ずっと動くn8n 環境がほぼ無料で手に入ります！
