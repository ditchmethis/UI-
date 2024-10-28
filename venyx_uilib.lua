function library:Notify(title, text, callback, timeduration)
	
	-- Overwrite last notification
	if self.activeNotification then
		self.activeNotification()
	end
	
	-- Create the notification
	local notification = utility:Create("ImageLabel", {
		Name = "Notification",
		Parent = self.container,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 60),
		Image = "rbxassetid://5028857472",
		ImageColor3 = themes.Background,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(4, 4, 296, 296),
		ZIndex = 3,
		ClipsDescendants = true
	}, {
		utility:Create("ImageLabel", {
			Name = "Flash",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = "rbxassetid://4641149554",
			ImageColor3 = themes.TextColor,
			ZIndex = 5
		}),
		utility:Create("ImageLabel", {
			Name = "Glow",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, -15, 0, -15),
			Size = UDim2.new(1, 30, 1, 30),
			ZIndex = 2,
			Image = "rbxassetid://5028857084",
			ImageColor3 = themes.Glow,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(24, 24, 276, 276)
		}),
		utility:Create("TextLabel", {
			Name = "Title",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 0, 8),
			Size = UDim2.new(1, -40, 0, 16),
			ZIndex = 4,
			Font = Enum.Font.GothamSemibold,
			TextColor3 = themes.TextColor,
			TextSize = 14.000,
			TextXAlignment = Enum.TextXAlignment.Left
		}),
		utility:Create("TextLabel", {
			Name = "Text",
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 10, 1, -24),
			Size = UDim2.new(1, -40, 0, 16),
			ZIndex = 4,
			Font = Enum.Font.Gotham,
			TextColor3 = themes.TextColor,
			TextSize = 12.000,
			TextXAlignment = Enum.TextXAlignment.Left
		})
	})
	
	-- Only create buttons if a callback is provided
	local acceptButton, declineButton
	if callback then
		acceptButton = utility:Create("ImageButton", {
			Name = "Accept",
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -26, 0, 8),
			Size = UDim2.new(0, 16, 0, 16),
			Image = "rbxassetid://5012538259",
			ImageColor3 = themes.TextColor,
			ZIndex = 4
		})

		declineButton = utility:Create("ImageButton", {
			Name = "Decline",
			BackgroundTransparency = 1,
			Position = UDim2.new(1, -26, 1, -24),
			Size = UDim2.new(0, 16, 0, 16),
			Image = "rbxassetid://5012538583",
			ImageColor3 = themes.TextColor,
			ZIndex = 4
		})

		acceptButton.Parent = notification
		declineButton.Parent = notification
	end
	
	-- Close function defined here for accessibility
	local function close()
		notification.ClipsDescendants = true
		utility:Tween(notification.Flash, {Size = UDim2.new(1, 0, 1, 0)}, 0.2) -- Flash out
		wait(0.2)
		utility:Tween(notification, {
			Size = UDim2.new(0, 0, 0, 60),
			Position = notification.Position + UDim2.new(0, textSize.X + 70, 0, 0)
		}, 0.2) -- Slide out
		wait(0.2)
		notification:Destroy()
	end
	
	if callback then
		acceptButton.MouseButton1Click:Connect(function()
			if callback then callback(true) end
			close()
		end)

		declineButton.MouseButton1Click:Connect(function()
			if callback then callback(false) end
			close()
		end)
	end
	
	-- Dragging
	utility:DraggingEnabled(notification)
	
	-- Position and size
	title = title or "Notification"
	text = text or ""
	
	notification.Title.Text = title
	notification.Text.Text = text
	
	local padding = 10
	local textSize = game:GetService("TextService"):GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(math.huge, 16))
	
	notification.Position = library.lastNotification or UDim2.new(0, padding, 1, -(notification.AbsoluteSize.Y + padding))
	notification.Size = UDim2.new(0, 0, 0, 60)
	
	utility:Tween(notification, {Size = UDim2.new(0, textSize.X + 70, 0, 60)}, 0.2) -- Slide in
	wait(0.2)
	
	notification.ClipsDescendants = false
	utility:Tween(notification.Flash, {
		Size = UDim2.new(0, 0, 0, 60),
		Position = UDim2.new(1, 0, 0, 0)
	}, 0.2) -- Flash in
	
	-- Auto-close after timeduration
	if timeduration then
		wait(timeduration)
		close()
	end
end
