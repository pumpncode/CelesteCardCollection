-- region Jump

local jump = {
	name = "ccc_Jump",
	key = "jump",
	config = { extra = { chips = 40 } },
	pixel_size = { w = 71, h = 81 },
	pos = { x = 9, y = 7 },
	rarity = 1,
	cost = 2,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	credit = {
		art = "Gappie",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "+40 Chips"
}

jump.calculate = function(self, card, context)
	if context.joker_main then
		return {
			message = localize {
				type = 'variable',
				key = 'a_chips',
				vars = { card.ability.extra.chips }
			},
			chip_mod = card.ability.extra.chips
		}
	end
end

function jump.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.chips } }
end

return jump
-- endregion Jump