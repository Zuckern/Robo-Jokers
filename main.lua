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

SMODS.Atlas{
    key = 'kinitopng',
    path = 'j_kinito.png',
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = 'palpng',
    path = 'j_pal.png',
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
    perishable_compat = false,
    calculate = function(self, card, context)
        if not context.blueprint and context.before and (next(context.poker_hands['Flush']) or next(context.poker_hands['Flush House']) or next(context.poker_hands['Flush Five']) or next(context.poker_hands['Straight Flush'])) then
            hearts = 0
            for i=1, #context.scoring_hand do
                if context.scoring_hand[i]:is_suit("Hearts") then hearts = hearts + 1 end
            end
		end
        if not context.blueprint and context.before and not context.destroy_card and hearts ~= nil and #context.scoring_hand ~= nil and hearts == #context.scoring_hand and #context.scoring_hand > 0 then
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_gain
            upgrade = hearts
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

SMODS.Joker{
    key = 'kinito',
    loc_txt = {
        name = 'Kinito',
        text = {
            'When Joker is {C:attention}Sold{} or {C:attention}Removed{}',
            'Duplicates the {C:attention}Joker{} to the left of it'
        }
    },
    config = { extra = {clone = 0}},
    rarity = 4,
    atlas = 'kinitopng',
    pos = { x = 0, y = 0},
    soul_pos = { x = 1, y = 0},
    cost = 20,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.selling_self then
            if #G.jokers.cards <= 1 then 
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_no_other_jokers')})
                return
            end
            clone = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card and G.jokers.cards[i-1] ~= nil then clone = copy_card(G.jokers.cards[i-1], nil, nil, nil, G.jokers.cards[i-1].edition and G.jokers.cards[i-1].edition.negative) end
            end
            if clone == nil then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'Invalid Joker'})
                return
            end
            clone:add_to_deck()
            G.jokers:emplace(clone)
        end
    end
}

SMODS.Joker{
    key = 'pal',
    loc_txt = {
        name = 'Pal',
        text = {
            'When starting a {C:attention}Boss Blind{}',
            'Gives one random Joker an {C:attention}Eternal{} Sticker',
            'and adds {C:dark_edition}Negative{}'
        }
    },
    config = { extra = {selectJoker = 0, jokerPool = 0}},
    rarity = 4,
    atlas = 'palpng',
    pos = { x = 0, y = 0},
    soul_pos = { x = 1, y = 0},
    cost = 20,
    eternal_compat = true,
    perishable_compat = false,
    calculate = function(self, card, context)
        if context.setting_blind and G.GAME.blind and G.GAME.blind:get_type() == 'Boss'then
            jokerPool = {}
            for i = 1, #G.jokers.cards do
                if (G.jokers.cards[i].edition == nil or G.jokers.cards[i].edition == edition.negative) and G.jokers.cards[i].config.center.eternal_compat == true then
                    jokerPool[#jokerPool+1] = G.jokers.cards[i]
                end
            end
            selectJoker = pseudorandom_element(jokerPool, pseudoseed('pal_joker'))
            if selectJoker == nil then
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = 'No Available Joker'})
                return 
            end
            selectJoker:set_edition({negative = true}, true)
            SMODS.Stickers['eternal']:apply(selectJoker, true)
        end
    end
}
-------------------------------------------------------
----------------------MOD CODE END---------------------