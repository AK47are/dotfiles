-- https://github.com/rime/squirrel/issues/787
-- 用于解决 patterns 进入的临时英文模式不能输入空格的问题
-- 空格通常会被后续组件（如 speller）处理，这里提前进行拦截
local function handle_pattern_space(key, env)
	local ctx, input = env.engine.context, env.engine.context.input
	local kAccepted, kNoop = 1, 2

	local patterns = { -- 注意这里为 + 而不是 *，这是为了单字符时空格直接上屏
		inline_latex = "^\\$[^\\$]+$",
		inline_code = "^`[^`]+$",
	}

	local in_temp_mode = false
	for _, pattern in pairs(patterns) do
		if ctx:is_composing() and input:match(pattern) then
			in_temp_mode = true
			break
		end
	end

	if in_temp_mode and key:repr() == "space" then
		ctx:push_input(" ")
		return kAccepted
	end
	return kNoop
end

return handle_pattern_space
