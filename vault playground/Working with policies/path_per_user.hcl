path "my_org/IT/personal*" {
    capabilities=[
        "deny"
    ]
}

path "my_org/IT/personal/{{identity.entity.id}}/*" {
    capabilities=[
        "create",
        "read",
        "update",
        "delete",
        "list"
    ]
    required_parameters = ["name"]
    allowed_parameters = {
        "name" = []
        "pass" = []
    }
    denied_parameters = {
        "pass" = ["kkk"]
    }
}

path "my_org/IT/personal/{{identity.entity.id}}*" {
    capabilities=[
        "list"
    ]
}