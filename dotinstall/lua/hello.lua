-- 日付・時刻

--[[
x=os.time()
print(x)
]]

-- x = os.date("%Y-%m-%d")
x = os.date("*t")

for key,value in pairs(x) do
	print(key,value)
end