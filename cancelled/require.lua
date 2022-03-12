-- Dependencies are listed next to their relative library

local libs = {
	"global",
	"background",
	"ring",
	"worms" -- ring
}

for _,lib in pairs(libs) do
	require("libraries/" .. lib)
end

