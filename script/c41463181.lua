--転生炎獣ヒートライオ
--Salamangreat Heatleo
function c41463181.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c41463181.matfilter,2)
	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(41463181,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c41463181.condition)
	e1:SetTarget(c41463181.target)
	e1:SetOperation(c41463181.operation)
	c:RegisterEffect(e1)
	--ATK
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(41463181,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c41463181.atkcon)
	e2:SetTarget(c41463181.atktg)
	e2:SetOperation(c41463181.atkop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c41463181.valcheck)
	c:RegisterEffect(e3)
end
function c41463181.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_EFFECT,scard,sumtype,tp) and c:IsAttribute(ATTRIBUTE_FIRE,scard,sumtype,tp)
end
function c41463181.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c41463181.filter(c)
	return c:IsAbleToDeck() and c:GetSequence()<5
end
function c41463181.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c41463181.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c41463181.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c41463181.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,1-tp,LOCATION_SZONE)
end
function c41463181.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c41463181.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(41463181)~=0
end
function c41463181.filter1(c,tp)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingTarget(c41463181.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetAttack())
end
function c41463181.filter2(c,atk)
	return c:IsFaceup() and c:GetAttack()~=atk
end
function c41463181.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c41463181.filter1,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c41463181.filter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c41463181.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g1:GetFirst():GetAttack())
end
function c41463181.atkop(e,tp,eg,ep,ev,re,r,rp)
	local gc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==gc then tc=g:GetNext() end
	if gc:IsFaceup() and gc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(gc:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c41463181.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsLinkCode,1,nil,41463181) and c:IsSummonType(SUMMON_TYPE_LINK) then
		c:RegisterFlagEffect(41463181,RESET_EVENT+0x6e0000,0,1)
	end
end

