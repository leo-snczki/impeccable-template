# impeccable-template

A project with the [impeccable](https://github.com/pbakaus/impeccable) Claude Code skill and its engine, fetched by Nix.

Template repository: create a project from it with **Use this template** on
GitHub, then:

```sh
direnv allow   # or: nix develop
claude
```

The devShell links the skill from the Nix store into `.claude/skills/`
(gitignored). The input follows the skill repo's main branch: the `flake.lock`
that `nix develop` creates pins the commit, and `nix flake update` moves it.
To stay on a release, add its tag to the input URL in `flake.nix`.

