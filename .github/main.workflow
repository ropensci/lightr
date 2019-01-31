workflow "Lint markdown" {
  on = "push"
  resolves = ["mdlint"]
}

action "mdlint" {
  uses = "bltavares/actions/mdlint@24077f3"
}
