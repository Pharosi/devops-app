package dockerfile

deny contains msg if {
    input[i].Cmd == "user"
    val := input[i].Value
    val[_] == "root"
    msg := "Les conteneurs ne doivent pas tourner en root"
}

deny contains msg if {
    not any_user
    msg := "Le Dockerfile doit contenir une instruction USER"
}

any_user if {
    input[i].Cmd == "user"
}

deny contains msg if {
    input[i].Cmd == "from"
    val := input[i].Value
    contains(val[0], ":latest")
    msg := sprintf("Éviter le tag :latest, utiliser un tag spécifique : %s", [val[0]])
}

deny contains msg if {
    not any_healthcheck
    msg := "Le Dockerfile doit contenir un HEALTHCHECK"
}

any_healthcheck if {
    input[i].Cmd == "healthcheck"
}
