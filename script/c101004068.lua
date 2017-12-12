--レッド・リブート
--Red Reboot
--Scripted by Eerie Code
function c101004068.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101004068.condition)
	e1:SetTarget(c101004068.target)
	e1:SetOperation(c101004068.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetOperation(c101004068.handop)
	c:RegisterEffect(e2)
end
function c101004068.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c101004068.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c101004068.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c101004068.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN)
		Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local g=Duel.GetMatchingGroup(c101004068.setfilter,tp,0,LOCATION_DECK,nil)
		if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(101004068,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
			Duel.ConfirmCards(1-tp,sg)
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(0,LOCATION_SZONE+LOCATION_HAND)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TRAP))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101004068.handop(e)
	local lp=Duel.GetLP(e:GetHandlerPlayer())
	Duel.SetLP(e:GetHandlerPlayer(),math.floor(lp/2))
end
