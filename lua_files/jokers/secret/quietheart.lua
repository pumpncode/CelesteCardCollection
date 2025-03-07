-- region Quiet Heart

local quietheart = {
	name = "ccc_Quiet Heart",
	key = "quietheart",
	config = { extra = { add = 15 } },
	pos = { x = 9, y = 4 },
	loc_txt = {
		name = 'Quiet Heart',
		text = {
			"If played hand is a",
			"single {C:attention}Ace{} of {C:spades}Spades{},",
			"give permanent {C:chips}+#1#{} Chips",
			"to {C:attention}all{} cards held in hand",
			"{C:inactive,s:0.87}(Unaffected by retriggers){}"
		}
	},
	rarity = 'ccc_secret',
	cost = 15,
	discovered = false,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	atlas = "j_ccc_jokers",
	credit = {
		art = "N/A",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "If played hand is a single Ace of Spades gives permanent +15 Chips to all cards held in hand (Unaffected by retriggers)"
}

quietheart.calculate = function(self, card, context)
	if context.before and #context.full_hand == 1 and context.full_hand[1]:get_id() == 14 and context.full_hand[1]:is_suit('Spades', true) then
		for i = 1, #G.hand.cards do
			G.hand.cards[i].perma_bonus = G.hand.cards[i].ability.perma_bonus or 0
			G.hand.cards[i].ability.perma_bonus = G.hand.cards[i].ability.perma_bonus + card.ability.extra.add
		end
		if #G.hand.cards > 0 then
			return {
				message = "Upgraded",
				colour = G.C.CHIPS
			}
		end
	end
end

quietheart.yes_pool_flag = 'secretheart'

function quietheart.loc_vars(self, info_queue, card)
	return { vars = { card.ability.extra.add } }
end

return quietheart
-- endregion Quiet Heart