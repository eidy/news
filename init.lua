 
local news = {}

news.path = minetest.get_worldpath()

function news.formspec(player)

	local newsfile = io.open(news.path.."/news.txt","r")
	
	local formspec = "size[12,10]"
	
	if newsfile ~= nil then
		local newscontent = newsfile:read("*a")
		formspec = formspec.."textarea[.25,"..tostring(y)..";12,10;news;;"..newscontent.."]"
	else
		minetest.log('error',"News file does not exist")
	end		
	formspec = formspec.."button_exit[.25,9;2,1;exit;Close"
	newsfile:close()
	return formspec
end

function news.show_formspec(player)
	local name = player:get_player_name()
	minetest.show_formspec(name,"news",news.formspec(player))
	minetest.log('action','Showing formspec to '..name)
end


minetest.register_chatcommand("news",{
	params = "",
	description="Shows the server news",
	func = function (name,params)
		local player = minetest.get_player_by_name(name)
		minetest.show_formspec(name,"news",news.formspec(player))	
	end,
})

minetest.register_on_joinplayer(function (player)
	minetest.after(5,news.show_formspec,player)
end)

