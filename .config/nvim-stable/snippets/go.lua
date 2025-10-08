---@diagnostic disable: undefined-global

return {
    s({ trig = "iferr" },
        fmta(
            [[
                if err != nil {
                    <>
                }
            ]],
            {
                i(1)
            }
        )
    ),
    s({ trig = "handler" },
        fmta(
            [[
                func <>(w http.ResponseWriter, r *http.Request) {
                    <>
                }
            ]],
            {
                i(1, "handlerName"),
                i(2),
            }
        )
    ),
}
