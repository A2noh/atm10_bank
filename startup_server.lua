--Bank server program--
--Must be startup program--
--Must be a directory called saves on the computer--

term.clear()
rednet.open("top")
os.loadAPI("bankAPI.lua")
term.setCursorPos(1, 1)

shell.openTab("control.lua")
shell.openTab()

while true do
    local ret, msg, pro = rednet.receive("banking")
    --open log file--
    local logLine = os.date()
    printError(logLine)
    --write msg info to log--
    for k, v in pairs(msg) do
        logLine = logLine.. " & ".. v
    end
    local msgR = {}
    if msg[1] == "bal" then
        local succ, resp = bankAPI.balance(msg[2], msg[3], msg[4])
        msgR = {"balR", succ, resp}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "dep" then
        local succ, resp = bankAPI.deposit(msg[2], msg[3], msg[4], msg[5])
        msgR = {"depR", succ, resp}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "wit" then
        local succ, resp = bankAPI.withdraw(msg[2], msg[3], msg[4], msg[5])
        msgR = {"witR", succ, resp}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "tra" then
        local succ, resp = bankAPI.transfer(msg[2], msg[3], msg[4], msg[5], msg[6])
        msgR = {"traR", succ, resp}
        rednet.send(ret, msgR, "banking")
    elseif msg[1] == "cre" then
        local succ, resp = bankAPI.transfer(msg[2], msg[3], msg[4])
        msgR = {"creR", succ, resp}
        rednet.send(ret, msgR, "banking")
    end
    if msgR ~= nil then
        if msgR[1] ~= nil then
            if msgR[2] ~= nil then
                logLine = logLine.. " Resp:".. " & ".. tostring(msgR[2]).. " & ".. msgR[3]
            end
        end
    end
    print(logLine)
    log = fs.open("log", "a")
    log.writeLine(logLine)
    log.close()
end