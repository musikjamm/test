PointBlankSniperResultsRowMixin = CreateFromMixins(AuctionatorResultsRowTemplateMixin)

function PointBlankSniperResultsRowMixin:Populate(rowData, ...)
  AuctionatorResultsRowTemplateMixin.Populate(self, rowData, ...)
  self.SelectedHighlight:SetShown(rowData.highlight)
end

function PointBlankSniperResultsRowMixin:OnClick(button, ...)
  Auctionator.Debug.Message("PointBlankSniperResultsRowMixin:OnClick", self.rowData and self.rowData.itemKey.itemID)
  if IsModifiedClick("DRESSUP") then
    AuctionHouseBrowseResultsFrameMixin.OnBrowseResultSelected({}, self.rowData)

  else
    itemName, _, _, _, _, _,
    _, _, _, _, _ = GetItemInfo(self.rowData.itemKey.itemID)
    
    itemName = string.lower(itemName)
    local listName = PointBlankSniper.Config.Get(PointBlankSniper.Config.Options.CURRENT_LIST)
    local items = PointBlankSniper.Utilities.ConvertList(Auctionator.Shopping.ListManager:GetByName(listName))
    local price = 0
    for k, v in pairs(items) do
      if itemName == v["searchString"] then
        price = v["price"]
      end
    end
    if IsShiftKeyDown() then
      PointBlankSniperTabFrame.Buy.timer = C_Timer.NewTicker(0.15, function()
        if PointBlankSniperTabFrame.Buy.BuyButton:GetText() == POINT_BLANK_SNIPER_L_BUY_NOW then
          -- -- assert(PointBlankSniperTabFrame.Buy.BuyButton:IsEnabled())
          -- if PointBlankSniperTabFrame.Buy.info.isCommodity then
          --   PointBlankSniperTabFrame.Buy.buyCommodity = true
          --   C_AuctionHouse.StartCommoditiesPurchase(PointBlankSniperTabFrame.Buy.expectedItemKey.itemID, PointBlankSniperTabFrame.Buy.ghostCount or PointBlankSniperTabFrame.Buy.resultInfo.quantity)
          -- else
          --   C_AuctionHouse.PlaceBid(PointBlankSniperTabFrame.Buy.resultInfo.auctionID, PointBlankSniperTabFrame.Buy.resultInfo.buyoutAmount)
          -- end
          -- PointBlankSniperTabFrame.Buy.BuyButton:Disable()
          -- PointBlankSniperTabFrame.Buy.BuyButton:SetText(POINT_BLANK_SNIPER_L_BUYING)
          PointBlankSniperTabFrame.Buy.IsAllowedToBuy = true
          -- C_AuctionHouse.PlaceBid(PointBlankSniperTabFrame.Buy.resultInfo.auctionID, PointBlankSniperTabFrame.Buy.resultInfo.buyoutAmount)
        elseif PointBlankSniperTabFrame.Buy.BuyButton:GetText() == POINT_BLANK_SNIPER_L_SOLD then
          C_Timer.After(0.25, function()
            Auctionator.EventBus
              :RegisterSource(self, "PointBlankSniperResultRow")
              :Fire(self, PointBlankSniper.Events.OpenBuyView, {
                itemKey = self.rowData.itemKey,
                price = self.rowData.minPrice,
                quantity = self.rowData.totalQuantity,
                comparisonPrice = self.rowData.comparisonPrice,
                rawSearchTermInfo = self.rowData.rawSearchTermInfo,
              })
              :UnregisterSource(self)
              PointBlankSniperTabFrame.Buy.IsAllowedToBuy = false
          end)
        elseif PointBlankSniperTabFrame.Buy.BuyButton:GetText() == POINT_BLANK_SNIPER_L_BUYING then
          C_Timer.After(3, function()
            if PointBlankSniperTabFrame.Buy.BuyButton:GetText() == POINT_BLANK_SNIPER_L_BUYING then
              Auctionator.EventBus
              :RegisterSource(self, "PointBlankSniperResultRow")
              :Fire(self, PointBlankSniper.Events.OpenBuyView, {
                itemKey = self.rowData.itemKey,
                price = self.rowData.minPrice,
                quantity = self.rowData.totalQuantity,
                comparisonPrice = self.rowData.comparisonPrice,
                rawSearchTermInfo = self.rowData.rawSearchTermInfo,
              })
              :UnregisterSource(self)
              PointBlankSniperTabFrame.Buy.IsAllowedToBuy = false
            end
          end)
        elseif PointBlankSniperTabFrame.Buy.BuyButton:GetText() == POINT_BLANK_SNIPER_L_WAITING then
          C_Timer.After(3, function()
            if PointBlankSniperTabFrame.Buy.BuyButton:GetText() == POINT_BLANK_SNIPER_L_WAITING then
              Auctionator.EventBus
              :RegisterSource(self, "PointBlankSniperResultRow")
              :Fire(self, PointBlankSniper.Events.OpenBuyView, {
                itemKey = self.rowData.itemKey,
                price = self.rowData.minPrice,
                quantity = self.rowData.totalQuantity,
                comparisonPrice = self.rowData.comparisonPrice,
                rawSearchTermInfo = self.rowData.rawSearchTermInfo,
              })
              :UnregisterSource(self)
              PointBlankSniperTabFrame.Buy.IsAllowedToBuy = false
            end
          end)
        end
      end, 100000000)
      PointBlankSniperTabFrame.Buy.AutoRefresh:SetText("Auto Refreshing with Smooktech™")
    else
      PointBlankSniperTabFrame.Buy.IsAllowedToBuy = false
      PointBlankSniperTabFrame.Buy.AutoRefresh:SetText("")
      if PointBlankSniperTabFrame.Buy.timer ~= nil then
        PointBlankSniperTabFrame.Buy.timer:Cancel()
      end
      Auctionator.EventBus
        :RegisterSource(self, "PointBlankSniperResultRow")
        :Fire(self, PointBlankSniper.Events.OpenBuyView, {
          itemKey = self.rowData.itemKey,
          price = self.rowData.minPrice,
          quantity = self.rowData.totalQuantity,
          comparisonPrice = self.rowData.comparisonPrice,
          rawSearchTermInfo = self.rowData.rawSearchTermInfo,
        })
        :UnregisterSource(self)
    end
  end
end
