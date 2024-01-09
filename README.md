# json-keys-diff-hook

A pre-commit hook that executes the jkdiff command from json-keys-diff NPM package

## Usage

### Validate al matching files of the repo

This hook will check modified files and will compare matching files between each other where ever they are placed on
the project.

```yaml
- repo: https://github.com/Drafteame/json-keys-diff-hook
  rev: main
  hooks:
    - id: jkdiff-files
      args: '"json$"' # Regexp to match file names (including path)
```

### Validate matching files per folder

This hook will check modified files and if some one match the provided expression, all matching files inside it's
folder will be compared between each other.

```yaml
- repo: https://github.com/Drafteame/json-keys-diff-hook
  rev: main
  hooks:
    - id: jkdiff-folder
      args: '"json$"' # Regexp to match file names (including path)
```
