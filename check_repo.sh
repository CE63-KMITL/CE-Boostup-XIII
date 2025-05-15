#!/bin/bash

# ฟังก์ชันตรวจสอบและ pull repository
check_and_pull_repo() {
    local repo_dir=$1
    local branch=$2
    local repo_name=$3

    echo "$repo_name repository..."
    cd "$repo_dir" || { echo "❌ Failed to access $repo_name directory"; exit 1; }

    # ตรวจสอบสถานะ repository
    if [ -n "$(git status --porcelain)" ]; then
        echo "❌ $repo_name has uncommitted changes or conflicts"
        exit 1
    fi

    # ตรวจสอบ branch ปัจจุบัน
    current_branch=$(git rev-parse --abbrev-ref HEAD)
    if [ "$current_branch" != "$branch" ]; then
        echo "❌ $repo_name is on branch $current_branch, expected $branch"
        exit 1
    fi

    # ดึงข้อมูลล่าสุดจาก remote
    git fetch origin

    # Debug: แสดง HEAD และ origin/branch
    local_head=$(git rev-parse HEAD)
    remote_head=$(git rev-parse origin/$branch)
    echo "Current HEAD: $local_head"
    echo "Origin/$branch: $remote_head"

    # ตรวจสอบว่ามีการเปลี่ยนแปลงหรือไม่
    if [ "$local_head" != "$remote_head" ]; then
        echo "🔄 Pulling latest data for $repo_name..."
        # บันทึก HEAD ก่อน pull
        before_pull=$(git rev-parse HEAD)
        git pull origin "$branch" || { echo "❌ Failed to pull $repo_name"; exit 1; }
        # ตรวจสอบว่า HEAD เปลี่ยนหลัง pull
        after_pull=$(git rev-parse HEAD)
        if [ "$before_pull" != "$after_pull" ]; then
            echo "✅ $repo_name updated with new changes"
            return 1  # มีการเปลี่ยนแปลงจริง
        else
            echo "ℹ️ $repo_name pull succeeded but no changes applied (e.g., already up to date)"
            return 0  # ไม่มีการเปลี่ยนแปลง
        fi
    else
        echo "ℹ️ $repo_name is up to date"
        return 0  # ไม่มีการเปลี่ยนแปลง
    fi
}

echo "======================================================="
echo "         🚀 CE Boostup XIII - Starting System 🚀"
echo "======================================================="
echo

echo "🔄 Checking latest data from Git repositories..."
echo

# ตัวแปรเพื่อติดตามว่ามีการเปลี่ยนแปลงหรือไม่
changes_detected=0

# ตรวจสอบและ pull repository ต่างๆ
check_and_pull_repo "/home/dev/CE-Boostup-XIII" "main" "Plan (self)"
changes_detected=$((changes_detected + $?))
echo "Debug: changes_detected = $changes_detected"
echo
check_and_pull_repo "/home/dev/CE-Boostup-XIII/CE-Boostup-XIII-Backend" "dev" "Backend"
changes_detected=$((changes_detected + $?))
echo "Debug: changes_detected = $changes_detected"
echo
check_and_pull_repo "/home/dev/CE-Boostup-XIII/CE-Boostup-XIII-Frontend" "dev" "Frontend"
changes_detected=$((changes_detected + $?))
echo "Debug: changes_detected = $changes_detected"
echo
check_and_pull_repo "/home/dev/CE-Boostup-XIII/CE-Boostup-XIII-Compiler" "main" "Compiler"
changes_detected=$((changes_detected + $?))
echo "Debug: changes_detected = $changes_detected"
echo

echo "======================================================="
echo "     🐳 Managing Docker Containers 🐳"
echo "======================================================="
echo

# จัดการ Docker Compose เฉพาะเมื่อมีการเปลี่ยนแปลง
if [ $changes_detected -gt 0 ]; then
    echo "   ⏬ Stopping existing containers (if any)..."
    sudo docker compose down || { echo "❌ Failed to stop containers"; exit 1; }
    echo
    echo "   ⏫ Starting and rebuilding containers..."
    echo
    sudo docker compose up --force-recreate --build -d || { echo "❌ Failed to start containers"; exit 1; }
    echo
else
    echo "   ℹ️ No changes detected, skipping Docker Compose update."
    echo
fi

echo "======================================================="
echo "         ✅ System Update Complete ✅"
echo "======================================================="