-- Dependencies are listed next to their relative library

local libs = {
	"global",
	"intro",
	"poly",
	"adds",
	"techs" -- poly
}

for _,lib in pairs(libs) do
	require("libraries/" .. lib)
end

