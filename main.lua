--- STEAMMODDED HEADER
--- MOD_NAME: RoboJokers
--- MOD_ID: ROBOJOKERS
--- MOD_AUTHOR: [Zuckern]
--- MOD_DESCRIPTION: A Cryptid Inspired Joker Pack that introduces several new Antagonistic Robot Themed Jokers
--- PREFIX: xmpl
-------------------------------------------------------
----------------------MOD CODE-------------------------

SMODS.Atlas{
    key = 'edgarpng',
    path = 'j_edgar.png',
    px = 71,
    py = 95
}

SMODS.Joker{
    key = 'edgar', 
    loc_txt = {
        name = 'Edgar',
        text = {
            'When {C:hearts}Heart{} {C:attention}Flush{} is played',
            'Destroy all played {C:hearts}Heart{} cards',
            'and increase {X:mult,C:white}X#2#{} Mult',
            '{C:inactive}(Currently {X:mult,C:white} X#1# {C:inactive} Mult)'
        }
    },
    config = { extra = { xmult = 1, xmult_gain = 1, hearts = 0, upgrade = 0 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.xmult_gain, hearts, upgrade}}
    end,
    rarity = 4,
    atlas = 'edgarpng',
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0},
    cost = 20,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if not context.blueprint and context.before and (next(context.poker_hands['Flush']) or next(context.poker_hands['Flush House']) or next(context.poker_hands['Flush Five']) or next(context.poker_hands['Straight Flush'])) then
            hearts = 0
            for i=1, #context.scoring_hand do
                if context.scoring_hand[i]:is_suit("Hearts") then hearts = hearts + 1 end
            end
		end
        if not context.blueprint and hearts ~= nil and hearts == #G.play.cards and #G.play.cards > 0 and context.before then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            upgrade = #G.play.cards
            hearts = 0
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.MULT,
                card = card,
                remove = true,
            }
        end
        if not context.blueprint and context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                Xmult_mod = card.ability.extra.xmult
			}
		end
        if context.blueprint and context.joker_main then
			return {
				message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.xmult } },
                Xmult_mod = card.ability.extra.xmult
			}
		end
        if not context.blueprint and context.destroy_card and context.destroy_card:is_suit("Hearts") and context.cardarea == G.play  and upgrade ~= nil and upgrade ~= 0 then
            upgrade = upgrade - 1
            return {
                remove = true
            }
        end
    end
}

-------------------------------------------------------
----------------------MOD CODE END---------------------