local Translations = {
    error = {
        invalid_parameter = "Paramètre invalide : doit être une table ou une chaîne de caractères",
        preset_issue = "Problème de preset : Aucun preset trouvé",
        invalid_key_type = "Les clés suivantes n'ont pas le bon type : '%{invalidTypes}'",
        unknown_keys = "Les clés suivantes ne sont pas autorisées ou sont inconnues : '%{unknownKeys}'",
    },
    util = {
        needToBe = 'doit être de type'
    }
}

if GetConvar('qb_locale', 'en') == 'fr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
