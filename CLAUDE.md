# Project skills

Claude Code must run inside the devShell (`nix develop`, or direnv with
`use flake`): it links the skill into `.claude/skills/` and puts its tools
on PATH. If the skill is missing, enter the devShell and restart Claude.

- `impeccable`: design critique, audit, polish, animation and
  anti-pattern checks for any frontend; its sub-commands are listed in
  the skill. Its engine comes from Nix (`IMPECCABLE_BIN`), so the
  launcher downloads nothing.
