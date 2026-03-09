...

let project = Project(
    ...,
    targets: [
        .target(
            name: "App",
            ...,
            sources: [
                .glob(
                    pattern: "Sources/**",
                    excluding: ["**/*+CoreDataClass.swift"]
                )
            ],
            resources: [
                .glob(pattern: "Resources/**",
                      excluding: ["Resources/Datas/sendadv.xcdatamodeld/**"])
            ],
        )
    ]
)