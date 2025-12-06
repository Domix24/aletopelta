# Aletopelta

**[Advent of Code](https://adventofcode.com)**

This repository contains my solutions for Advent of Code.  
I am using my own framework [Belodon](https://github.com/domix24/belodon) to handle the puzzle

## Key Dates
_maybe could be interesting in the future_
- *Started* learning Elixir - December 4, 2024
- *Known* about Advent of Code - During the month of November 2024 from Twitch
- *Known* about Elixir - Probably between December 1st and December 4th, saw some Elixir code and got interested by the |> operator

## Note
This was my _very first_ time with Elixir, I kept all of my old code into another branch [old-main](https://github.com/Domix24/aletopelta/tree/old-main) so you can the progress through the days.

## Lesson learned
**DO NOT USE** `git filter-branch` as I did.  
It removed commit signatures from all commits—even the unfiltered ones.  
I learned that you can change commit dates with `git commit --date` or by setting `GIT_AUTHOR_DATE`. However, GitHub displays the committer date (`GIT_COMMITTER_DATE`), while git log shows the author date (`GIT_AUTHOR_DATE`).

For posterity, the command I ran was:
```bash
git filter-branch --env-filter '
  if test "$GIT_COMMIT" = "ea8925f4e7bf991491ca5eb59229dbe1de02aea7"
  then
    GIT_COMMITTER_DATE=$GIT_AUTHOR_DATE
  fi
'
```

and the output:
```text
Rewrite ea8925f4e7bf991491ca5eb59229dbe1de02aea7 (233/235) (7 seconds passed, remaining 0 predicted)
Ref 'refs/heads/main' was rewritten
```

### Useful commands
- Show dates `git log --format=fuller`
- Edit dates `GIT_COMMITTER_DATE=2025-12-05T14:00:00 git commit --amend --no-edit --date=2025-12-05T15:00:00`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aletopelta` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aletopelta, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/aletopelta>.

