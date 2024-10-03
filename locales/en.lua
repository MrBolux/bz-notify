local Translations = {
    error = {
        invalid_parameter = "Invalid parameter: must be a table or a string",
        preset_issue = "Preset issue: No preset found",
        invalid_key_type = "The following key don't have a good type '%{invalidTypes}'",
        unknown_keys = "The following keys are not allowed or are unknown: '%{unknownKeys}'",
    },
    util = {
        needToBe = 'must be of type'
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
