#!/bin/bash

# ================================
# Terraform 用のバケットを作るスクリプト
# ※ 最初に1回だけ実行してください
# ================================

# ---------- 環境変数チェック ----------
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
echo "バケットを確認中: ${BUCKET_NAME}"

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
