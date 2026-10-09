#!/usr/bin/env bash
set -uo pipefail

ROOT="${LAB_ROOT:-$HOME/lab}"
MANIFEST="$ROOT/manifests/projects.tsv"
LOG="$ROOT/logs/bootstrap.log"

mkdir -p "$ROOT"/{manifests,scripts,logs,reports,datasets/{pcaps,memory,disk-images},vms}
touch "$LOG"
printf 'category\tname\turl\tstatus\n' >"$MANIFEST"

PROJECTS=$(
    cat <<'EOF'
web|dvwa|https://github.com/digininja/DVWA.git
web|juice-shop|https://github.com/juice-shop/juice-shop.git
web|mutillidae|https://github.com/webpwnized/mutillidae.git
web|security-shepherd|https://github.com/OWASP/SecurityShepherd.git
web|webgoat|https://github.com/WebGoat/WebGoat.git
web|nodegoat|https://github.com/OWASP/NodeGoat.git
web|railsgoat|https://github.com/OWASP/railsgoat.git
web|vuln-apps-tronic|https://github.com/demianseiler/vuln-tronic-labs.git
api-auth|crapi|https://github.com/OWASP/crAPI.git
api-auth|vampi|https://github.com/erev0s/VAmPI.git
api-auth|dvga|https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application.git
api-auth|wrongsecrets|https://github.com/OWASP/wrongsecrets.git
cve-reproduction|vulhub|https://github.com/vulhub/vulhub.git
active-directory|goad|https://github.com/Orange-Cyberdefense/GOAD.git
blue-team|atomic-red-team|https://github.com/redcanaryco/atomic-red-team.git
blue-team|caldera|https://github.com/mitre/caldera.git
blue-team|sigma|https://github.com/SigmaHQ/sigma.git
blue-team|chainsaw|https://github.com/WithSecureLabs/chainsaw.git
blue-team|hayabusa|https://github.com/Yamato-Security/hayabusa.git
dfir|volatility3|https://github.com/volatilityfoundation/volatility3.git
dfir|memlabs|https://github.com/stuxnet999/MemLabs.git
dfir|plaso|https://github.com/log2timeline/plaso.git
reversing|flare-learning-hub|https://github.com/mandiant/flare-learning-hub.git
reversing|flare-vm|https://github.com/mandiant/flare-vm.git
osint|tlosint-vm|https://github.com/tracelabs/tlosint-vm.git
osint|sherlock|https://github.com/sherlock-project/sherlock.git
osint|spiderfoot|https://github.com/smicallef/spiderfoot.git
mobile-iot|diva-android|https://github.com/payatu/diva-android.git
mobile-iot|androgoat|https://github.com/satishpatnayak/AndroGoat.git
mobile-iot|iotgoat|https://github.com/OWASP/IoTGoat.git
cloud-devsecops|cloudgoat|https://github.com/RhinoSecurityLabs/cloudgoat.git
cloud-devsecops|cicd-goat|https://github.com/cider-security-research/cicd-goat.git
cloud-devsecops|kubernetes-goat|https://github.com/madhuakula/kubernetes-goat.git
cloud-devsecops|kube-goat|https://github.com/ksoclabs/kube-goat.git
EOF
)

while IFS='|' read -r category name url; do
    [[ -n "$category" ]] || continue
    dest="$ROOT/$category/$name"
    mkdir -p "$ROOT/$category"

    if [[ -d "$dest/.git" ]]; then
        echo "[SKIP] $category/$name ya existe"
        printf '%s\t%s\t%s\t%s\n' "$category" "$name" "$url" "already-present" >>"$MANIFEST"
        continue
    fi

    if [[ -e "$dest" ]]; then
        echo "[WARN] Ruta existente no gestionada por Git: $dest"
        printf '%s\t%s\t%s\t%s\n' "$category" "$name" "$url" "path-conflict" >>"$MANIFEST"
        continue
    fi

    echo "[CLONE] $category/$name"
    if git clone --depth 1 "$url" "$dest" >>"$LOG" 2>&1; then
        printf '%s\t%s\t%s\t%s\n' "$category" "$name" "$url" "cloned" >>"$MANIFEST"
    else
        echo "[ERROR] Falló $url; revisa $LOG"
        printf '%s\t%s\t%s\t%s\n' "$category" "$name" "$url" "failed" >>"$MANIFEST"
    fi
done <<<"$PROJECTS"

echo
echo "Catálogo: $MANIFEST"
echo "Registro: $LOG"
echo "No se han iniciado laboratorios."
