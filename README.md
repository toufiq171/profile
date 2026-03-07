# profile

Simple personal site hosted on GitHub Pages.

## Quick Agent

Use this as your main one-command manager:

```bash
./gitserver doctor
./gitserver build
./gitserver autopilot "Organize and publish website"
./gitserver run "Update profile website"
```

`run` will automatically pull, add, commit, and push.

## Site Agent

Use the built-in helper script to manage your workflow faster.

```bash
./site-agent.sh status
./site-agent.sh preview 8080
./site-agent.sh sync
./site-agent.sh publish "Update homepage text and links"
```

What it does:
- shows repo status + expected Pages URL
- runs local preview server
- syncs latest `main`
- commits and pushes your updates in one command
