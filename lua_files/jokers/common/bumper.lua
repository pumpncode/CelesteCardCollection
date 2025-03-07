-- region Bumper

local bumper = {
	name = "ccc_Bumper",
	key = "bumper",
	config = { extra = { mult = 16, chips = 60 } },
	pos = { x = 7, y = 1 },
	loc_txt = {
		name = 'Bumper',
		text = {
			"If {C:mult}discards{} {C:attention}>{} {C:chips}hands{}, {C:mult}+#1#{} Mult",
			"If {C:chips}hands{} {C:attention}>{} {C:mult}discards{}, {C:chips}+#2#{} Chips",
			"If both are {C:attention}equal{}, does {C:inactive}nothing{}"
		}
	},
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
		concept = "Aurora Aquir"
	},
    description = "If discards > hands: +16 Mult. If hands > discards: +60 Chips. If hands equal discards does nothing"
}

bumper.calculate = function(self, card, context)
	if context.joker_main then
		if G.GAME.current_round.hands_left > G.GAME.current_round.discards_left then
			return {
				message = localize {
					type = 'variable',
					key = 'a_chips',
					vars = { card.ability.extra.chips }
				},
				chip_mod = card.ability.extra.chips
			}
		elseif G.GAME.current_round.discards_left > G.GAME.current_round.hands_left then
			return {
				message = localize {
					type = 'variable',
					key = 'a_mult',
					vars = { card.ability.extra.mult }
				},
				mult_mod = card.ability.extra.mult
			}
		else
			if not context.blueprint then
				card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Equal", colour = G.C.RED })
			end
		end
	end
end

function bumper.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.mult, card.ability.extra.chips } }
end

return bumper
-- endregion Bumper