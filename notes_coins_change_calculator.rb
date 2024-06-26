require "rqrcode"
require "chunky_png"
require "prawn"
require "prawn/table"
def change_calculator(bill, cash_given)
    if cash_given < bill
        puts "⚠️ Amount paid cannot be less than the amount due"
        return nil
    end

    note_denominations = [1000, 500, 200, 100, 50]
    coin_denominations = [40, 20, 10, 5, 1]
    change = cash_given - bill
    
    remaining_change = change

    note_change_breakdown = []
    coin_change_breakdown = []

    # Notes
    note_denominations.each do |note|
        if remaining_change >= note
            count = remaining_change / note
            remaining_change = remaining_change % note
            note_change_breakdown << [note, count]
        end
    end
    # Coins
    coin_denominations.each do |coin|
        if remaining_change >= coin
            count = remaining_change / coin
            remaining_change = remaining_change % coin
            coin_change_breakdown << [coin, count]
        end
    end
    return [note_change_breakdown, coin_change_breakdown]
end

def print_menu(menu)
    puts  "------------------------------------------------------"
    puts "Code\tItem\t\t\t\tPrice"
    puts "-------------------------------------------------------"
    menu.each_with_index do |(item, price), index|
        spacing = "\t" * (2 - item.length / 4)
        puts "#{index + 1}\t#{item}#{spacing}\t\t\tKshs #{price}"
    end
    puts "-------------------------------------------------------"
end

# Define shopping items and prices
shopping_menu = {
    "Milk" => 50,
    "Bread" => 30,
    "Eggs" => 20,
    "Butter" => 80,
    "Sugar" => 40,
    "Coffee" => 120,
    "Tea Leaves" => 60,
    "Rice" => 100,
    "Flour" => 45,
    "Salt" => 25,
    "Cooking Oil" => 90,
    "Tomatoes" => 15,
    "Potatoes" => 35,
    "Onions" => 30,
    "Bananas" => 10,
    "Apples" => 60
}

sorted_menu = shopping_menu.sort.to_h

# print_menu(sorted_menu)

puts "🎉🎉 Welcome to the Kenyan Shopping Cart and Currency Change Calculator 🎉🎉"
puts ""

# Initialize variables
total = 0
total_before_discount = 0  # Initialize total before discount
items_selected = []

# Discount rules
MULTI_ITEM_DISCOUNT_THRESHOLD = 3
MULTI_ITEM_DISCOUNT_RATE = 10

# Shopping loop
loop do
    print_menu(sorted_menu)
    puts "Select an item by pressing the corresponding number, 'r' to remove an item, or 'q' to calculate total and exit:"
    choice = gets.chomp.downcase

    break if choice == 'q'

    if choice.to_i.between?(1, sorted_menu.length)
        item_index = choice.to_i - 1
        selected_item = sorted_menu.keys[item_index]
        item_price = sorted_menu.values[item_index]

        # Prompt the user for quantity
        puts "Enter the quantity for #{selected_item}:"
        quantity = gets.chomp.to_i
        if quantity < 1
            puts "Invalid quantity. Please enter a positive integer."
            next
        end

        # Update total before discount
        total_before_discount += item_price * quantity

        # Update total
        total += item_price * quantity

        # Check if the item already exists in the cart
        existing_item_index = items_selected.index { |item| item[:item] == selected_item }
        if existing_item_index
            # If the item already exists, update its quantity
            items_selected[existing_item_index][:quantity] += quantity
        else
            # If the item doesn't exist, add it to the cart
            items_selected << { item: selected_item, quantity: quantity }
        end

        puts "#{quantity} #{selected_item}(s) added to cart. Current total: Kshs #{total}"
    elsif choice == 'r'
        if items_selected.empty?
            puts "There are no items in the cart to remove."
            next
        end

        # Print the current items in the cart with their indices
        puts "Items in the cart:"
        items_selected.each_with_index do |item, index|
            puts "#{index + 1}. #{item[:item]} (#{item[:quantity]})"
        end

        puts "Enter the number of the item to remove:"
        remove_choice = gets.chomp.to_i

        if remove_choice.between?(1, items_selected.length)
            removed_item = items_selected[remove_choice - 1]

            # Prompt the user for the quantity to deduct
            puts "Enter the quantity to remove for #{removed_item[:item]}:"
            remove_quantity = gets.chomp.to_i

            if remove_quantity < 1 || remove_quantity > removed_item[:quantity]
                puts "Invalid quantity to remove. Please enter a positive integer not exceeding the current quantity."
                next
            end

            # Deduct the specified quantity from the selected item
            removed_item[:quantity] -= remove_quantity
            total -= sorted_menu[removed_item[:item]] * remove_quantity
            total_before_discount -= sorted_menu[removed_item[:item]] * remove_quantity  # Deduct from total before discount

            puts "#{remove_quantity} #{removed_item[:item]} removed from cart. Current total: Kshs #{total}"
        else
            puts "Invalid choice. Please enter a valid item number to remove."
        end
    else
        puts "Invalid choice. Please select a valid item or press 'q' to calculate total and exit."
    end
end


puts ""

# Apply discount rules
if items_selected.length >= MULTI_ITEM_DISCOUNT_THRESHOLD
    discount_amount = (total * (MULTI_ITEM_DISCOUNT_THRESHOLD.to_f / 100)).round(2)
    total -= discount_amount
    discount_display = "Kshs #{discount_amount}"
else
    discount_display = "-"
end
# Print the final items in the cart with their quantities
# puts "Items in the cart:"
# items_selected.each_with_index do |item, index|
#     puts "#{index + 1}. #{item[:item]} (#{item[:quantity]})"
# end

# puts "Total: Kshs #{total}"

# puts ""
# # Initialize a hash to store item counts
# # Initialize a hash to store item counts
# item_counts = {}

# # Count the occurrences of each item
# items_selected.each do |item|
#     item_name = item[:item]  # Extract the item name from the hash
#     if item_counts.has_key?(item_name)
#         item_counts[item_name] += item[:quantity]
#     else
#         item_counts[item_name] = item[:quantity]
#     end
# end

# # Sort the items alphabetically
# sorted_items = item_counts.keys.sort

# # Calculate the total price
# total_price = 0

# puts "🛒 Items selected:"
# puts "--------------------------------------------------------"
# puts "Item\t\t\tQuantity\t\tPrice"
# sorted_items.each do |item_name|
#     count = item_counts[item_name]
#     if shopping_menu[item_name].nil?
#         puts "Error: Price not found for #{item_name}. Please check your shopping menu."
#         next
#     end
#     price = shopping_menu[item_name] * count
#     total_price += price
#     spacing = "\t" * (2 - item_name.length / 4)
#     puts "#{item_name}#{spacing}\t\t#{count}\t\t\tKshs #{price}"
# end


# puts "--------------------------------------------------------"
# puts "Total\t\t\t\tKshs #{total_price}"
# puts "🎉🎉🎉 You have earned a discount of Kshs #{discount_amount}! 🎉🎉🎉"

puts ""
puts "💰 Total BILL: Kshs #{total}"
puts ""

puts "💵 Enter the cash given (Kshs):"
cash_given = gets.chomp.to_i

puts ""

change = change_calculator(total, cash_given)

if change
    note_change, coin_change = change
    puts "💸💸💸 Change Breakdown 💸💸💸"
    puts "💰💰💰 CHANGE DUE: Kshs #{(cash_given - total).round(2)} 💰💰💰"
    puts ""
    puts "💵 Notes:"
    note_change.each do |note, count|
        puts " #{(count).round(0)} of Kshs #{note} notes"
    end

    puts "💰 Coins:"
    coin_change.each do |coin, count|
        puts " #{(count).round(0)} of Kshs #{coin} coins"
    end
end

# Save PDF receipt generator

receipt_code = rand(36**5).to_s(10).rjust(5, "0")
receipt_filename = "receipt-#{receipt_code}.pdf"

qrcode = RQRCode::QRCode.new(receipt_code)

# Convert the QR code to PNG format
qr_png = qrcode.as_png(
    resize_gte_to: false,
    resize_exactly_to: false,
    fill: "white",
    color: "black",
    size: 100,
    border_modules: 2,
    module_px_size: 6,
    file: nil # Don't save the file, return as a string
)


Prawn::Document.generate(receipt_filename) do
    text "Sperizon Mini Mart", align: :center, size: 30, style: :bold
    
    # Capture date and time(YYYY-MM-DD HH:MM:SS)
    datetime = Time.now.strftime("%Y-%m-%d %H:%M:%S")

    # receipt_code = datetime.gsub(/[^0-9]/, '')
    text "Receipt Code: #{receipt_code}", align: :center, size: 20, style: :bold
    text "Date #{datetime}", align: :center, size: 10, style: :italic

    move_down 20

    font_size 10

    stroke do
        dash(3, space: 3) # Set the dash pattern: 3 points dash, 3 points space
        stroke_color "000000"
        stroke_horizontal_line bounds.left, bounds.right, at: cursor
        undash # Reset the dash pattern to solid line after drawing
    end
        
    # Collect item data for the table
    item_table_data = [["Item", "Quantity", "Price"]]

    # Sort items by name alphabetically
    sorted_items = items_selected.sort_by { |item| item[:item] }

    # Populate the table with sorted items
    sorted_items.each do |item|
        item_name = item[:item]
        item_quantity = item[:quantity]
        item_price = shopping_menu[item_name] * item_quantity
        item_table_data << [item_name, item_quantity, "Kshs #{item_price}"]
    end

    # Render the table
    table(item_table_data, header: true, width: bounds.width) do
        cells.padding = 2
        cells.borders = []
        cells.font_style = :italic
        row(0).font_style = :bold
        row(0).borders = [:bottom]
        row(0).border_width = 1
        row(0).border_color = "000000"
        column(1).align = :center
        column(2).align = :right  # Align the price column to the right
    end
    move_down 5
    # Draw a dashed horizontal line
    stroke do
        dash(3, space: 3) # Set the dash pattern: 3 points dash, 3 points space
        stroke_color "000000"
        stroke_horizontal_line bounds.left, bounds.right, at: cursor
        undash # Reset the dash pattern to solid line after drawing
    end
        
    move_down 5
    # Calculate the width of "Total Before Discount" and "#{total_before_discount}"
    # Calculate the width of "Total Before Discount:" and "Kshs #{total_before_discount}"
    total_before_discount_text_width = width_of("Total Before Discount:")
    total_before_discount_amount_width = width_of("Kshs #{total_before_discount}")

    # Calculate the positions for "Total Before Discount" and "Kshs #{total_before_discount}"
    total_before_discount_text_x_position = bounds.left
    total_before_discount_amount_x_position = bounds.right - total_before_discount_amount_width

    # Calculate the height of the line containing "Total Before Discount" and "Kshs #{total_before_discount}"
    line_height = 10  # Set a fixed line height

    # Place "Total Before Discount" on the left and "Kshs #{total_before_discount}" on the right
    total_before_discount_text_y_position = cursor
    total_before_discount_amount_y_position = cursor 

    text_box "Total Before Discount:", at: [total_before_discount_text_x_position, total_before_discount_text_y_position], style: :bold, size: 11
    text_box "Kshs #{total_before_discount}", at: [total_before_discount_amount_x_position, total_before_discount_amount_y_position], style: :italic, size: 10


    move_down line_height + 5

    # Calculate the width of "Discount Earned:" and "Kshs #{discount_amount}"
    # Calculate the width of "Discount Earned:" and the discount display
    discount_text = "Discount Earned:"
    discount_display = items_selected.length >= MULTI_ITEM_DISCOUNT_THRESHOLD ? "Kshs #{(total * (MULTI_ITEM_DISCOUNT_THRESHOLD.to_f / 100)).round(1)}" : "-"

    discount_text_width = width_of(discount_text)
    discount_amount_width = width_of(discount_display)

    # Calculate the positions for "Discount Earned" and the discount display
    discount_text_x_position = bounds.left
    discount_amount_x_position = bounds.right - discount_amount_width

    # Calculate the height of the line containing "Discount Earned" and the discount display
    line_height = 10  # Set a fixed line height

    # Place "Discount Earned" on the left and the discount display on the right
    discount_text_y_position = cursor
    discount_amount_y_position = cursor

    # Render "Discount Earned:" on the left
    text_box discount_text, at: [discount_text_x_position, discount_text_y_position], style: :bold, size: 11

    # Render the discount display on the right, ensuring it fits within the bounds
    begin
    text_box discount_display, at: [discount_amount_x_position, discount_amount_y_position], style: :italic, size: 10
    rescue Prawn::Errors::CannotFit
    # Reduce font size dynamically if the text doesn't fit
    font_size = 10
    while width_of(discount_display, size: font_size) > (bounds.width - discount_text_width) && font_size > 5
        font_size -= 0.5
    end
    text_box discount_display, at: [discount_amount_x_position, discount_amount_y_position], style: :italic, size: font_size
    end

    move_down line_height + 5

    # Calculate the width of "Total After Discount:" and "Kshs #{total}"
    total_bill_text = "Total After Discount:"
    total_amount_text = "Kshs #{total.round(0)}"

    total_bill_width = width_of(total_bill_text)
    total_amount_width = width_of(total_amount_text)

    # Calculate the positions for "Total After Discount:" and "Kshs #{total}"
    total_bill_x_position = bounds.left
    total_amount_x_position = bounds.right - total_amount_width

    # Calculate the height of the line containing "Total After Discount:" and "Kshs #{total}"
    line_height = 10  # Set a fixed line height

    # Place "Total After Discount:" on the left and "Kshs #{total}" on the right
    total_bill_y_position = cursor
    total_amount_y_position = cursor 

    # Render "Total After Discount:" and "Kshs #{total}" with adjusted font size if necessary
    begin
    text_box total_bill_text, at: [total_bill_x_position, total_bill_y_position], style: :bold, size: 11
    text_box total_amount_text, at: [total_amount_x_position, total_amount_y_position], style: :italic, size: 10
    rescue Prawn::Errors::CannotFit
    # Reduce font size dynamically if the text doesn't fit
    font_size = 10
    while width_of(total_amount_text, size: font_size) > (bounds.right - bounds.left) && font_size > 5
        font_size -= 0.5
    end
    text_box total_amount_text, at: [total_amount_x_position, total_amount_y_position], style: :italic, size: font_size
    end

    move_down line_height + 5

    # Draw a horizontal line
    stroke do
        stroke_color "000000"
        stroke_horizontal_line bounds.left, bounds.right, at: cursor
    end
    move_down 5

    # Calculate the width of "Cash Given: Kshs " and "#{cash_given}"
    cash_given_text_width = width_of("Cash Given:")
    cash_given_amount_width = width_of("Kshs #{cash_given}")

    # Calculate the positions for "Cash Given: Kshs " and "#{cash_given}"
    cash_given_text_x_position = bounds.left
    cash_given_amount_x_position = bounds.right - cash_given_amount_width

    # Calculate the height of the line containing "Cash Given: Kshs " and "#{cash_given}"
    line_height = 10  # Set a fixed line height

    # Place "Cash Given: Kshs " on the left and "#{cash_given}" on the right
    cash_given_text_y_position = cursor
    cash_given_amount_y_position = cursor 

    text_box "Cash Given:", at: [cash_given_text_x_position, cash_given_text_y_position], style: :bold, size: 11
    text_box "Kshs #{cash_given}", at: [cash_given_amount_x_position, cash_given_amount_y_position], style: :italic, size: 10

    move_down line_height + 5

    # Calculate the change

    # Calculate the width of "Change:" and "#{change}"
    change_text_width = width_of("Change:")
    change_amount_width = width_of("Kshs #{(cash_given - total).round(1)}")

    # Calculate the positions for "Change:" and "#{change}"
    change_text_x_position = bounds.left
    change_amount_x_position = bounds.right - change_amount_width - change_text_width + 36

    # Calculate the height of the line containing "Change:" and "#{change}"
    line_height = 10  # Set a fixed line height

    # Place "Change:" on the left and "#{change}" on the right
    change_text_y_position = cursor
    change_amount_y_position = cursor 

    text_box "Change:", at: [change_text_x_position, change_text_y_position], style: :bold, size: 11
    text_box "Kshs #{(cash_given - total).round(1)}", at: [change_amount_x_position, change_amount_y_position], style: :italic, size: 10

    move_down line_height + 10

    text "Change BreakDown:", style: :bold, align: :center, size: 15
    stroke do
        dash(3, space: 3) # Set the dash pattern: 3 points dash, 3 points space
        stroke_color "000000"
        stroke_horizontal_line bounds.left, bounds.right, at: cursor
        undash # Reset the dash pattern to solid line after drawing
    end
    note_table_data = [["Note", "Quantity"]]
    note_change.each do |note, count|
        note_table_data << ["Kshs #{note}", (count).round(0)]
    end

    
    
    table(note_table_data, header: true, width: bounds.width) do
        cells.padding = 2
        cells.borders = []
        cells.font_style = :italic
        row(0).font_style = :bold
        row(0).borders = [:bottom]
        row(0).border_width = 1
        row(0).border_color = "000000"
        column(1).align = :right
    end

    move_down 20
    stroke do
        dash(3, space: 3) # Set the dash pattern: 3 points dash, 3 points space
        stroke_color "000000"
        stroke_horizontal_line bounds.left, bounds.right, at: cursor
        undash # Reset the dash pattern to solid line after drawing
    end
    coin_table_data = [["Coin", "Quantity"]]
    coin_change.each do |coin, count|
        coin_table_data << ["Kshs #{coin}", (count).round(0)]
    end

    table(coin_table_data, header: true, width: bounds.width) do
        cells.padding = 2
        cells.borders = []
        cells.font_style = :italic
        row(0).font_style = :bold 
        row(0).borders = [:bottom]
        row(0).border_width = 1
        row(0).border_color = "000000"
        column(1).align = :right
    end

    # Define the star character and the font size
    star = '*'
    font_size = 11

    # Calculate the width of a single star character
    star_width = width_of(star, size: font_size)

    # Calculate the number of stars needed to span the width of the bounds
    num_stars = (bounds.width / star_width).floor

    # Generate the star line
    star_line = star * num_stars

    # Draw the star line at the current cursor position
    text_box star_line, at: [bounds.left, cursor], width: bounds.width, height: font_size, size: font_size, overflow: :shrink_to_fit

    # Move the cursor down to avoid overlap with subsequent text
    move_down font_size + 2

    move_down 5

    text "Thank you for shopping with us!", style: :italic, align: :center

    # Your were served by
    text "You were served by: #{server_name}", style: :bold, align: :center
    
    # Determine the position to center the QR code
    qr_code_x_position = (bounds.width - 100) / 2

    # Calculate the y-coordinate for the QR code bounding box
    qr_code_y_position = 60

    # Calculate the width of the text
    text_width = width_of("Scan the QR Code")

    # Calculate the x-coordinate for the text to center it horizontally
    text_x_position = (bounds.width - text_width) / 2 

    # Calculate the y-coordinate for the text
    text_y_position = qr_code_y_position + 8  # Adjusted to be closer to the QR code

    # Place the text
    text_box "Scan the QR Code", at: [text_x_position, text_y_position], size: 10

    # Place the QR code below the text
    bounding_box([qr_code_x_position, qr_code_y_position], width: 100, height: 100) do
        image StringIO.new(qr_png.to_s), width: 100, height: 100
    end
end
