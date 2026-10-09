# UltimateCybersecurityLabs

A modular cybersecurity lab collection for Arch Linux and other Linux distributions.

## Domains

- Web application security
- REST and GraphQL API security
- Red Team and Active Directory
- Blue Team and detection engineering
- Digital forensics and incident response (DFIR)
- Reverse engineering and malware analysis
- OSINT and digital investigations
- Network security, DNS, and protocol analysis
- Cloud security, DevSecOps, CI/CD, Docker, and Kubernetes
- Mobile application security and IoT
- CVE reproduction and vulnerable-by-design applications
- CTFs and educational datasets

## Design principles

- Modular installation by category
- Reproducible setup and documented dependencies
- Isolated vulnerable environments
- External projects remain separate from this repository
- No vulnerable services are started automatically

## Quick start

Review the project manifest and scripts before executing them.

```bash
column -ts $'\t' manifests/projects.tsv
less scripts/bootstrap.sh
```
