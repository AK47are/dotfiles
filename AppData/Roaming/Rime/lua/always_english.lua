local function always_english(_, env)
	-- log.info(tostring(env.engine.context:get_option("always_english")))
	if env.engine.context:get_option("always_english") then
		env.engine.context:clear()
		return 0
	end
	return 2
end
return always_english
