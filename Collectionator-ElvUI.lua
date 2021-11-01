local E, L, P, G = unpack(ElvUI)
local S = E:GetModule("Skins")

local frame = CreateFrame("FRAME", nil, nil, nil)
frame.loaded = false
frame:SetScript("OnEvent", function(self, event)
  if event == "AUCTION_HOUSE_SHOW" and not self.loaded then
    self.loaded = true
    C_Timer.After(0, function()
      Collectionator_ElvUI.Skin()
    end)
  end
end)
frame:RegisterEvent("AUCTION_HOUSE_SHOW")

local function HandleHeaders(frame)
	local maxHeaders = frame.HeaderContainer:GetNumChildren()
	for i = 1, maxHeaders do
		local header = select(i, frame.HeaderContainer:GetChildren())
		if header and not header.IsSkinned then
			header:DisableDrawLayer('BACKGROUND')
			if not header.backdrop then
				header:CreateBackdrop('Transparent')
			end

			header.IsSkinned = true
		end

		if header.backdrop then
			header.backdrop:Point('BOTTOMRIGHT', i < maxHeaders and -5 or 0, -2)
		end
	end
end

local function HandleResetButton(button)
  S:HandleButton(button)
  button.texture:SetTexture(E.Media.Textures.Close)
end

Collectionator_ElvUI = {}
function Collectionator_ElvUI.Skin()
  S:HandleTab(AuctionatorTabs_Collecting)

  local ctf = AuctionHouseFrame.CollectionatorTabFrame
  local buttons = {
    ctf.TMogButton, ctf.PetButton, ctf.ToyButton, ctf.MountButton, ctf.RecipeButton, ctf.OptionsButton, ctf.FullScanButton
  }
  for _, button in ipairs(buttons) do
    S:HandleButton(button)
  end

  local views = {
    ctf.TMogView, ctf.PetView, ctf.ToyView, ctf.MountView, ctf.RecipeView
  }
  for _, view in ipairs(views) do
    S:HandleInsetFrame(view.ResultsListingInset)
    view.ResultsListingInset.NineSlice:Hide()
    S:HandleScrollBar(view.ResultsListing.ScrollFrame.scrollBar, 2, 2)
    HandleHeaders(view.ResultsListing)
    for _, child in ipairs({view:GetChildren()}) do
      if child.CheckBox ~= nil then
        S:HandleCheckBox(child.CheckBox)
        child.CheckBox:Size(20, 20)
      elseif child.GetFilterName ~= nil then
        S:HandleButton(child)
        HandleResetButton(child.ResetButton)
      elseif child.GetMin ~= nil then
        HandleResetButton(child.ResetButton)
        S:HandleEditBox(child.MinBox)
        S:HandleEditBox(child.MaxBox)
      elseif child.SetupRadioButtons then
        for _, child in ipairs({child:GetChildren()}) do
          if child.isAuctionatorRadio then
            S:HandleRadioButton(child.RadioButton)
          end
        end
      end
    end
    S:HandleEditBox(view.TextFilter)
    S:HandleButton(view.RefreshButton)
    view.RefreshButton:SetSize(22, 22)
  end
end
