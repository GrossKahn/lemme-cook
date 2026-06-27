# lemme-cook
GDG Gamejam 2026 yeehaw

## Godot

Godot Version 4.7

Basic Rules/Styleguide for Godot and GDScript Stuff

### Code

- no globals variables

- Godot Naming Conventions
	- Nodes and Classes CamelCase
	- the rest in snake_case


### Node Communication

A Node manages their child nodes
- direct access allowed

But don't call up
- child nodes should not directly access a parent
	- don't use get parent
		- use signals

**call down, signal up**

Using Groups is another way to comunicate with other nodes

Using owner property to connect signals in case of nested is possible

[Source](https://kidscancode.org/godot_recipes/4.x/basics/node_communication/index.html)

## Git

### Branches

main
- holds major/stable versions
- merge from release branch
- don't work on this branch

hotfix
- if version on main needs a small patch
- create hotfix_<bug related name> branch from main
- (is this even needed?)

release
- merge from dev branch
- no new features introduced
- used for testing and applying bug fixes to the features
- only bug fixes, no major/breaking changes
- release_<fix_name> for branches created from it

dev
- merge target for feature branches
- create feature branches based on this branch

feature_branches
- dev_<feature_name>
- create branch based on dev branch
- add changes/new functionality
- merge into dev

### Commits

- based on [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary)
	- tldr; add type of commit as a prefix to the commit message
	- small additions made

#### Commit Messages

`[<type>]: <short description of the change>`

- keep it short and simple
- don't use filler language

#### Types

`[name of commit type]` when to use
- add ! to signal breaking change
	- `[type]! `

`[FIX]` patching bugs
`[FEAT]` adding or improving new feature
`[CHORE]` routine or maintenance tasks
`[DOCS]` changes to documentation
`[STYLE]` formatting, not changing meaning of code 
`[REFACTOR]` restructuring code or godot nodes
`[PERF]` code change for improving performance
`[REVERT]` when reverting commits
`[TEST]` changes related to testing
`[MERGE]` for merges
`[DESIGN]` for design related commits
