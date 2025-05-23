-- region smots gaming

local smotsgaming = {
	name = "ccc_smots gaming",
	key = "smotsgaming",
	config = {extra = {slot = 1}},
	pos = {x = 5, y = 9},
	rarity = 1,
	cost = 1,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = true,
	perishable_compat = true,
	atlas = "j_ccc_jokers",
	add_to_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slot
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slot
		if card.smotscoin then
			card.smotscoin:start_dissolve(nil, true)
			card.debuff = true
			card.smotscoin = false
		end
	end,
	update = function(self, card, front)
		if G.STAGE == G.STAGES.RUN then
			if card.area == G.jokers and not card.debuff then
				if not card.smotscoin then
					-- bunch of boilerplate to get a decent looking smots coin
					local coin = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, nil, G.P_CENTERS.e_base, {})
					coin.children.center.atlas = G.ASSET_ATLAS['ccc_smotscoin']
					coin.children.center:set_sprite_pos({x = 0, y = 0})
					coin.T.h = coin.T.h*(62/95)
					coin.T.w = coin.T.h
					coin.children.center.scale.y = coin.children.center.scale.y*(62/95)
					coin.children.center.scale.x = coin.children.center.scale.y
					coin.is_a_smotscoin = true
					card.smotscoin = coin
					coin:start_materialize(nil, true)
				end
				if card.edition and ((not card.smotscoin.edition) or card.edition.type ~= card.smotscoin.edition.type) then
					card.smotscoin:set_edition('e_'..card.edition.type, true, true)
				end
				if card.highlighted then
					card.smotscoin.T.y = card.T.y
					card.smotscoin.T.x = card.T.x
				end
			end
		end
	end,
	credit = {
		art = "bein",
		code = "toneblock",
		concept = "Fytos"
	},
    description = "+1 Joker Slot. smots gaming"
}

local cardhoverref = Card.hover
function Card:hover()
	if self.is_a_smotscoin then
		self:juice_up(0.05, 0.03)
		play_sound('chips1', math.random()*0.1 + 0.55, 0.12)
	else
		cardhoverref(self)
	end
end

local movexyref = Moveable.move_xy
function Moveable:move_xy(dt)
	if self.is_a_smotscoin then
		local rate = math.exp(-1.7 * dt)
		local function reverse(s, t, vt)
			s = -s
			t = vt - (t - vt)
			return s, t
		end
		-- what in the actual fuck am i doing here
		local bounce = 0
		if (self.VT.y + (self.velocity.y*rate))/G.ROOM.T.h < -0.10 then
			if self.velocity.y < 0 then
				self.velocity.y, self.T.y = reverse(self.velocity.y, self.T.y, self.VT.y)
				bounce = bounce + 1
			end
		end
		if (self.VT.y + (self.velocity.y*rate))/G.ROOM.T.h > 1.00 then
			if self.velocity.y > 0 then
				self.velocity.y, self.T.y = reverse(self.velocity.y, self.T.y, self.VT.y)
				bounce = bounce + 1
			end
		end
		if (self.VT.x + (self.velocity.x*rate))/G.ROOM.T.w < -0.09 then
			if self.velocity.x < 0 then
				self.velocity.x, self.T.x = reverse(self.velocity.x, self.T.x, self.VT.x)
				bounce = bounce + 1
			end
		end
		if (self.VT.x + (self.velocity.x*rate))/G.ROOM.T.w > 1.05 then
			if self.velocity.x > 0 then
				self.velocity.x, self.T.x = reverse(self.velocity.x, self.T.x, self.VT.x)
				bounce = bounce + 1
			end
		end
		if bounce >= 1 then
			bounce = math.min(2, bounce)
			sound = self.edition and G.P_CENTERS['e_'..self.edition.type].sound or 'multhit'..bounce
			
			local pitch = math.abs(self.velocity.x/(dt*60)) + math.abs(self.velocity.y/(dt*60))
			play_sound('multhit'..bounce, pitch, 0.2+(bounce == 2 and 0.2 or 0.0) )
			if self.edition and math.random() < 0.01 then
				local _s = G.P_CENTERS['e_'..self.edition.type].sound
				play_sound(_s.sound, (_s.per or 1)*pitch, (_s.vol or 1)*0.40)
			end
		end
		self.T.x = self.T.x + (self.velocity.x*rate)
		self.T.y = self.T.y + (self.velocity.y*rate)
		self.T.r = self.VT.r
	end
	movexyref(self, dt)
end

SMODS.Atlas({key = "smotscoin", path = "smotscoin.png", px = 71, py = 95, atlas = "asset_atlas"})

smotsgaming.calculate = function(self, card, context)
end

function smotsgaming.loc_vars(self, info_queue, card)
	return {vars = {card.ability.extra.slot}}
end

function smotsgaming.in_pool(self)
	if pseudorandom('smotsgaming'..G.GAME.round_resets.ante) < (1/7) then
		return true
	end
	return false
end

return smotsgaming
-- endregion smots gaming
