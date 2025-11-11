# Create Quick PR

## Overview

Create a lightweight pull request quickly by skipping the in-depth "Code Quality and Bug Review" step. Use this for small, low-risk changes (e.g., documentation tweaks, copy fixes, minor UI text updates).

## Steps

1. **Check for Local changes**

   - Run `git status | cat` and `git diff | cat` to review all differences and the content of any newly created files.
   - If you want to check the contents of the current file, use `cat [filename]`.

2. **Prepare branch**

   - If you are currently on `main`, create and switch to a new uniquely-named branch (use a clear, descriptive name).
   - If you are already on a non-main branch:
     - Ask the user if you should commit and open a PR from the current branch, or create a new branch from main and continue there.
     - If a new branch from main is requested:
       1. Temporarily stash local changes (`git stash`).
       2. Switch to main and pull the latest changes (`git switch main && git pull`).
       3. Create and switch to a new branch from main.
       4. Apply the stashed changes by `git stash pop`.

3. **Select Files for Commit**

   - Stage modified, created, or deleted files with `git add -A`.
   - If there are obviously unrelated files (e.g. temporary files, config files, or others not relevant to the changes), ask whether to include them; otherwise leave them out.

4. **Commit Changes**

   - Write the commit message in **English**, as a single concise line (see guidelines below).
   - Example:
     ```
     git commit -m "chore: minor copy tweaks"
     ```

5. **Push the Branch**

   - Push the branch to the remote repository:
     ```
     git push -u origin <branch-name>
     ```

6. **Create the Pull Request via GitHub CLI**

   - **IMPORTANT:** The PR **title and body must always be written in English**.
   - Fastest option (auto-fill from the latest commit message):
     ```
     gh pr create --fill --web
     ```
   - Or specify title and body explicitly:
     ```
     gh pr create --title '<PR title>' --body $'<PR body>' && gh pr view --web
     ```

NOTE: **If any step or required information is unclear, ask the user for clarification before proceeding.**

## Commit Message Guidelines

- **Format:** <type>[optional scope]: <description>
- **Types:** feat, fix, docs, style, refactor, perf, test, chore
- **Description:** Use present tense, start with a lowercase letter, keep it concise (one line).

**Examples:**

- `feat: add export button`
- `chore: update README instructions`
