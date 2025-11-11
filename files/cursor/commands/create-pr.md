# Create PR

## Overview

Create a well-structured pull request with proper description, labels, and reviewers.

## Steps

1. **Check for Local changes**

   - Run `git status | cat` and `git diff | cat` to check all differences and review the content of any newly created files.
   - If you want to check the contents of the current file, use `cat [filename]`.

2. **Code Quality and Bug Review**

   - Carefully analyze all changes shown in the diff and any new files created.
   - Look for and identify any of the following issues:
     - **Critical bugs:** Logic errors, null pointer exceptions, infinite loops, race conditions, etc.
     - **Code quality issues:** Code smells, overly complex methods, duplicated code, poor naming conventions
     - **Security vulnerabilities:** SQL injection, XSS, authentication bypass, sensitive data exposure
     - **Performance problems:** N+1 queries, inefficient algorithms, memory leaks
     - **Missing tests:** New functionality without corresponding tests
     - **Breaking changes:** API changes that could break existing functionality
     - **Configuration issues:** Missing environment variables, incorrect settings
     - **Documentation gaps:** Missing or outdated documentation for new features
   - If any significant issues are found:
     - Present a clear summary of the problems discovered
     - Ask the user: "I found some issues that should be addressed before creating the PR. Would you like me to fix these issues first, or proceed with the PR as-is?"
     - If the user chooses to fix issues, address them before continuing
     - If the user chooses to proceed, continue to the next step
   - If no significant issues are found, proceed to the next step.

3. **Prepare branch**

   - If you are currently on `main` branch, create and switch to a new uniquely-named branch (use a clear, descriptive name).
   - If you are already on a non-main branch:
     - Ask the user if you should commit and open a PR from the current branch, or create a new branch from main and continue there.
     - If a new branch from main is requested:
       1. Temporarily stash local changes (git stash).
       2. Switch to main and pull the latest changes (`git switch main && git pull`).
       3. Create and switch to a new branch from main.
       4. Apply the stashed changes by `git stash pop`.
     - If the user chooses to continue on the current branch, proceed to the next step.

4. **Select Files for Commit**

   - Stage **all** modified, created, or deleted files by `git add -A`
   - If there are obviously unrelated files (e.g. temporary files, config files, or others not relevant to the changes), ask the user whether to include them in the commit.

5. **Commit Changes**

   - Write the commit message in **English**, following the **Commit Message Guidelines** below.
   - The commit message should be a single, concise line.
   - Example:
     ```
     git commit -m "feat(auth): add login functionality"
     ```

6. **Push the Branch**

   - Push the branch to the remote repository: `git push -u origin <branch-name>`

7. **Create the Pull Request via GitHub CLI**

   - Use the `gh` command to create the pull request.
   - **IMPORTANT:** The PR **title and body must always be written in English**, regardless of the user's language.
   - The **PR title** must follow the **Commit Message Guidelines** (see below).
   - The **PR body** should contain:
     - A clear summary of what was changed
     - A detailed explanation of why these changes are needed
     - A bullet-point list of the specific changes made
     - Use appropriate section headers and formatting for clarity.
     - List any breaking changes
     - Add screenshots if UI changes
   - Use command:
     ```
     gh pr create --title '<PR title>' --body $'<PR body>' && gh pr view --web
     ```
     (Use $'...' to handle newlines properly and open the PR in the browser.)
   - Link related issues on Linear

NOTE: **If any step or required information is unclear, always ask the user for clarification before proceeding.**

## Commit Message Guidelines

- **Format:** <type>[optional scope]: <description>
- **Types:**
  - feat: A new feature
  - fix: A bug fix
  - docs: Documentation only changes
  - style: Changes that do not affect the meaning of the code
  - refactor: A code change that neither fixes a bug nor adds a feature
  - perf: A code change that improves performance
  - test: Adding missing tests or correcting existing tests
  - chore: Changes to the build process or auxiliary tools
- **Description:** Use present tense, start with a lowercase letter, and keep it short and concise (one line).
- **Examples:**
  - `feat(auth): add login functionality`
  - `fix: resolve memory leak issue`
