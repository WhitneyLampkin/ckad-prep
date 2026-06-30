#!/bin/bash

# CKAD Practice Exam Verification Script
# Date: 2026-06-29
# This script checks each of the 10 tasks and reports what's correct or missing

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TOTAL_POINTS=0
EARNED_POINTS=0

print_header() {
    echo ""
    echo "======================================"
    echo "$1"
    echo "======================================"
}

check_pass() {
    echo -e "${GREEN}✓ PASS${NC}: $1"
    ((EARNED_POINTS += $2))
    ((TOTAL_POINTS += $2))
}

check_fail() {
    echo -e "${RED}✗ FAIL${NC}: $1"
    ((TOTAL_POINTS += $2))
}

check_warning() {
    echo -e "${YELLOW}⚠ WARNING${NC}: $1"
}

# Task 1: Service Exposure (NodePort)
print_header "Task 1: Service Exposure (NodePort) - 10 points"
if kubectl get svc web-frontend-nodeport -n frontend &>/dev/null; then
    svc_type=$(kubectl get svc web-frontend-nodeport -n frontend -o jsonpath='{.spec.type}')
    node_port=$(kubectl get svc web-frontend-nodeport -n frontend -o jsonpath='{.spec.ports[0].nodePort}')
    
    if [[ "$svc_type" == "NodePort" ]]; then
        check_pass "Service type is NodePort" 3
    else
        check_fail "Service type is $svc_type (expected NodePort)" 3
    fi
    
    if [[ "$node_port" == "30080" ]]; then
        check_pass "nodePort is 30080" 4
    else
        check_fail "nodePort is $node_port (expected 30080)" 4
    fi
    
    check_pass "Service web-frontend-nodeport exists in frontend namespace" 3
else
    check_fail "Service web-frontend-nodeport does not exist in frontend namespace" 10
fi

# Task 2: Troubleshoot Service Routing
print_header "Task 2: Troubleshoot Service Routing - 10 points"
if kubectl get svc payments-api-svc -n payments &>/dev/null; then
    target_port=$(kubectl get svc payments-api-svc -n payments -o jsonpath='{.spec.ports[0].targetPort}')
    
    if [[ "$target_port" == "5678" ]]; then
        check_pass "payments-api-svc targetPort is 5678" 5
    else
        check_fail "payments-api-svc targetPort is $target_port (expected 5678)" 5
    fi
    
    endpoints=$(kubectl get endpoints payments-api-svc -n payments -o jsonpath='{.subsets[*].addresses[*].targetRef.name}' 2>/dev/null)
    if [[ -n "$endpoints" ]]; then
        check_pass "Service endpoints are populated" 5
    else
        check_warning "Service endpoints appear to be empty (check if deployment is running)"
        ((TOTAL_POINTS += 5))
    fi
else
    check_fail "Service payments-api-svc does not exist in payments namespace" 10
fi

# Task 3: Network Policy Access Control
print_header "Task 3: Network Policy Access Control - 10 points"
if kubectl get networkpolicy allow-frontend-to-payments -n payments &>/dev/null; then
    check_pass "NetworkPolicy allow-frontend-to-payments exists" 3
    
    policy_yaml=$(kubectl get networkpolicy allow-frontend-to-payments -n payments -o yaml)
    
    if echo "$policy_yaml" | grep -q "app: payments-api"; then
        check_pass "Policy targets app=payments-api" 2
    else
        check_fail "Policy does not target app=payments-api" 2
    fi
    
    if echo "$policy_yaml" | grep -q "5678"; then
        check_pass "Policy specifies port 5678" 2
    else
        check_fail "Policy does not specify port 5678" 2
    fi
    
    if echo "$policy_yaml" | grep -q "access: allowed"; then
        check_pass "Policy requires access=allowed label from frontend" 2
    else
        check_warning "Policy may not check for access=allowed label from frontend"
        ((TOTAL_POINTS += 2))
    fi
    
    if echo "$policy_yaml" | grep -q "namespaceSelector"; then
        check_pass "Policy specifies namespace selector" 1
    else
        check_warning "Policy may not specify namespace selector for frontend"
        ((TOTAL_POINTS += 1))
    fi
else
    check_fail "NetworkPolicy allow-frontend-to-payments does not exist in payments namespace" 10
fi

# Task 4: Rolling Update and History
print_header "Task 4: Rolling Update and History - 10 points"
if kubectl get deployment web-frontend -n frontend &>/dev/null; then
    image=$(kubectl get deployment web-frontend -n frontend -o jsonpath='{.spec.template.spec.containers[0].image}')
    
    if [[ "$image" == "nginx:1.27" ]]; then
        check_pass "Deployment web-frontend image is nginx:1.27" 5
    else
        check_fail "Deployment web-frontend image is $image (expected nginx:1.27)" 5
    fi
    
    if kubectl rollout history deployment/web-frontend -n frontend &>/dev/null; then
        history=$(kubectl rollout history deployment/web-frontend -n frontend)
        if echo "$history" | grep -q "2\|3"; then
            check_pass "Rollout history has multiple revisions" 5
        else
            check_warning "Rollout history may not show update (run: kubectl set image deployment/web-frontend nginx=nginx:1.27 -n frontend --record)"
            ((TOTAL_POINTS += 5))
        fi
    fi
else
    check_fail "Deployment web-frontend does not exist in frontend namespace" 10
fi

# Task 5: Config and Secret Wiring
print_header "Task 5: Config and Secret Wiring - 10 points"
if kubectl get deployment worker -n ckad-exam &>/dev/null; then
    worker_yaml=$(kubectl get deployment worker -n ckad-exam -o yaml)
    
    app_mode_present=false
    db_user_present=false
    
    if echo "$worker_yaml" | grep -q "APP_MODE" && echo "$worker_yaml" | grep -q "configMapKeyRef"; then
        check_pass "ENV var APP_MODE is wired from ConfigMap" 5
        app_mode_present=true
    else
        check_fail "ENV var APP_MODE is not wired from ConfigMap" 5
    fi
    
    if echo "$worker_yaml" | grep -q "DB_USER" && echo "$worker_yaml" | grep -q "secretKeyRef"; then
        check_pass "ENV var DB_USER is wired from Secret" 5
        db_user_present=true
    else
        check_fail "ENV var DB_USER is not wired from Secret" 5
    fi
    
    if echo "$worker_yaml" | grep -q "shared-data"; then
        check_warning "Deployment has shared-data volume (verify PVC mount not removed)"
    fi
else
    check_fail "Deployment worker does not exist in ckad-exam namespace" 10
fi

# Task 6: Storage Task
print_header "Task 6: Storage Task (file-writer pod) - 10 points"
if kubectl get pod file-writer -n ckad-exam &>/dev/null; then
    pod_status=$(kubectl get pod file-writer -n ckad-exam -o jsonpath='{.status.phase}')
    
    if [[ "$pod_status" == "Running" ]] || [[ "$pod_status" == "Succeeded" ]]; then
        check_pass "Pod file-writer is in Running or Succeeded state" 4
    else
        check_fail "Pod file-writer is in $pod_status state (expected Running or Succeeded)" 4
    fi
    
    file_writer_yaml=$(kubectl get pod file-writer -n ckad-exam -o yaml)
    
    if echo "$file_writer_yaml" | grep -q "shared-data"; then
        check_pass "Pod mounts PVC shared-data" 3
    else
        check_fail "Pod does not mount PVC shared-data" 3
    fi
    
    if echo "$file_writer_yaml" | grep -q "/mnt/data"; then
        check_pass "Pod mounts PVC at /mnt/data" 3
    else
        check_fail "Pod does not mount at /mnt/data" 3
    fi
else
    check_fail "Pod file-writer does not exist in ckad-exam namespace" 10
fi

# Task 7: Job Creation
print_header "Task 7: Job Creation (db-migration) - 10 points"
if kubectl get job db-migration -n ckad-exam &>/dev/null; then
    check_pass "Job db-migration exists in ckad-exam namespace" 4
    
    completions=$(kubectl get job db-migration -n ckad-exam -o jsonpath='{.status.succeeded}')
    if [[ "$completions" == "1" ]]; then
        check_pass "Job has 1 successful completion" 6
    else
        check_warning "Job completion count is $completions (expected 1)"
        ((TOTAL_POINTS += 6))
    fi
else
    check_fail "Job db-migration does not exist in ckad-exam namespace" 10
fi

# Task 8: CronJob Adjustment
print_header "Task 8: CronJob Adjustment - 10 points"
if kubectl get cronjob cleanup -n ckad-exam &>/dev/null; then
    schedule=$(kubectl get cronjob cleanup -n ckad-exam -o jsonpath='{.spec.schedule}')
    
    if [[ "$schedule" == "*/5 * * * *" ]]; then
        check_pass "CronJob cleanup schedule is */5 * * * *" 10
    else
        check_fail "CronJob cleanup schedule is $schedule (expected */5 * * * *)" 10
    fi
else
    check_fail "CronJob cleanup does not exist in ckad-exam namespace" 10
fi

# Task 9: Pod Troubleshooting
print_header "Task 9: Pod Troubleshooting (broken-shell) - 10 points"
if kubectl get pod broken-shell -n ckad-exam &>/dev/null; then
    pod_status=$(kubectl get pod broken-shell -n ckad-exam -o jsonpath='{.status.phase}')
    
    if [[ "$pod_status" == "Running" ]]; then
        check_pass "Pod broken-shell is Running" 10
    else
        check_fail "Pod broken-shell is in $pod_status state (expected Running)" 10
    fi
else
    check_fail "Pod broken-shell does not exist in ckad-exam namespace" 10
fi

# Task 10: RBAC
print_header "Task 10: RBAC - 10 points"
rbac_points=0

if kubectl get serviceaccount deployer -n ckad-exam &>/dev/null; then
    check_pass "ServiceAccount deployer exists" 3
    rbac_points=$((rbac_points + 3))
else
    check_fail "ServiceAccount deployer does not exist" 3
    rbac_points=$((rbac_points - 3))
fi

if kubectl get role deployer-role -n ckad-exam &>/dev/null; then
    check_pass "Role deployer-role exists" 2
    rbac_points=$((rbac_points + 2))
    
    role_yaml=$(kubectl get role deployer-role -n ckad-exam -o yaml)
    if echo "$role_yaml" | grep -q "deployments" && echo "$role_yaml" | grep -q "apps"; then
        check_pass "Role allows deployments in apps apiGroup" 2
        rbac_points=$((rbac_points + 2))
    else
        check_fail "Role does not properly allow deployments in apps apiGroup" 2
    fi
else
    check_fail "Role deployer-role does not exist" 4
fi

if kubectl get rolebinding deployer-rb -n ckad-exam &>/dev/null; then
    check_pass "RoleBinding deployer-rb exists" 3
    rbac_points=$((rbac_points + 3))
else
    check_fail "RoleBinding deployer-rb does not exist" 3
fi

# Summary
print_header "EXAM SUMMARY"
percentage=$((EARNED_POINTS * 100 / TOTAL_POINTS))
echo "Points Earned: $EARNED_POINTS / $TOTAL_POINTS"
echo "Percentage: ${percentage}%"

if (( percentage >= 90 )); then
    echo -e "${GREEN}Grade: A (Excellent)${NC}"
elif (( percentage >= 80 )); then
    echo -e "${GREEN}Grade: B (Good)${NC}"
elif (( percentage >= 70 )); then
    echo -e "${YELLOW}Grade: C (Satisfactory)${NC}"
elif (( percentage >= 60 )); then
    echo -e "${YELLOW}Grade: D (Needs Improvement)${NC}"
else
    echo -e "${RED}Grade: F (Incomplete)${NC}"
fi

echo ""
echo "Time taken: ~45 minutes"
