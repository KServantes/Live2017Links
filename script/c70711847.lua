--Danger! Nessie!
--Scripted by AlphaKretin
function c70711847.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(70711847,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c70711847.spcost)
	e1:SetTarget(c70711847.sptg)
	e1:SetOperation(c70711847.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(70711847,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,70711847)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c70711847.thcon)
	e2:SetTarget(c70711847.thtg)
	e2:SetOperation(c70711847.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function c70711847.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() and c:GetFlagEffect(70711847)==0 end
	c:RegisterFlagEffect(70711847,RESET_CHAIN,0,1)
end
function c70711847.spfilter(c,e,tp)
	return c:IsCode(70711847) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c70711847.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70711847.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c70711847.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	if #g<1 then return end
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
	local tc=g:Select(1-tp,1,1,nil)
	Duel.BreakEffect()
	Duel.SendtoGrave(tc,REASON_EFFECT+REASON_DISCARD)
	if not tc:GetFirst():IsCode(70711847) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c70711847.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #sc>0 and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c70711847.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_HAND and (r&REASON_DISCARD)~=0
end
function c70711847.thfilter(c)
	return c:IsSetCard(0x11e) and not c:IsCode(70711847) and c:IsAbleToHand()
end
function c70711847.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70711847.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c70711847.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c70711847.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
