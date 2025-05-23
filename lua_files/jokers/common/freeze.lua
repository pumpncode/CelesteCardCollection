-- region Freeze

local freeze = {
	name = "ccc_Freeze",
	key = "freeze",
	config = {extra = {chips = 15}},
	pos = {x = 0, y = 7},
	rarity = 1,
	cost = 5,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "9Ts",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "Cards held in hand gain +15 Chips until end of round for each hand played"
}

freeze.calculate = function(self, card, context)
	if context.individual and not (context.end_of_round or context.repetition) then
        	if context.cardarea == G.hand then
			-- scuffed
	         	context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus or 0
                        context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chips
			context.other_card.ability.ccc_temp_bonus = context.other_card.ability.ccc_temp_bonus or 0
                        context.other_card.ability.ccc_temp_bonus = context.other_card.ability.ccc_temp_bonus + card.ability.extra.chips
                        return {
                            	extra = {message = localize('k_upgrade_ex'), colour = G.C.CHIPS, delay = 0.2},
                            	colour = G.C.CHIPS,
				card = card
                        }
	        end
	end
end

function freeze.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.chips}}
end
local endroundref = end_round
function end_round()
	for i, v in ipairs(G.playing_cards) do
		if v.ability.perma_bonus and v.ability.ccc_temp_bonus then
			v.ability.perma_bonus = v.ability.perma_bonus - v.ability.ccc_temp_bonus
			v.ability.ccc_temp_bonus = 0
		end
	end
	endroundref()
end

return freeze

-- endregion Freeze