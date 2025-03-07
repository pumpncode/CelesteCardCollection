-- region Bubsdrop

local bubsdrop = {
	name = "ccc_Bubsdrop",
	key = "bubsdrop",
    config = {extra = {ante = 1, money = 15}},
	pixel_size = { w = 71, h = 81 },
	pos = {x = 7, y = 6},
	loc_txt = {
        name = 'Bubsdrop',
        text = {
			"On defeat of {C:attention}Boss Blind{},",
			"{C:red}-$#2#{} and {C:attention}-#1#{} Ante, then",
			"{C:red}disable{} this card",
        }
    },
	rarity = 3,
	cost = 10,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "9Ts"
	},
    description = "On defeat of the boss blind -15$ and -1 Ante, then disable this card"
}

bubsdrop.no_pool_flag = 'bubsdropused'

bubsdrop.calculate = function(self, card, context)
	if context.setting_blind and not context.blueprint then
		if context.blind.boss or G.GAME.modifiers.ccc_bside then
			card.ability.extra.boss = true
		else
			card.ability.extra.boss = false
		end
	end
	
	if context.end_of_round and (not context.repetition) and (not context.individual) and card.ability.extra.boss then
		G.GAME.pool_flags.bubsdropused = true
		local _card = context.blueprint_card or card
		G.E_MANAGER:add_event(Event({
			func = function() 
				ease_dollars(-card.ability.extra.money)
				card_eval_status_text(_card, 'extra', nil, nil, nil, {message = "-$"..card.ability.extra.money, colour = G.C.RED})
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			func = function() 
				ease_ante(-card.ability.extra.ante)
				card_eval_status_text(_card, 'extra', nil, nil, nil, {message = "-"..card.ability.extra.ante.." Ante", colour = G.C.FILTER})
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			func = function()
				_card.ability.perma_debuff = true
				card_eval_status_text(_card, 'extra', nil, nil, nil, {message = localize('k_disabled_ex'),colour = G.C.FILTER})
				return true
			end
		}))
	end
end

function bubsdrop.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.ante, card.ability.extra.money}}
end

return bubsdrop
-- endregion Bubsdrop