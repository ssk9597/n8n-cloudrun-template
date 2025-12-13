#!/bin/bash

if [ ! -f .env ]; then
  echo "❌ .env ファイルが見つかりません。"
  exit 1
fi

CURRENT_BUCKET_SETTING=$(grep "^export TF_BACKEND_BUCKET" .env | sed 's/#.*$//' | grep -o '"[^"]*"' | tr -d '"')

if [[ "$CURRENT_BUCKET_SETTING" == *"CHANGE_ME"* ]]; then
  echo "⚠️ バケット名が初期値のため、ユニークな名前を生成します..."
  
  TIMESTAMP=$(date +%Y%m%d%H%M%S)
  NEW_BUCKET_NAME="n8n-tfstate-${TIMESTAMP}"
  
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' -E "s/^(export )?TF_BACKEND_BUCKET=.*/\1TF_BACKEND_BUCKET=\"${NEW_BUCKET_NAME}\"/" .env
  else
    sed -i -E "s/^(export )?TF_BACKEND_BUCKET=.*/\1TF_BACKEND_BUCKET=\"${NEW_BUCKET_NAME}\"/" .env
  fi
  
  echo "✅ .env を更新しました: TF_BACKEND_BUCKET=\"${NEW_BUCKET_NAME}\""
  
  TF_BACKEND_BUCKET="${NEW_BUCKET_NAME}"
else
  echo "ℹ️ バケット名は設定済みです: ${CURRENT_BUCKET_SETTING}"
  TF_BACKEND_BUCKET="${CURRENT_BUCKET_SETTING}"
fi

if [[ -z "$PROJECT_ID" ]]; then
  PROJECT_ID=$(grep "^export PROJECT_ID" .env | sed 's/#.*$//' | grep -o '"[^"]*"' | tr -d '"')
fi

if [[ -z "$PROJECT_ID" ]]; then
  echo "❌ PROJECT_ID が設定されていません。 .env ファイルを確認してください。"
  exit 1
fi

if [[ -z "$TF_BACKEND_BUCKET" ]]; then
  echo "❌ TF_BACKEND_BUCKET が設定されていません。 .env ファイルを確認してください。"
  exit 1
fi

BUCKET_NAME="${TF_BACKEND_BUCKET}"
REGION="${REGION:-asia-northeast1}"

echo "🚀 Terraform のためのバケットを準備します..."
echo "対象プロジェクト: ${PROJECT_ID}"
echo "バケット名: ${BUCKET_NAME}"

if ! gsutil ls -p "${PROJECT_ID}" gs://"${BUCKET_NAME}"/ >/dev/null 2>&1; then
  echo "✅ バケットがなかったので作成します..."
  if ! gsutil mb -p "${PROJECT_ID}" -c STANDARD -l "${REGION}" gs://"${BUCKET_NAME}"/; then
    echo "❌ バケットの作成に失敗しました。入力された情報を確認してください。"
    exit 1
  fi
else
  echo "✅ バケットはすでに存在します。作成はスキップします。"
fi

echo "📦 バージョン管理を有効にします..."
if ! gsutil versioning set on gs://"${BUCKET_NAME}"/; then
  echo "❌ バージョン管理の設定に失敗しました。"
  exit 1
fi

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

echo ""
echo "🎉 バケットの準備が完了しました！Terraform を使う準備OKです！"
echo "次に実行するコマンド："
echo "  task setup-backend"
echo "  task deploy-secrets-auto"
echo "  task deploy-app-auto"
