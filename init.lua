 
local news = {}

news.path = minetest.get_worldpath()

-- Gets the article text
function news.getarticle(article)

	local newscontent = nil
	
	if ( article == "" or article == nil ) then
		article = "news.txt"
	else
		article = "news_"..article..".txt"
	end
	
	local newsfile = io.open(news.path.."/"..article,"r")
 
	if newsfile ~= nil then
		newscontent = newsfile:read("*a") 
		newsfile:close()
	end
	
	return newscontent
end

function news.formspec(newscontent)
 
	local formspec = "size[12,10]" 
	formspec = formspec.."textarea[.25,.25;12,10;;"..newscontent..";]"
	formspec = formspec.."button_exit[.25,9;2,1;exit;Close"
 
	return formspec
end

function news.show_formspec(player)
	local name = player:get_player_name()
	local newscontent = news.getarticle(article)	
	if(newscontent == nil) then
         return
	end
	minetest.show_formspec(name,"news",news.formspec(newscontent))
	minetest.log('action','Showing formspec to '..name)
end


minetest.register_chatcommand("news",{
	params = "<article>",
	description="Shows the server news",
	func = function (name,params)
		local player = minetest.get_player_by_name(name)
		local newscontent = news.getarticle(article)	
		if(newscontent == nil) then		 
			minetest.chat_send_player(name,"No news.")	
		else	 
			minetest.show_formspec(name,"news",news.formspec(newscontent))	
		end
	end,
})

minetest.register_on_joinplayer(function (player)
	minetest.after(5,news.show_formspec,player)
end)

