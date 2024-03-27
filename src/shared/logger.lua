local Logger = {}

function Logger.log(message: string, level: number?, handler: any?)
    level = level or 2
    local callSource: string = debug.info(level, "s"):gsub(".+%.client%.?", ""):gsub(".+%.server%.?", "")
    local funcName: string = debug.info(level, "n")

    funcName = funcName and funcName ~= "" and funcName or "unnamed"
    callSource = funcName ~= "unnamed" and callSource .. "/" or callSource
    handler = handler or print

    handler(("[%s%s]: %s"):format(callSource, funcName, tostring(message)))
end

return Logger