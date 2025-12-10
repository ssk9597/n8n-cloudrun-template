#!/bin/bash

# ================================
# Terraform 用のバケットを作るスクリプト
# ※ 最初に1回だけ実行してください
# ================================

# ---------- 0. .env ファイルの存在確認 ----------
if [ ! -f .env ]; then
  echo "❌ .env ファイルが見つかりません。"
  exit 1
fi

# ---------- 1. バケット名の自動生成（必要な場合のみ） ----------
# .env から現在の設定値を読み取る
CURRENT_BUCKET_SETTING=$(grep "TF_BACKEND_BUCKET" .env | cut -d '=' -f2 | tr -d '"' | tr -d ' ')

# 「CHANGE_ME」が含まれている場合のみ、新しい名前を生成して書き換える
if [[ "$CURRENT_BUCKET_SETTING" == *"CHANGE_ME"* ]]; then
  echo "⚠️ バケット名が初期値のため、ユニークな名前を生成します..."
  
  # 年月日時分秒を取得
  TIMESTAMP=$(date +%Y%m%d%H%M%S)
  NEW_BUCKET_NAME="n8n-tfstate-${TIMESTAMP}"
  
  # .env ファイルを書き換え (Mac/Linux両対応)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac用 sed
    sed -i '' "s/^TF_BACKEND_BUCKET=.*/TF_BACKEND_BUCKET=\"${NEW_BUCKET_NAME}\"/" .env
  else
    # Linux用 sed
    sed -i "s/^TF_BACKEND_BUCKET=.*/TF_BACKEND_BUCKET=\"${NEW_BUCKET_NAME}\"/" .env
  fi
  
  echo "✅ .env を更新しました: TF_BACKEND_BUCKET=\"${NEW_BUCKET_NAME}\""
  
  # スクリプト内で使う変数も新しいものに更新
  TF_BACKEND_BUCKET="${NEW_BUCKET_NAME}"
else
  # 変更不要な場合は読み取った値をそのまま使う
  echo "ℹ️ バケット名は設定済みです: ${CURRENT_BUCKET_SETTING}"
  TF_BACKEND_BUCKET="${CURRENT_BUCKET_SETTING}"
fi

# ---------- 環境変数チェック（PROJECT_ID） ----------
# PROJECT_ID がまだ環境変数に入っていない場合、.envから読み込む試み
if [[ -z "$PROJECT_ID" ]]; then
  PROJECT_ID=$(grep "PROJECT_ID" .env | cut -d '=' -f2 | tr -d '"' | tr -d ' ')
fi

if [[ -z "$PROJECT_ID" ]]; then
  echo "❌ PROJECT_ID が設定されていません。 .env ファイルを確認してください。"
  exit 1
fi

if [[ -z "$TF_BACKEND_BUCKET" ]]; then
  echo "❌ TF_BACKEND_BUCKET が設定されていません。 .env ファイルを確認してください。"
  exit 1
fi

# ---------- 設定 ----------
BUCKET_NAME="${TF_BACKEND_BUCKET}"
REGION="${REGION:-asia-northeast1}"  # デフォルトは東京リージョン

echo "🚀 Terraform のためのバケットを準備します..."
echo "対象プロジェクト: ${PROJECT_ID}"
echo "バケット名: ${BUCKET_NAME}"

# ---------- バケット作成（すでにある場合はスキップ） ----------
if ! gsutil ls -p "${PROJECT_ID}" gs://"${BUCKET_NAME}"/ >/dev/null 2>&1; then
  echo "✅ バケットがなかったので作成します..."
  if ! gsutil mb -p "${PROJECT_ID}" -c STANDARD -l "${REGION}" gs://"${BUCKET_NAME}"/; then
    echo "❌ バケットの作成に失敗しました。入力された情報を確認してください。"
    exit 1
  fi
else
  echo "✅ バケットはすでに存在します。作成はスキップします。"
fi

# ---------- バージョン管理を有効化 ----------
echo "📦 バージョン管理を有効にします..."
if ! gsutil versioning set on gs://"${BUCKET_NAME}"/; then
  echo "❌ バージョン管理の設定に失敗しました。"
  exit 1
fi

# ---------- ライフサイクルルールの設定 ----------
echo "🧹 古いバージョンを自動で削除するルールを設定中..."

cat > lifecycle.json <<EOF
{
  "lifecycle": {
    "rule": [
      {
        "action": {"type": "Delete"},
        "condition": {
          "numNewerVersions": 5
        }
      }
    ]
  }
}
EOF

if ! gsutil lifecycle set lifecycle.json gs://"${BUCKET_NAME}"/; then
  echo "❌ ライフサイクルルールの設定に失敗しました。"
  rm -f lifecycle.json
  exit 1
fi

rm -f lifecycle.json

# ---------- 完了 ----------
echo ""
echo "🎉 バケットの準備が完了しました！Terraform を使う準備OKです！"
echo "次に実行するコマンド："
echo "  task setup-backend"
echo "  task deploy-secrets-auto"
echo "  task deploy-app-auto"
