# GitHub upload

## Include

```text
README.md
LICENSE
.gitignore
github_upload.md
config/
workflow/
envs/
docs/rnaseq.md
docs/atacseq.md
docs/advanced_atac.md
docs/enrichment.md
docs/integration.md
docs/figures.md
docs/analysis-notebook.md
scripts/README.md
results/.gitkeep
```

Do not upload `Source/`, `docs/provenance.md`, `docs/superpowers/`, `.codex-progress.md`, `data/`, `work/`, generated results, sequencing files, or local genome references.

## Manual commands

Run from the repository root in Git Bash. Replace the remote URL.

```bash
# 1. Confirm the project directory.
pwd

# 2. Initialize Git if needed.
git init

# 3. Review the working tree.
git status --short

# 4. Stage only the showcase files.
git add README.md LICENSE .gitignore github_upload.md config workflow envs scripts/README.md results/.gitkeep
git add docs/rnaseq.md docs/atacseq.md docs/advanced_atac.md docs/enrichment.md docs/integration.md docs/figures.md docs/analysis-notebook.md

# 5. Review staged files.
git diff --cached --name-only

# 6. Check that supporting documents and large data are absent.
git diff --cached --name-only | grep -E '^(Source/|docs/provenance|docs/superpowers|\.codex-progress\.md|data/|work/|.*\.(pptx|docx|rtf|xlsx|fastq|bam|bigWig|bw)$)' && echo "Remove an unintended file" || echo "Staged selection looks clean"

# 7. Review whitespace and the staged diff.
git diff --cached --check
git diff --cached --stat
git diff --cached

# 8. Commit.
git commit -m "Add CB6644 multi-omics showcase workflow"

# 9. Set the main branch.
git branch -M main

# 10. Add the GitHub remote.
# If origin already exists, use: git remote set-url origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git remote -v

# 11. Push.
git push -u origin main
```
