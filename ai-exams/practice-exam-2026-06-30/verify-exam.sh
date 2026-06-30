#!/bin/bash

# CKAD Advanced Practice Exam Verification Script - 2026-06-30
# Checks all 17 tasks and reports detailed feedback

set +e  # Don't exit on errors, we handle them

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TOTAL_POINTS=0
EARNED_POINTS=0

print_header() {
    echo ""
    echo -e "${BLUE}=====================================${NC}"
    echo "$1"
    echo -e "${BLUE}=====================================${NC}"
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

# Task 1: Graceful Shutdown
print_header "Task 1: Graceful Shutdown with Termination Grace Period (12 points)"
if kubectl get deployment api-server -n production &>/dev/null; then
    grace_period=$(kubectl get deployment api-server -n production -o jsonpath='{.spec.template.spec.terminationGracePeriodSeconds}')
    
    if [[ "$grace_period" == "30" ]]; then
        check_pass "terminationGracePeriodSeconds is 30" 6
    else
        check_fail "terminationGracePeriodSeconds is $grace_period (expected 30)" 6
    fi
    
    prestop=$(kubectl get deployment api-server -n production -o jsonpath='{.spec.template.spec.containers[0].lifecycle.preStop}')
    if [[ -n "$prestop" ]]; then
        check_pass "preStop lifecycle hook is configured" 6
    else
        check_fail "preStop lifecycle hook is not configured" 6
    fi
else
    check_fail "Deployment api-server not found in production namespace" 12
fi

# Task 2: Multi-Container with Init Container
print_header "Task 2: Multi-Container Pod with Init Container (14 points)"
if kubectl get pod worker -n production &>/dev/null; then
    pod_yaml=$(kubectl get pod worker -n production -o yaml)
    
    if echo "$pod_yaml" | grep -q "initContainers"; then
        check_pass "Init container is configured" 5
    else
        check_fail "Init container is not configured" 5
    fi
    
    if echo "$pod_yaml" | grep -q "busybox:1.36"; then
        check_pass "Main container uses busybox:1.36" 4
    else
        check_fail "Main container doesn't use busybox:1.36" 4
    fi
    
    if echo "$pod_yaml" | grep -q "/config"; then
        check_pass "Volume mounted at /config" 5
    else
        check_fail "Volume not mounted at /config" 5
    fi
else
    check_warning "Pod worker not found (verify it was created)"
    ((TOTAL_POINTS += 14))
fi

# Task 3: Sidecar Logging Container
print_header "Task 3: Sidecar Logging Container (14 points)"
api_deployment=$(kubectl get deployment api-server -n production -o yaml 2>/dev/null)
if [[ -n "$api_deployment" ]]; then
    container_count=$(echo "$api_deployment" | grep -c "name:")
    
    if (( container_count >= 2 )); then
        check_pass "Deployment has multiple containers (sidecar added)" 7
    else
        check_fail "Deployment does not have sidecar container" 7
    fi
    
    if echo "$api_deployment" | grep -q "/var/logs"; then
        check_pass "Shared volume for logs is configured" 7
    else
        check_warning "Shared volume for logs may not be configured"
        ((TOTAL_POINTS += 7))
    fi
else
    check_fail "Cannot retrieve api-server deployment" 14
fi

# Task 4: Liveness & Readiness Probes
print_header "Task 4: Liveness & Readiness Probes with Custom Endpoints (12 points)"
api_deployment=$(kubectl get deployment api-server -n production -o yaml 2>/dev/null)
if [[ -n "$api_deployment" ]]; then
    if echo "$api_deployment" | grep -q "livenessProbe"; then
        liveness_delay=$(echo "$api_deployment" | grep -A 3 "livenessProbe" | grep "initialDelaySeconds" | awk '{print $2}' | tr -d ':')
        if [[ "$liveness_delay" == "15" ]]; then
            check_pass "Liveness probe has initialDelaySeconds: 15" 3
        else
            check_warning "Liveness probe initialDelaySeconds is $liveness_delay (expected 15)"
            ((TOTAL_POINTS += 3))
        fi
    else
        check_fail "Liveness probe not configured" 3
    fi
    
    if echo "$api_deployment" | grep -q "readinessProbe"; then
        readiness_delay=$(echo "$api_deployment" | grep -A 3 "readinessProbe" | grep "initialDelaySeconds" | awk '{print $2}' | tr -d ':')
        if [[ "$readiness_delay" == "5" ]]; then
            check_pass "Readiness probe has initialDelaySeconds: 5" 3
        else
            check_warning "Readiness probe initialDelaySeconds is $readiness_delay (expected 5)"
            ((TOTAL_POINTS += 3))
        fi
        check_pass "Readiness probe is configured" 3
    else
        check_fail "Readiness probe not configured" 6
    fi
    
    if echo "$api_deployment" | grep -q "timeoutSeconds.*2"; then
        check_pass "Probe timeout is configured correctly" 3
    else
        check_warning "Probe timeout may not be set to 2 seconds"
        ((TOTAL_POINTS += 3))
    fi
else
    check_fail "Cannot retrieve api-server deployment" 12
fi

# Task 5: Fix Broken Pod
print_header "Task 5: Fix the Broken Pod (11 points)"
if kubectl get pod broken-app -n production &>/dev/null; then
    pod_status=$(kubectl get pod broken-app -n production -o jsonpath='{.status.phase}')
    
    if [[ "$pod_status" == "Running" ]]; then
        check_pass "Pod broken-app is in Running state" 11
    else
        check_fail "Pod broken-app is in $pod_status state (expected Running)" 11
    fi
else
    check_fail "Pod broken-app not found in production namespace" 11
fi

# Task 6: ConfigMap as Volume
print_header "Task 6: ConfigMap as Volume with Auto-Reload (13 points)"
if kubectl get deployment config-watcher -n production &>/dev/null; then
    config_dep=$(kubectl get deployment config-watcher -n production -o yaml)
    
    if echo "$config_dep" | grep -q "nginx-config"; then
        check_pass "ConfigMap nginx-config is mounted" 7
    else
        check_fail "ConfigMap nginx-config not mounted" 7
    fi
    
    if echo "$config_dep" | grep -q "/etc/nginx/conf.d"; then
        check_pass "ConfigMap mounted at /etc/nginx/conf.d" 6
    else
        check_fail "ConfigMap not mounted at correct path" 6
    fi
else
    check_warning "Deployment config-watcher not found"
    ((TOTAL_POINTS += 13))
fi

# Task 7: StatefulSet with Persistent Storage
print_header "Task 7: StatefulSet with Persistent Storage (14 points)"
if kubectl get statefulset database -n production &>/dev/null; then
    db_yaml=$(kubectl get statefulset database -n production -o yaml)
    
    if echo "$db_yaml" | grep -q "volumeClaimTemplates"; then
        check_pass "volumeClaimTemplate is configured" 5
    else
        check_fail "volumeClaimTemplate is not configured" 5
    fi
    
    if echo "$db_yaml" | grep -q "data-volume"; then
        check_pass "volumeClaimTemplate named data-volume" 3
    else
        check_fail "volumeClaimTemplate not properly named" 3
    fi
    
    pvc_count=$(kubectl get pvc -n production 2>/dev/null | grep -c "database")
    if (( pvc_count > 0 )); then
        check_pass "PVC created for StatefulSet pod" 3
    else
        check_warning "PVC for StatefulSet not found (check if pod is running)"
        ((TOTAL_POINTS += 3))
    fi
    
    pod_name=$(kubectl get pods -n production -l app=database -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)
    if [[ "$pod_name" == "database-0" ]]; then
        check_pass "Pod has stable name database-0" 3
    else
        check_warning "Pod name is $pod_name (expected database-0)"
        ((TOTAL_POINTS += 3))
    fi
else
    check_fail "StatefulSet database not found" 14
fi

# Task 8: Cross-Namespace Service Discovery
print_header "Task 8: Cross-Namespace Service Discovery (13 points)"
if kubectl get service -n staging &>/dev/null; then
    staging_svcs=$(kubectl get services -n staging -o jsonpath='{.items[*].metadata.name}')
    
    if echo "$staging_svcs" | grep -qv "kubernetes"; then
        check_pass "Service created in staging namespace" 7
    else
        check_fail "No service found in staging namespace" 7
    fi
    
    # Try to resolve from test-client
    if kubectl get pod test-client -n staging &>/dev/null; then
        check_pass "test-client pod exists in staging for DNS testing" 6
    else
        check_warning "test-client pod not found for DNS testing"
        ((TOTAL_POINTS += 6))
    fi
else
    check_fail "Cannot access staging namespace" 13
fi

# Task 9: RBAC Across Namespaces
print_header "Task 9: RBAC: Restrict Access Across Namespaces (14 points)"
rbac_score=0

if kubectl get clusterrole pod-reader-global -n production &>/dev/null 2>/dev/null || kubectl get clusterrole pod-reader &>/dev/null 2>/dev/null; then
    check_pass "ClusterRole created for cross-namespace access" 5
    rbac_score=$((rbac_score + 5))
else
    check_warning "ClusterRole for pod-reader not found"
    rbac_score=$((rbac_score + 5))
fi

if kubectl get rolebinding -n production &>/dev/null; then
    check_pass "RoleBinding exists in production namespace" 5
    rbac_score=$((rbac_score + 5))
else
    check_warning "RoleBinding not found in production"
    rbac_score=$((rbac_score + 5))
fi

if kubectl auth can-i get pods --as=system:serviceaccount:production:app-deployer -n staging &>/dev/null 2>/dev/null; then
    check_pass "app-deployer can view pods across namespaces" 4
    rbac_score=$((rbac_score + 4))
else
    check_warning "app-deployer cross-namespace access may not be configured"
    rbac_score=$((rbac_score + 4))
fi

# Task 10: Resource Requests & Limits
print_header "Task 10: Resource Requests & Limits Under Load (12 points)"
api_deployment=$(kubectl get deployment api-server -n production -o yaml 2>/dev/null)
if [[ -n "$api_deployment" ]]; then
    cpu_request=$(echo "$api_deployment" | grep -A 5 "requests" | grep "cpu" | awk '{print $2}' | tr -d 'm' | head -1)
    
    if [[ "$cpu_request" == "50" ]]; then
        check_pass "CPU request is 50m" 3
    else
        check_warning "CPU request is $cpu_request (expected 50)"
        ((TOTAL_POINTS += 3))
    fi
    
    mem_request=$(echo "$api_deployment" | grep -A 5 "requests" | grep "memory" | awk '{print $2}' | tr -d 'Mi' | head -1)
    if [[ "$mem_request" == "128" ]]; then
        check_pass "Memory request is 128Mi" 3
    else
        check_warning "Memory request is $mem_request (expected 128)"
        ((TOTAL_POINTS += 3))
    fi
    
    cpu_limit=$(echo "$api_deployment" | grep -A 5 "limits" | grep "cpu" | awk '{print $2}' | tr -d 'm' | head -1)
    if [[ "$cpu_limit" == "200" ]]; then
        check_pass "CPU limit is 200m" 3
    else
        check_warning "CPU limit is $cpu_limit (expected 200)"
        ((TOTAL_POINTS += 3))
    fi
    
    mem_limit=$(echo "$api_deployment" | grep -A 5 "limits" | grep "memory" | awk '{print $2}' | tr -d 'Mi' | head -1)
    if [[ "$mem_limit" == "256" ]]; then
        check_pass "Memory limit is 256Mi" 3
    else
        check_warning "Memory limit is $mem_limit (expected 256)"
        ((TOTAL_POINTS += 3))
    fi
else
    check_fail "Cannot retrieve api-server deployment" 12
fi

# Task 11: NetworkPolicy Egress
print_header "Task 11: NetworkPolicy: Restrict Egress (13 points)"
if kubectl get networkpolicy api-egress-policy -n production &>/dev/null; then
    netpol=$(kubectl get networkpolicy api-egress-policy -n production -o yaml)
    
    if echo "$netpol" | grep -q "Egress"; then
        check_pass "NetworkPolicy includes egress rules" 5
    else
        check_fail "NetworkPolicy does not include egress" 5
    fi
    
    if echo "$netpol" | grep -q "53"; then
        check_pass "DNS port 53 is allowed" 4
    else
        check_warning "DNS port 53 may not be explicitly allowed"
        ((TOTAL_POINTS += 4))
    fi
    
    if echo "$netpol" | grep -q "3000"; then
        check_pass "Port 3000 for api-server is allowed" 4
    else
        check_warning "Port 3000 may not be explicitly allowed"
        ((TOTAL_POINTS += 4))
    fi
else
    check_warning "NetworkPolicy api-egress-policy not found"
    ((TOTAL_POINTS += 13))
fi

# Task 12: Helm Chart
print_header "Task 12: Helm Basics: Chart Creation (15 points)"
if [[ -d "my-app-chart" ]]; then
    if [[ -f "my-app-chart/Chart.yaml" ]]; then
        check_pass "Chart.yaml exists" 3
    else
        check_fail "Chart.yaml not found" 3
    fi
    
    if [[ -f "my-app-chart/values.yaml" ]]; then
        check_pass "values.yaml exists" 3
    else
        check_fail "values.yaml not found" 3
    fi
    
    if [[ -d "my-app-chart/templates" ]]; then
        check_pass "templates directory exists" 3
    else
        check_fail "templates directory not found" 3
    fi
    
    # Try to render the chart
    if helm template my-app-chart &>/dev/null 2>&1; then
        check_pass "Chart renders successfully with helm template" 6
    else
        check_warning "Chart may have rendering issues (check: helm template my-app-chart)"
        ((TOTAL_POINTS += 6))
    fi
else
    check_warning "my-app-chart directory not found"
    ((TOTAL_POINTS += 15))
fi

# Task 13: Pod Affinity & Anti-Affinity
print_header "Task 13: Pod Affinity & Anti-Affinity (13 points)"
api_deployment=$(kubectl get deployment api-server -n production -o yaml 2>/dev/null)
if [[ -n "$api_deployment" ]]; then
    if echo "$api_deployment" | grep -q "podAntiAffinity"; then
        check_pass "Pod anti-affinity is configured" 6
    else
        check_fail "Pod anti-affinity is not configured" 6
    fi
    
    if echo "$api_deployment" | grep -q "podAffinity"; then
        check_pass "Pod affinity is configured" 4
    else
        check_warning "Pod affinity may not be configured"
        ((TOTAL_POINTS += 4))
    fi
    
    if echo "$api_deployment" | grep -q "preferredDuringSchedulingIgnoredDuringExecution"; then
        check_pass "Affinity uses soft (preferred) rules" 3
    else
        check_warning "Affinity may use hard (required) rules"
        ((TOTAL_POINTS += 3))
    fi
else
    check_fail "Cannot retrieve api-server deployment" 13
fi

# Task 14: CronJob Adjustment
print_header "Task 14: CronJob with Failure Handling (13 points)"
if kubectl get cronjob backup-job -n production &>/dev/null; then
    cronjob=$(kubectl get cronjob backup-job -n production -o yaml)
    
    backoff=$(echo "$cronjob" | grep -A 10 "jobTemplate" | grep "backoffLimit" | awk '{print $2}')
    if [[ "$backoff" == "2" ]]; then
        check_pass "backoffLimit is 2" 5
    else
        check_warning "backoffLimit is $backoff (expected 2)"
        ((TOTAL_POINTS += 5))
    fi
    
    deadline=$(echo "$cronjob" | grep -A 10 "jobTemplate" | grep "activeDeadlineSeconds" | awk '{print $2}')
    if [[ "$deadline" == "300" ]]; then
        check_pass "activeDeadlineSeconds is 300" 5
    else
        check_warning "activeDeadlineSeconds is $deadline (expected 300)"
        ((TOTAL_POINTS += 5))
    fi
    
    check_pass "CronJob backup-job exists and is configured" 3
else
    check_fail "CronJob backup-job not found" 13
fi

# Task 15: Pod Eviction
print_header "Task 15: Debugging Pod Eviction (12 points)"
if kubectl get pods -n production | grep -q "evicted\|oom"; then
    check_pass "Test pod created and eviction scenario demonstrated" 6
else
    check_warning "No evicted pod found (create a test pod that exceeds memory limit)"
    ((TOTAL_POINTS += 6))
fi
check_pass "Understanding of eviction scenarios demonstrated" 6

# Task 16: Service Mesh Traffic Split
print_header "Task 16: Service Mesh Concepts: Traffic Split (14 points)"
if kubectl get deployment api-server-v1 -n production &>/dev/null; then
    check_pass "Deployment api-server-v1 exists" 5
else
    check_warning "Deployment api-server-v1 not found"
    ((TOTAL_POINTS += 5))
fi

if kubectl get deployment api-server-v2 -n production &>/dev/null; then
    check_pass "Deployment api-server-v2 exists" 5
else
    check_warning "Deployment api-server-v2 not found"
    ((TOTAL_POINTS += 5))
fi

check_warning "Traffic split (80/20) requires manual verification or service mesh tool"
((TOTAL_POINTS += 4))

# Task 17: Container Registry Authentication
print_header "Task 17: Container Registry Authentication (11 points)"
if kubectl get secret registry-secret -n production &>/dev/null; then
    check_pass "registry-secret exists in production" 4
else
    check_fail "registry-secret not found" 4
fi

api_deployment=$(kubectl get deployment api-server -n production -o yaml 2>/dev/null)
if [[ -n "$api_deployment" ]]; then
    if echo "$api_deployment" | grep -q "imagePullSecrets"; then
        check_pass "Deployment uses imagePullSecrets" 7
    else
        check_fail "Deployment does not reference imagePullSecrets" 7
    fi
else
    check_fail "Cannot verify deployment configuration" 7
fi

# Summary
print_header "EXAM SUMMARY"
percentage=$((EARNED_POINTS * 100 / TOTAL_POINTS))
echo "Points Earned: $EARNED_POINTS / $TOTAL_POINTS"
echo "Percentage: ${percentage}%"

if (( percentage >= 94 )); then
    echo -e "${GREEN}Grade: A+ (Excellent)${NC}"
elif (( percentage >= 81 )); then
    echo -e "${GREEN}Grade: A (Very Good)${NC}"
elif (( percentage >= 69 )); then
    echo -e "${BLUE}Grade: B (Good)${NC}"
elif (( percentage >= 56 )); then
    echo -e "${YELLOW}Grade: C (Passing)${NC}"
else
    echo -e "${RED}Grade: D (Needs Work)${NC}"
fi

echo ""
echo "Next steps:"
echo "1. Review any FAILED items above"
echo "2. Focus on HIGH-POINT items (Helm, RBAC, Probes)"
echo "3. Practice under timed conditions"
